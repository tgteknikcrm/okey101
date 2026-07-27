import 'package:okey101/domain/ai/bot_utils.dart';
import 'package:okey101/domain/ai/seen_tiles.dart';
import 'package:okey101/domain/models/player_view.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/meld_solver.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

/// A hand's worth right now plus what it could become.
class HandEvaluation {
  const HandEvaluation({
    required this.bestPoints,
    required this.deadwood,
    required this.potential,
    required this.deadTiles,
    required this.pairCount,
    required this.canOpenNow,
    required this.finishingDiscard,
    required this.bestSolution,
    required this.deadwoodSolution,
  });

  /// Highest lay-down the hand can currently make.
  final int bestPoints;

  /// Face value left over under the best deadwood partition.
  final int deadwood;

  /// Weighted value of near-complete melds, discounted by how likely the
  /// missing tiles still are.
  final double potential;

  /// Tiles with no reachable partner left: every copy they need is already
  /// visible somewhere.
  final List<Tile> deadTiles;

  /// How many pairs the hand can show, for the pairs-path decision.
  final int pairCount;

  final bool canOpenNow;

  /// The tile to throw if the hand can go out this turn, else null.
  final Tile? finishingDiscard;

  final MeldSolution bestSolution;
  final MeldSolution deadwoodSolution;

  /// Single number a bot can compare across candidate hands. Higher is better.
  double get score => potential - deadwood.toDouble();
}

/// Scores a hand's *potential*, not just the melds it already has.
abstract final class HandEvaluator {
  /// A two-sided draw is worth more than an inside draw, so partial runs and
  /// partial sets are weighted by how many distinct tiles complete them.
  static HandEvaluation evaluate(
    PlayerView view, {
    SeenTiles? seen,
    bool includeFinishCheck = true,
  }) {
    final semantics = BotUtils.semanticsOf(view);
    final solver = MeldSolver(semantics);
    final tracker = seen ?? SeenTiles.fromView(view);

    final best = solver.maximizePoints(view.hand);
    final lean = solver.minimizeDeadwood(view.hand);
    final threshold = view.ruleSet.openThresholdFor(view.openedCount);

    final leftovers = lean.leftovers;
    var potential = 0.0;
    final dead = <Tile>[];

    for (var i = 0; i < leftovers.length; i++) {
      final tile = leftovers[i];
      if (semantics.isWild(tile)) {
        // A wild is never dead and is worth holding on its own.
        potential += 12;
        continue;
      }
      final identity = semantics.fixedIdentity(tile);
      final wants = _completionsFor(identity, leftovers, semantics, i);
      if (wants.isEmpty) {
        dead.add(tile);
        continue;
      }
      var bestChance = 0.0;
      for (final want in wants) {
        final chance = tracker.availability(want.needed);
        final value = chance * want.value;
        if (value > bestChance) bestChance = value;
      }
      potential += bestChance;
    }

    return HandEvaluation(
      bestPoints: best.points,
      deadwood: lean.deadwood,
      potential: potential,
      deadTiles: dead,
      pairCount: solver.bestPairs(view.hand).length,
      canOpenNow: !view.hasOpened && best.points >= threshold,
      finishingDiscard: includeFinishCheck ? solver.canFinish(view.hand) : null,
      bestSolution: best,
      deadwoodSolution: lean,
    );
  }

  /// Which single tiles would turn a partial group involving [identity] into a
  /// real meld, and roughly what that meld would be worth.
  static List<({TileIdentity needed, double value})> _completionsFor(
    TileIdentity identity,
    List<Tile> leftovers,
    TileSemantics semantics,
    int selfIndex,
  ) {
    final others = <TileIdentity>[];
    for (var i = 0; i < leftovers.length; i++) {
      if (i == selfIndex) continue;
      if (semantics.isWild(leftovers[i])) continue;
      others.add(semantics.fixedIdentity(leftovers[i]));
    }

    final wants = <({TileIdentity needed, double value})>[];

    // Partial run: this tile plus a neighbour, needing the tile beyond.
    for (final other in others) {
      if (other.color != identity.color) continue;
      final gap = other.number - identity.number;
      if (gap == 1 && identity.number - 1 >= 1) {
        wants.add((
          needed: TileIdentity(
            color: identity.color,
            number: identity.number - 1,
          ),
          value: identity.number * 1.6,
        ));
      }
      if (gap == 1 && other.number + 1 <= 13) {
        wants.add((
          needed: TileIdentity(color: identity.color, number: other.number + 1),
          value: other.number * 1.6,
        ));
      }
      // Inside draw: 5 and 7 want the 6. Worth less than a two-sided run.
      if (gap == 2) {
        wants.add((
          needed: TileIdentity(
            color: identity.color,
            number: identity.number + 1,
          ),
          value: (identity.number + 1) * 1.1,
        ));
      }
    }

    // Partial set: this tile plus the same number in another colour.
    final sameNumberColors = <TileColor>{
      for (final other in others)
        if (other.number == identity.number) other.color,
    };
    if (sameNumberColors.isNotEmpty) {
      for (final color in TileColor.values) {
        if (color == identity.color) continue;
        if (sameNumberColors.contains(color)) continue;
        wants.add((
          needed: TileIdentity(color: color, number: identity.number),
          value: identity.number * 1.8,
        ));
      }
    }

    return wants;
  }
}
