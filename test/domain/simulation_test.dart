import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/ai/bot_brain.dart';
import 'package:okey101/domain/ai/easy_bot.dart';
import 'package:okey101/domain/ai/hard_bot.dart';
import 'package:okey101/domain/ai/medium_bot.dart';
import 'package:okey101/domain/ai/random_bot.dart';
import 'package:okey101/domain/engine/match_runner.dart';
import 'package:okey101/domain/engine/state_invariants.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/scoring.dart';

/// The CI simulation. The 10,000-game run lives in `tool/simulate.dart`, which
/// is deliberately not part of the suite.
void main() {
  const seededGames = 500;

  group('$seededGames seeded games', () {
    late List<MatchOutcome> outcomes;

    setUpAll(() {
      outcomes = <MatchOutcome>[
        for (var seed = 1; seed <= seededGames; seed++)
          MatchRunner.run(
            ruleSet: RulePresets.standard,
            seed: seed,
            brains: List<BotBrain>.filled(kSeatCount, const RandomBot()),
          ),
      ];
    });

    test('no exceptions and no illegal bot moves', () {
      final issues = <String>[
        for (final outcome in outcomes)
          for (final issue in outcome.issues) 'seed ${outcome.seed} $issue',
      ];
      expect(issues.take(10), isEmpty, reason: '${issues.length} issues found');
    });

    test('every match terminates', () {
      final stuck = outcomes.where((o) => !o.completed).toList();
      expect(
        stuck.map((o) => o.seed).toList(),
        isEmpty,
        reason: '${stuck.length} matches hit the action budget',
      );
    });

    test('the 106-tile invariant holds in every final state', () {
      for (final outcome in outcomes) {
        expect(
          StateInvariants.violation(outcome.finalState),
          isNull,
          reason: 'seed ${outcome.seed}',
        );
        expect(outcome.finalState.allTiles().length, kTotalTiles);
      }
    });

    test('every match ends with a full scoreboard', () {
      for (final outcome in outcomes) {
        expect(outcome.finalState.phase, TurnPhase.matchOver);
        expect(outcome.hands, isNotEmpty);
        for (final hand in outcome.hands) {
          expect(hand.players.length, kSeatCount);
        }
        // Scores are the sum of every delta written for that seat.
        for (var seat = 0; seat < kSeatCount; seat++) {
          final expected = outcome.hands.fold<int>(
            0,
            (sum, hand) =>
                sum +
                hand.players.firstWhere((line) => line.seat == seat).delta,
          );
          expect(outcome.finalState.players[seat].score, expected);
        }
      }
    });

    test('a match stops at the hand limit or the target score', () {
      for (final outcome in outcomes) {
        final state = outcome.finalState;
        final reachedTarget = state.players
            .any((p) => p.score <= RulePresets.standard.targetScore);
        expect(
          state.handNumber >= RulePresets.standard.handsPerMatch ||
              reachedTarget,
          isTrue,
          reason: 'seed ${outcome.seed} stopped at hand ${state.handNumber}',
        );
      }
    });
  });

  group('replay determinism', () {
    test('a recorded action list reproduces an identical final state', () {
      for (var seed = 1; seed <= 40; seed++) {
        final outcome = MatchRunner.run(
          ruleSet: RulePresets.standard,
          seed: seed,
          brains: List<BotBrain>.filled(kSeatCount, const RandomBot()),
        );
        final replayed = MatchRunner.replay(
          ruleSet: RulePresets.standard,
          seed: seed,
          canonicalActions: outcome.canonicalActions,
        );
        expect(
          replayed,
          outcome.finalState,
          reason: 'seed $seed did not replay identically',
        );
      }
    });

    test('running the same seed twice gives the same actions', () {
      for (var seed = 100; seed <= 110; seed++) {
        final first = MatchRunner.run(
          ruleSet: RulePresets.standard,
          seed: seed,
          brains: List<BotBrain>.filled(kSeatCount, const RandomBot()),
        );
        final second = MatchRunner.run(
          ruleSet: RulePresets.standard,
          seed: seed,
          brains: List<BotBrain>.filled(kSeatCount, const RandomBot()),
        );
        expect(second.canonicalActions, first.canonicalActions);
        expect(second.finalState, first.finalState);
      }
    });

    test('a state survives a JSON round trip mid-match', () {
      final outcome = MatchRunner.run(
        ruleSet: RulePresets.standard,
        seed: 4242,
        brains: List<BotBrain>.filled(kSeatCount, const RandomBot()),
      );
      final restored = GameState.fromJson(outcome.finalState.toJson());
      expect(restored, outcome.finalState);
    });
  });

  group('real bots play legally', () {
    test('a mixed table of Hard, Medium and Easy never breaks a rule', () {
      final brains = <BotBrain>[
        const HardBot(),
        const MediumBot(),
        const EasyBot(),
        const RandomBot(),
      ];
      final issues = <String>[];
      var completed = 0;
      for (var seed = 1; seed <= 60; seed++) {
        final outcome = MatchRunner.run(
          ruleSet: RulePresets.standard,
          seed: seed,
          brains: brains,
        );
        if (outcome.completed) completed++;
        for (final issue in outcome.issues) {
          issues.add('seed $seed $issue');
        }
        expect(StateInvariants.violation(outcome.finalState), isNull);
      }
      expect(issues.take(10), isEmpty, reason: '${issues.length} issues');
      expect(completed, 60);
    });

    test('the aggressive preset also plays through cleanly', () {
      for (var seed = 1; seed <= 30; seed++) {
        final outcome = MatchRunner.run(
          ruleSet: RulePresets.aggressive,
          seed: seed,
          brains: <BotBrain>[
            const HardBot(),
            const MediumBot(),
            const EasyBot(),
            const RandomBot(),
          ],
        );
        expect(outcome.issues, isEmpty, reason: 'seed $seed');
        expect(outcome.completed, isTrue);
      }
    });

    test('real play reaches finishes, not only exhausted decks', () {
      final counts = <ScoreRowKey, int>{
        for (final key in ScoreRowKey.values) key: 0,
      };
      for (var seed = 1; seed <= 60; seed++) {
        final outcome = MatchRunner.run(
          ruleSet: RulePresets.standard,
          seed: seed,
          brains: <BotBrain>[
            const HardBot(),
            const MediumBot(),
            const HardBot(),
            const MediumBot(),
          ],
        );
        for (final hand in outcome.hands) {
          counts[hand.rowKey] = counts[hand.rowKey]! + 1;
        }
      }
      expect(counts[ScoreRowKey.normal], greaterThan(50));
      expect(counts[ScoreRowKey.head], greaterThan(0));
      expect(counts[ScoreRowKey.exhausted], greaterThan(0));
    });
  });
}
