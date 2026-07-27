import 'package:okey101/domain/ai/bot_brain.dart';
import 'package:okey101/domain/ai/bot_utils.dart';
import 'package:okey101/domain/engine/random_source.dart';
import 'package:okey101/domain/models/game_action.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/player_view.dart';

/// Plays legal but unmotivated moves.
///
/// This is the load generator for `tool/simulate.dart`: it exercises every code
/// path in the engine cheaply, without the solver work the real bots do. It
/// still never plays an illegal move, which is what makes it useful as a
/// fuzzing harness for the rules.
class RandomBot implements BotBrain {
  const RandomBot();

  @override
  BotDifficulty get difficulty => BotDifficulty.easy;

  @override
  GameAction decide(PlayerView view, RandomSource rng) {
    if (view.phase == TurnPhase.awaitingDraw) {
      if (BotUtils.canTakeDiscard(view) &&
          (view.drawPileCount == 0 || rng.nextBool(0.25))) {
        return const GameAction.drawFromDiscard();
      }
      return const GameAction.drawFromPile();
    }

    if (!view.hasOpened) {
      if (rng.nextBool(0.15)) {
        final pairs = BotUtils.pairsOpeningFor(view);
        if (pairs != null) {
          return GameAction.layPairs(
            pairs: pairs.map((p) => p.toProposal()).toList(),
          );
        }
      }
      final opening = BotUtils.openingFor(view);
      if (opening != null) {
        return GameAction.open(melds: opening.toProposals());
      }
    } else if (view.openedWithPairs) {
      final more = BotUtils.pairsToLayAfterOpening(view);
      if (more != null) {
        return GameAction.layPairs(
          pairs: more.map((p) => p.toProposal()).toList(),
        );
      }
    } else if (rng.nextBool(0.6)) {
      final additions = BotUtils.tableAdditions(view);
      if (additions.isNotEmpty && view.hand.length > 1) {
        final pick = additions[rng.nextInt(additions.length)];
        return GameAction.addToMeld(
          meldId: pick.meldId,
          tileId: pick.tileId,
          atStart: pick.atStart,
        );
      }
    }

    final candidates = BotUtils.discardableTiles(view);
    return GameAction.discard(tileId: rng.pick(candidates).id);
  }
}
