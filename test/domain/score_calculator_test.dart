import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/engine/score_calculator.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/hand_result.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/scoring.dart';
import 'package:okey101/domain/models/tile.dart';

import 'engine_support.dart';
import 'test_tiles.dart';

void main() {
  // Indicator black 1 -> the okey is black 2.
  final indicator = black(1);

  // Seat 0 goes out (empty rack).
  // Seat 1 opened,      deadwood 5 + 7      = 12
  // Seat 2 never opened, deadwood 3          = 3
  // Seat 3 never opened, deadwood 10 + okey  = 10 + 25 = 35
  const seat1Deadwood = 12;
  const seat2Deadwood = 3;
  const seat3Deadwood = 35;

  GameState finishedState({RuleSet rules = RulePresets.standard}) => buildState(
        indicator: indicator,
        hands: [
          const <Tile>[],
          [red(5), blue(7)],
          [black(3)],
          [yellow(10), black(2)],
        ],
        opened: const [true, true, false, false],
        rules: rules,
        drawPileSize: 0,
      );

  PlayerHandResult lineFor(HandResult result, int seat) =>
      result.players.firstWhere((line) => line.seat == seat);

  group('deadwood', () {
    test('an okey in hand counts 25 and a false joker counts the indicator',
        () {
      final state = buildState(
        indicator: indicator,
        hands: [
          const <Tile>[],
          [black(2), falseJoker0, blue(9)],
          const <Tile>[],
          const <Tile>[],
        ],
        opened: const [true, true, true, true],
        drawPileSize: 0,
      );
      final result = ScoreCalculator.score(
        state: state,
        winnerSeat: 0,
        finishType: FinishType.normal,
      );
      // 25 for the okey, 1 for the false joker (indicator is black 1), 9.
      expect(lineFor(result, 1).deadwood, 35);
    });
  });

  group('every finish type against opened and never-opened opponents', () {
    const expected = <FinishType, ({int winner, int openedMul, int flat})>{
      FinishType.normal: (winner: -101, openedMul: 1, flat: 202),
      FinishType.head: (winner: -202, openedMul: 1, flat: 404),
      FinishType.pairs: (winner: -202, openedMul: 2, flat: 404),
      FinishType.withOkey: (winner: -202, openedMul: 2, flat: 404),
      FinishType.okeyHead: (winner: -404, openedMul: 2, flat: 808),
      FinishType.pairsWithOkey: (winner: -404, openedMul: 4, flat: 808),
    };

    for (final entry in expected.entries) {
      test('${entry.key.name} scores the whole table correctly', () {
        final result = ScoreCalculator.score(
          state: finishedState(),
          winnerSeat: 0,
          finishType: entry.key,
        );

        expect(result.finishType, entry.key);
        expect(result.rowKey, ScoreRowKey.fromFinishType(entry.key));
        expect(lineFor(result, 0).delta, entry.value.winner);
        expect(lineFor(result, 0).deadwood, 0);
        expect(
          lineFor(result, 1).delta,
          seat1Deadwood * entry.value.openedMul,
        );
        // The flat penalty is independent of what is left in hand: seat 2 has 3
        // points of deadwood and seat 3 has 35, and both write the same number.
        expect(lineFor(result, 2).delta, entry.value.flat);
        expect(lineFor(result, 3).delta, entry.value.flat);
        expect(lineFor(result, 2).deadwood, seat2Deadwood);
        expect(lineFor(result, 3).deadwood, seat3Deadwood);
      });
    }

    test('all six finish types are covered', () {
      expect(expected.keys.toSet(), FinishType.values.toSet());
    });
  });

  group('deck exhausted with no winner', () {
    test('nobody wins, no flat penalty, everyone writes their deadwood', () {
      final result = ScoreCalculator.score(
        state: finishedState(),
        winnerSeat: null,
        finishType: null,
      );
      expect(result.winnerSeat, isNull);
      expect(result.rowKey, ScoreRowKey.exhausted);
      expect(result.deckExhausted, isTrue);
      expect(lineFor(result, 0).delta, 0);
      expect(lineFor(result, 1).delta, seat1Deadwood);
      // Never opened, but there is no winner to have lost to, so no flat 202.
      expect(lineFor(result, 2).delta, seat2Deadwood);
      expect(lineFor(result, 3).delta, seat3Deadwood);
    });

    test('the voidHand policy writes nothing at all', () {
      final result = ScoreCalculator.score(
        state: finishedState(
          rules: RulePresets.standard
              .copyWith(onDeckExhausted: DeckExhaustedPolicy.voidHand),
        ),
        winnerSeat: null,
        finishType: null,
      );
      for (final line in result.players) {
        expect(line.delta, 0);
      }
    });
  });

  group('the Aggressive preset', () {
    test('doubles every number in the table', () {
      final result = ScoreCalculator.score(
        state: finishedState(rules: RulePresets.aggressive),
        winnerSeat: 0,
        finishType: FinishType.normal,
      );
      expect(lineFor(result, 0).delta, -202);
      expect(lineFor(result, 1).delta, seat1Deadwood * 2);
      expect(lineFor(result, 2).delta, 404);
    });
  });

  group('running totals', () {
    test('deltas accumulate onto each player score', () {
      final state = buildState(
        indicator: indicator,
        hands: [
          const <Tile>[],
          [red(5), blue(7)],
          [black(3)],
          [yellow(10), black(2)],
        ],
        opened: const [true, true, false, false],
        scores: const [-50, 120, 0, 300],
        drawPileSize: 0,
      );
      final result = ScoreCalculator.score(
        state: state,
        winnerSeat: 0,
        finishType: FinishType.normal,
      );
      expect(lineFor(result, 0).total, -151);
      expect(lineFor(result, 1).total, 132);
      expect(lineFor(result, 2).total, 202);
      expect(lineFor(result, 3).total, 502);
    });
  });

  group('match end conditions', () {
    const rules = RulePresets.standard;

    test('both: hand count or target score, whichever comes first', () {
      expect(
        ScoreCalculator.isMatchOver(
          rules: rules,
          handNumber: 11,
          totals: const [0, 0, 0, 0],
        ),
        isTrue,
      );
      expect(
        ScoreCalculator.isMatchOver(
          rules: rules,
          handNumber: 3,
          totals: const [-500, 0, 0, 0],
        ),
        isTrue,
      );
      expect(
        ScoreCalculator.isMatchOver(
          rules: rules,
          handNumber: 3,
          totals: const [-499, 0, 0, 0],
        ),
        isFalse,
      );
    });

    test('handsOnly ignores the target score', () {
      final handsOnly = rules.copyWith(matchEndMode: MatchEndMode.handsOnly);
      expect(
        ScoreCalculator.isMatchOver(
          rules: handsOnly,
          handNumber: 3,
          totals: const [-900, 0, 0, 0],
        ),
        isFalse,
      );
    });

    test('targetOnly ignores the hand count', () {
      final targetOnly = rules.copyWith(matchEndMode: MatchEndMode.targetOnly);
      expect(
        ScoreCalculator.isMatchOver(
          rules: targetOnly,
          handNumber: 99,
          totals: const [0, 0, 0, 0],
        ),
        isFalse,
      );
    });

    test('the lowest cumulative score wins', () {
      expect(ScoreCalculator.matchWinner(const [100, -50, 20, 300]), 1);
      expect(ScoreCalculator.matchWinner(const [-5, -5, 20, 300]), 0);
    });
  });
}
