import 'package:okey101/domain/ai/bot_utils.dart';
import 'package:okey101/domain/ai/hand_evaluator.dart';
import 'package:okey101/domain/ai/opponent_model.dart';
import 'package:okey101/domain/ai/seen_tiles.dart';
import 'package:okey101/domain/models/player_view.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

/// Picks the tile to throw.
///
/// The expensive part - partitioning the hand - is done ONCE per turn. Tiles
/// the best partition already uses are kept; the choice is made among the
/// leftovers, weighing what the tile costs to hold against what it gives the
/// player on the right.
abstract final class DiscardStrategy {
  static Tile choose(
    PlayerView view, {
    required HandEvaluation evaluation,
    required SeenTiles seen,

    /// 0 means pure self-interest, 1 means maximum caution about feeding the
    /// right-hand neighbour.
    double defensiveness = 0.0,

    /// Set when the bot has decided it wants rid of the okey.
    bool willingToDropOkey = false,

    /// Play for the 101 threshold instead of for a small rack.
    ///
    /// These two goals pull in opposite directions. Minimising deadwood wants
    /// the biggest tile gone; reaching 101 wants it kept, because face value is
    /// exactly what the threshold counts. Opening is worth far more than a few
    /// points of deadwood - a player who never opens pays a flat 202 whenever
    /// anybody goes out - so while the open is still live this wins.
    bool openingFocus = false,

    /// The hand is being played for pairs.
    ///
    /// Overrides the opening focus: on the pairs road runs and sets are worth
    /// nothing at all, so the usual partition has no say in what to throw.
    bool pairsFocus = false,
  }) {
    final semantics = BotUtils.semanticsOf(view);
    final legal = BotUtils.discardableTiles(view);
    final legalIds = legal.map((t) => t.id).toSet();

    if (pairsFocus) return _choosePairsRoad(view, legal, semantics, seen);

    // Throw from what the relevant partition does not already use.
    final keepFrom = openingFocus
        ? evaluation.bestSolution.leftovers
        : evaluation.deadwoodSolution.leftovers;
    var candidates = <Tile>[
      for (final tile in keepFrom)
        if (legalIds.contains(tile.id)) tile,
    ];
    if (candidates.isEmpty) candidates = legal;

    Tile? best;
    var bestScore = double.negativeInfinity;
    for (final tile in candidates) {
      final score = _discardScore(
        view,
        tile,
        semantics: semantics,
        seen: seen,
        defensiveness: defensiveness,
        willingToDropOkey: willingToDropOkey,
        deadTiles: evaluation.deadTiles,
        openingFocus: openingFocus,
      );
      if (score > bestScore) {
        bestScore = score;
        best = tile;
      }
    }
    return best ?? legal.first;
  }

  /// On the pairs road a tile is only ever one of three things: half of a pair,
  /// a single that might still find its twin, or a single that never will.
  ///
  /// Nothing else matters - not runs, not sets, not the face value the 101
  /// threshold counts - so the ordering really is that simple, and it is what
  /// turns a two-pair deal into a five-pair lay-down eight turns later.
  static Tile _choosePairsRoad(
    PlayerView view,
    List<Tile> legal,
    TileSemantics semantics,
    SeenTiles seen,
  ) {
    // How many of each identity the rack holds, so a tile can tell whether it
    // is already half of a pair.
    final held = <int, int>{};
    for (final tile in view.hand) {
      if (semantics.isWild(tile)) continue;
      held.update(
        semantics.fixedIdentity(tile).index,
        (n) => n + 1,
        ifAbsent: () => 1,
      );
    }

    Tile? best;
    var bestScore = double.negativeInfinity;
    for (final tile in legal) {
      // The okey stands in for any tile, so on this road it is the last thing
      // to leave the rack.
      if (semantics.isWild(tile)) continue;
      final identity = semantics.fixedIdentity(tile);
      final copies = held[identity.index] ?? 0;

      // Breaking a pair to throw one of its halves undoes a turn's work.
      var score = copies >= 2 ? -100.0 : 0.0;
      // A single whose twin is still out there is what the next draw is for; one
      // whose twins are all accounted for is dead weight.
      score += (1 - seen.availability(identity)) * 20;
      // Nothing to choose between two equally hopeless singles except the
      // deadwood they would cost if the hand never goes out.
      score += identity.number * 0.5;
      if (score > bestScore) {
        bestScore = score;
        best = tile;
      }
    }
    return best ?? legal.first;
  }

  /// Higher means "throw this one".
  static double _discardScore(
    PlayerView view,
    Tile tile, {
    required TileSemantics semantics,
    required SeenTiles seen,
    required double defensiveness,
    required bool willingToDropOkey,
    required List<Tile> deadTiles,
    required bool openingFocus,
  }) {
    if (semantics.isWild(tile)) {
      // Throwing the okey costs 25 deadwood and hands the table its best tile.
      // Only a bot that has decided the hand is lost should want to.
      return willingToDropOkey ? 5 : -1000;
    }

    final identity = semantics.fixedIdentity(tile);

    // Chasing the threshold, a small tile is the cheap thing to lose: it can
    // only ever contribute its face value to the 101. Playing for a small rack,
    // it is the opposite - the big tile is what hurts to be caught with.
    var score = openingFocus
        ? 14.0 - identity.number
        : identity.number.toDouble();

    // A tile whose partners are all visible will never become a meld.
    if (deadTiles.any((t) => t.id == tile.id)) score += openingFocus ? 20 : 14;

    // A tile still waiting on a live partner is worth keeping, and worth more
    // when the meld it would join is worth more.
    final keepWeight = openingFocus ? identity.number * 0.32 : 3.0;
    final runNeighbours = <TileIdentity>[
      if (identity.number > 1)
        TileIdentity(color: identity.color, number: identity.number - 1),
      if (identity.number < 13)
        TileIdentity(color: identity.color, number: identity.number + 1),
    ];
    for (final want in runNeighbours) {
      score -= seen.availability(want) * keepWeight;
    }
    for (final color in TileColor.values) {
      if (color == identity.color) continue;
      score -= seen.availability(
            TileIdentity(color: color, number: identity.number),
          ) *
          (openingFocus ? identity.number * 0.22 : 1.5);
    }

    // A second copy of something already in hand is redundant unless the bot
    // is on the pairs path.
    final duplicates = view.hand
        .where((t) =>
            !semantics.isWild(t) && semantics.fixedIdentity(t) == identity)
        .length;
    if (duplicates > 1 && !view.openedWithPairs) score += 2.5;

    if (defensiveness > 0) {
      // Scaled so that even at full caution the danger term can shift the
      // ordering without swamping the deadwood term: most hands end with the
      // deck exhausted, and those are decided purely on what is left on the
      // rack.
      score -= defensiveness *
          OpponentModel.dangerToRightNeighbour(view, tile) *
          0.22;
    }
    return score;
  }
}
