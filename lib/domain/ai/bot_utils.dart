import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/player_view.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/meld_solver.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

/// Helpers every bot needs, kept out of the brains themselves.
abstract final class BotUtils {
  static TileSemantics semanticsOf(PlayerView view) => TileSemantics(
        // The indicator is always a numbered tile; both false-joker policies
        // guarantee it.
        indicatorIdentity: view.indicator.printedIdentity!,
        okey: view.okey,
        ruleSet: view.ruleSet,
      );

  static MeldSolver solverFor(PlayerView view) =>
      MeldSolver(semanticsOf(view));

  /// True when this player may draw from the pile to their left right now.
  static bool canTakeDiscard(PlayerView view) {
    if (view.leftNeighbour.discards.isEmpty) return false;
    return view.hasOpened || view.ruleSet.canTakeDiscardBeforeOpening;
  }

  /// Tiles this player is allowed to discard this turn.
  ///
  /// A tile taken from a discard pile may not go straight back.
  static List<Tile> discardableTiles(PlayerView view) {
    final legal = <Tile>[
      for (final tile in view.hand)
        if (tile.id != view.takenFromDiscardTileId) tile,
    ];
    // Only reachable if the whole hand is the one taken tile, which the engine
    // also refuses; returning the raw hand keeps the caller from crashing.
    return legal.isEmpty ? view.hand : legal;
  }

  /// The opening lay-down the solver likes best, or null when the hand cannot
  /// reach the threshold.
  static MeldSolution? openingFor(PlayerView view) {
    if (view.hasOpened) return null;
    final solver = solverFor(view);
    final threshold = view.ruleSet.openThresholdFor(view.openedCount);
    final direct = solver.maximizePoints(view.hand);
    // Removing a tile can never raise the score, so a hand that cannot reach
    // the threshold with everything available cannot reach it at all. Checking
    // this first keeps the expensive search below off the hot path entirely.
    if (direct.points < threshold) return null;
    if (leavesALegalDiscard(view, direct.leftovers)) return direct;
    return _openingHoldingOneBack(view, solver, threshold);
  }

  /// A hand where every tile melds still has to end the turn with a discard.
  ///
  /// Without this, the strongest possible hand could never be opened at all:
  /// the best partition uses all 22 tiles, nothing is left to throw, and the
  /// lay-down is refused. Holding one tile back and solving the rest is what a
  /// player does by hand, and when it works it is a kafa finish.
  static MeldSolution? _openingHoldingOneBack(
    PlayerView view,
    MeldSolver solver,
    int threshold,
  ) {
    final semantics = semanticsOf(view);
    final candidates = discardableTiles(view)
      ..sort((a, b) {
        // Never hold the okey back if anything else will do.
        final aWild = semantics.isWild(a);
        final bWild = semantics.isWild(b);
        if (aWild != bWild) return aWild ? 1 : -1;
        return semantics
            .fixedIdentity(a)
            .number
            .compareTo(semantics.fixedIdentity(b).number);
      });

    final tried = <int>{};
    for (final held in candidates) {
      final signature =
          semantics.isWild(held) ? -1 : semantics.fixedIdentity(held).index;
      if (!tried.add(signature)) continue;
      final rest = <Tile>[
        for (final tile in view.hand)
          if (tile.id != held.id) tile,
      ];
      final solution = solver.maximizePoints(rest);
      if (solution.points >= threshold) return solution;
    }
    return null;
  }

  /// A lay-down is only playable if something legal is left to discard after
  /// it, because the turn must still end with a discard.
  static bool leavesALegalDiscard(PlayerView view, List<Tile> leftovers) {
    if (leftovers.isEmpty) return false;
    if (leftovers.length == 1 &&
        leftovers.single.id == view.takenFromDiscardTileId) {
      return false;
    }
    return true;
  }

  /// An opening that also goes out: every tile melded except one to discard,
  /// and still worth the threshold.
  ///
  /// This is the "kafa" line. It is worth -202 instead of -101, so it is always
  /// checked before an ordinary open. The 101 threshold applies to it exactly
  /// like any other opening.
  static MeldSolution? finishingOpeningFor(PlayerView view) {
    if (view.hasOpened) return null;
    final solution = solverFor(view).maximizeMeldedTiles(view.hand);
    if (solution.leftovers.length != 1) return null;
    if (solution.points < view.ruleSet.openThresholdFor(view.openedCount)) {
      return null;
    }
    if (!leavesALegalDiscard(view, solution.leftovers)) return null;
    return solution;
  }

  /// The opening that puts the MOST tiles down rather than the most points.
  ///
  /// Once the threshold is cleared, extra points on the table are worth
  /// nothing, while extra tiles off the rack are worth their face value in the
  /// exhausted-deck case and bring the hand closer to going out.
  static MeldSolution? denseOpeningFor(PlayerView view) => bestOpening(view);

  /// The opening to play, in one pass.
  ///
  /// The densest lay-down that clears the threshold is preferred: past the
  /// threshold extra points on the table buy nothing, while extra tiles off the
  /// rack buy both a smaller exhausted-deck score and a shorter road to going
  /// out. A kafa - everything melded but one tile - falls out of this naturally
  /// as the densest solution with exactly one leftover.
  ///
  /// Deliberately a single [MeldSolver.maximizeMeldedTiles] call plus at most
  /// one [MeldSolver.maximizePoints] call: this runs on every bot turn.
  static MeldSolution? bestOpening(PlayerView view) {
    if (view.hasOpened) return null;
    final solver = solverFor(view);
    final threshold = view.ruleSet.openThresholdFor(view.openedCount);
    final dense = solver.maximizeMeldedTiles(view.hand);
    if (dense.points >= threshold &&
        leavesALegalDiscard(view, dense.leftovers)) {
      return dense;
    }
    // Falls through to the hold-one-back path when everything melds.
    return openingFor(view);
  }

  /// True when laying [meld] still leaves something legal to discard.
  static bool meldLeavesALegalDiscard(PlayerView view, SolvedMeld meld) {
    final laid = meld.tiles.map((t) => t.id).toSet();
    return leavesALegalDiscard(
      view,
      <Tile>[
        for (final tile in view.hand)
          if (!laid.contains(tile.id)) tile,
      ],
    );
  }

  /// Pairs this player could lay to open on the pairs path, or null when there
  /// are not enough of them.
  static List<SolvedMeld>? pairsOpeningFor(PlayerView view) {
    if (view.hasOpened) return null;
    final pairs = solverFor(view).bestPairs(view.hand);
    if (pairs.length < view.ruleSet.minPairsToOpen) return null;
    final used = <int>{
      for (final pair in pairs)
        for (final tile in pair.tiles) tile.id,
    };
    final leftovers = <Tile>[
      for (final tile in view.hand)
        if (!used.contains(tile.id)) tile,
    ];
    final finishing = pairs.length >= view.ruleSet.pairsToFinish;
    if (!finishing && !leavesALegalDiscard(view, leftovers)) return null;
    // Never lay more than what is needed to go out.
    if (finishing && leftovers.isNotEmpty) return null;
    return pairs;
  }

  /// Every legal way to work a hand tile onto a table meld.
  ///
  /// Returned in table order then hand order, with no preference expressed:
  /// callers that care which option is best must sort for themselves.
  static List<({int meldId, int tileId, bool atStart})> tableAdditions(
    PlayerView view,
  ) {
    final semantics = semanticsOf(view);
    final out = <({int meldId, int tileId, bool atStart})>[];
    for (final meld in view.table) {
      if (meld.kind == MeldKind.pair) continue;
      final identities = meld.identities(semantics.indicatorIdentity);
      final jokersOnMeld =
          meld.jokerAssignments.where((a) => a != null).length;
      for (final tile in view.hand) {
        final identity = semantics.fixedIdentity(tile);
        final wild = semantics.isWild(tile);
        // Adding a wild to a meld that already carries its quota is illegal.
        if (wild && jokersOnMeld >= view.ruleSet.maxJokersPerMeld) continue;
        // The turn still has to end with a discard, and the tile taken from a
        // discard pile may not go straight back.
        if (!leavesALegalDiscard(
          view,
          <Tile>[
            for (final other in view.hand)
              if (other.id != tile.id) other,
          ],
        )) {
          continue;
        }
        if (meld.kind == MeldKind.run) {
          final low = identities.first.number - 1;
          final high = identities.last.number + 1;
          final color = identities.first.color;
          if (high <= 13 &&
              (wild ||
                  (identity.color == color && identity.number == high))) {
            out.add((meldId: meld.id, tileId: tile.id, atStart: false));
          }
          if (low >= 1 &&
              (wild || (identity.color == color && identity.number == low))) {
            out.add((meldId: meld.id, tileId: tile.id, atStart: true));
          }
        } else if (meld.tiles.length < 4) {
          final number = identities.first.number;
          final used = identities.map((i) => i.color).toSet();
          if (wild && used.length < 4) {
            out.add((meldId: meld.id, tileId: tile.id, atStart: false));
          } else if (!wild &&
              identity.number == number &&
              !used.contains(identity.color)) {
            out.add((meldId: meld.id, tileId: tile.id, atStart: false));
          }
        }
      }
    }
    return out;
  }

  /// How much better the hand gets if [candidate] is taken in and something
  /// else thrown away. Positive means the draw helps.
  static int deadwoodAfterTaking(PlayerView view, Tile candidate) {
    final solver = solverFor(view);
    final withTile = <Tile>[...view.hand, candidate];
    return solver.minimizeDeadwood(withTile).deadwood;
  }

  /// The seat that receives this player's discards.
  static int rightNeighbourSeat(PlayerView view) => seatToRightOf(view.seat);
}
