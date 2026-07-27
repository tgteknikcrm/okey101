import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/hand_result.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/scoring.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

/// Turns a finished hand into scoreboard lines.
///
/// Penalties are data, not conditionals: the finish type selects a row and the
/// row says what each player writes. In particular there is no `if` for the
/// exhausted-deck case - it is simply the `exhausted` row, whose never-opened
/// penalty is a deadwood multiple rather than a flat number, because the flat
/// penalty is the price of failing to open *while someone else won*.
abstract final class ScoreCalculator {
  /// The row that would be applied when the deck runs out under
  /// [DeckExhaustedPolicy.voidHand]: nobody writes anything.
  static const ScoringRow voidRow = ScoringRow(
    winnerPoints: null,
    opened: OpponentPenalty.flat(points: 0),
    notOpened: OpponentPenalty.flat(points: 0),
  );

  /// Scores the hand. [winnerSeat] and [finishType] are both null exactly when
  /// the draw pile ran out with nobody going out.
  static HandResult score({
    required GameState state,
    required int? winnerSeat,
    required FinishType? finishType,
  }) {
    final rules = state.ruleSet;
    final rowKey = finishType == null
        ? ScoreRowKey.exhausted
        : ScoreRowKey.fromFinishType(finishType);

    final row = finishType == null &&
            rules.onDeckExhausted == DeckExhaustedPolicy.voidHand
        ? voidRow
        : rules.scoringTable.rowFor(rowKey);

    final semantics = TileSemantics(
      indicatorIdentity: state.indicatorIdentity,
      okey: state.okey,
      ruleSet: rules,
    );

    final lines = <PlayerHandResult>[];
    for (final player in state.players) {
      final deadwood = semantics.deadwoodOf(player.hand);
      final delta = player.seat == winnerSeat
          ? (row.winnerPoints ?? 0)
          : (player.hasOpened ? row.opened : row.notOpened).apply(deadwood);
      lines.add(
        PlayerHandResult(
          seat: player.seat,
          deadwood: deadwood,
          hasOpened: player.hasOpened,
          delta: delta,
          total: player.score + delta,
        ),
      );
    }

    return HandResult(
      handNumber: state.handNumber,
      winnerSeat: winnerSeat,
      finishType: finishType,
      rowKey: rowKey,
      players: lines,
    );
  }

  /// True when the match should stop after the hand numbered [handNumber].
  static bool isMatchOver({
    required RuleSet rules,
    required int handNumber,
    required List<int> totals,
  }) {
    final handsDone = handNumber >= rules.handsPerMatch;
    final targetReached = totals.any((total) => total <= rules.targetScore);
    return switch (rules.matchEndMode) {
      MatchEndMode.handsOnly => handsDone,
      MatchEndMode.targetOnly => targetReached,
      MatchEndMode.both => handsDone || targetReached,
    };
  }

  /// Lowest cumulative score wins. Ties break to the lowest seat number, which
  /// keeps the result deterministic.
  static int matchWinner(List<int> totals) {
    var best = 0;
    for (var seat = 1; seat < totals.length; seat++) {
      if (totals[seat] < totals[best]) best = seat;
    }
    return best;
  }
}
