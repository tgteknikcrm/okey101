import 'package:okey101/domain/ai/bot_brain.dart';
import 'package:okey101/domain/engine/dealer.dart';
import 'package:okey101/domain/engine/engine_result.dart';
import 'package:okey101/domain/engine/game_engine.dart';
import 'package:okey101/domain/engine/player_view_factory.dart';
import 'package:okey101/domain/engine/random_source.dart';
import 'package:okey101/domain/engine/score_calculator.dart';
import 'package:okey101/domain/engine/state_invariants.dart';
import 'package:okey101/domain/models/game_action.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/hand_result.dart';
import 'package:okey101/domain/models/rule_set.dart';

/// Something that should never happen during a simulated match.
class MatchIssue {
  const MatchIssue({
    required this.handNumber,
    required this.seat,
    required this.message,
  });

  final int handNumber;
  final int seat;
  final String message;

  @override
  String toString() => 'hand $handNumber seat $seat: $message';
}

class MatchOutcome {
  const MatchOutcome({
    required this.seed,
    required this.finalState,
    required this.canonicalActions,
    required this.issues,
    required this.actionCount,
    required this.completed,
  });

  final int seed;
  final GameState finalState;

  /// The replay log. `(seed, canonicalActions)` reproduces this match exactly.
  final List<GameAction> canonicalActions;
  final List<MatchIssue> issues;
  final int actionCount;

  /// False when the action budget ran out, which would mean a soft-lock.
  final bool completed;

  List<HandResult> get hands => finalState.history;

  int get winnerSeat =>
      ScoreCalculator.matchWinner(finalState.players.map((p) => p.score).toList());

  bool get clean => issues.isEmpty && completed;
}

/// Plays complete matches head-to-head. Pure: no clock, no ambient randomness.
///
/// Used by `tool/simulate.dart` and by the CI simulation test.
abstract final class MatchRunner {
  /// Derives the bot decision stream from the match seed so a rerun of the same
  /// seed produces byte-identical play.
  static const int botSeedSalt = 0x5BF03635;

  static MatchOutcome run({
    required RuleSet ruleSet,
    required int seed,
    required List<BotBrain> brains,
    List<String>? names,
    int maxActions = 40000,
    bool checkInvariants = true,
  }) {
    final playerNames = names ?? Dealer.defaultNames;
    var state = Dealer.newMatch(
      ruleSet: ruleSet,
      seed: seed,
      names: playerNames,
      humans: List<bool>.filled(kSeatCount, false),
    );

    final botRng = RandomSource(seed ^ botSeedSalt);
    final actions = <GameAction>[];
    final issues = <MatchIssue>[];
    var count = 0;

    while (!state.isMatchOver && count < maxActions) {
      if (checkInvariants) {
        final problem = StateInvariants.violation(state);
        if (problem != null) {
          issues.add(
            MatchIssue(
              handNumber: state.handNumber,
              seat: state.currentSeat,
              message: 'invariant broken: $problem',
            ),
          );
          break;
        }
      }

      if (state.phase == TurnPhase.handOver) {
        final result = GameEngine.apply(state, const GameAction.startNextHand());
        if (result is EngineErr) {
          issues.add(
            MatchIssue(
              handNumber: state.handNumber,
              seat: state.currentSeat,
              message: 'could not start the next hand: ${result.error}',
            ),
          );
          break;
        }
        actions.add(const GameAction.startNextHand());
        state = (result as EngineOk).state;
        count++;
        continue;
      }

      final seat = state.currentSeat;
      final view = PlayerViewFactory.forSeat(state, seat);
      final action = brains[seat].decide(view, botRng);
      final result = GameEngine.apply(state, action);
      count++;

      if (result is EngineErr) {
        issues.add(
          MatchIssue(
            handNumber: state.handNumber,
            seat: seat,
            message: 'illegal ${action.runtimeType}: ${result.error}',
          ),
        );
        // Recover with a guaranteed-legal move so the match still terminates
        // and one bad decision does not mask everything after it.
        final fallback = _fallbackFor(state);
        final recovered = GameEngine.apply(state, fallback);
        if (recovered is EngineErr) {
          issues.add(
            MatchIssue(
              handNumber: state.handNumber,
              seat: seat,
              message: 'fallback also illegal: ${recovered.error}',
            ),
          );
          break;
        }
        actions.add(fallback);
        state = (recovered as EngineOk).state;
        continue;
      }

      actions.add(action);
      state = (result as EngineOk).state;
    }

    return MatchOutcome(
      seed: seed,
      finalState: state,
      canonicalActions: actions,
      issues: issues,
      actionCount: count,
      completed: state.isMatchOver,
    );
  }

  /// Replays a recorded action list from a fresh deal of the same seed.
  ///
  /// Used to prove determinism: the final state must be identical.
  static GameState replay({
    required RuleSet ruleSet,
    required int seed,
    required List<GameAction> canonicalActions,
    List<String>? names,
  }) {
    var state = Dealer.newMatch(
      ruleSet: ruleSet,
      seed: seed,
      names: names ?? Dealer.defaultNames,
      humans: List<bool>.filled(kSeatCount, false),
    );
    for (final action in canonicalActions) {
      final result = GameEngine.apply(state, action);
      if (result is EngineErr) {
        throw StateError('replay diverged on $action: ${result.error}');
      }
      state = (result as EngineOk).state;
    }
    return state;
  }

  static GameAction _fallbackFor(GameState state) {
    if (state.phase == TurnPhase.awaitingDraw) {
      if (state.drawPile.isNotEmpty) return const GameAction.drawFromPile();
      return const GameAction.drawFromDiscard();
    }
    final hand = state.currentPlayer.hand;
    for (final tile in hand) {
      if (tile.id != state.takenFromDiscardTileId) {
        return GameAction.discard(tileId: tile.id);
      }
    }
    return GameAction.discard(tileId: hand.first.id);
  }
}
