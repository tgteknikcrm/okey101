import 'package:okey101/domain/ai/bot_brain.dart';
import 'package:okey101/domain/ai/bot_utils.dart';
import 'package:okey101/domain/ai/discard_strategy.dart';
import 'package:okey101/domain/ai/hand_evaluator.dart';
import 'package:okey101/domain/ai/seen_tiles.dart';
import 'package:okey101/domain/engine/random_source.dart';
import 'package:okey101/domain/models/game_action.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/player_view.dart';

/// Uses the solver properly and keeps an eye on the player to its right.
///
/// Compares the hand with and without the tile on offer instead of guessing,
/// opens when the lay-down is genuinely there, works tiles onto the table, and
/// avoids handing its right-hand neighbour anything obviously useful. It does
/// not model what the other players are holding.
class MediumBot implements BotBrain {
  const MediumBot();

  @override
  BotDifficulty get difficulty => BotDifficulty.medium;

  @override
  GameAction decide(PlayerView view, RandomSource rng) {
    if (view.phase == TurnPhase.awaitingDraw) {
      return _draw(view);
    }
    return _play(view, rng);
  }

  GameAction _draw(PlayerView view) {
    final top = view.leftNeighbour.topDiscard;
    if (top == null || !BotUtils.canTakeDiscard(view)) {
      return view.drawPileCount > 0
          ? const GameAction.drawFromPile()
          : const GameAction.drawFromDiscard();
    }
    if (view.drawPileCount == 0) return const GameAction.drawFromDiscard();

    final solver = BotUtils.solverFor(view);
    final without = solver.minimizeDeadwood(view.hand).deadwood;
    final with_ = solver.minimizeDeadwood([...view.hand, top]).deadwood;
    // Taking a tile also means giving up a blind draw, so it has to pay for
    // itself by more than its own face value.
    return with_ < without
        ? const GameAction.drawFromDiscard()
        : const GameAction.drawFromPile();
  }

  GameAction _play(PlayerView view, RandomSource rng) {
    final seen = SeenTiles.fromView(view);
    final evaluation = HandEvaluator.evaluate(view, seen: seen);

    if (!view.hasOpened) {
      final opening = BotUtils.openingFor(view);
      if (opening != null) {
        return GameAction.open(melds: opening.toProposals());
      }
      final pairs = BotUtils.pairsOpeningFor(view);
      // Only take the pairs road when the normal one is clearly not coming.
      if (pairs != null &&
          pairs.length >= view.ruleSet.minPairsToOpen + 1 &&
          evaluation.bestPoints < view.ruleSet.openThreshold - 30) {
        return GameAction.layPairs(
          pairs: pairs.map((p) => p.toProposal()).toList(),
        );
      }
    } else if (view.openedWithPairs) {
      final finishing = _pairsFinish(view);
      if (finishing != null) return finishing;
    } else if (view.hand.length > 1) {
      final additions = BotUtils.tableAdditions(view);
      if (additions.isNotEmpty) {
        final pick = additions.first;
        return GameAction.addToMeld(
          meldId: pick.meldId,
          tileId: pick.tileId,
          atStart: pick.atStart,
        );
      }
      final extra = _extraMeld(view);
      if (extra != null) return extra;
    }

    return GameAction.discard(
      tileId: DiscardStrategy.choose(
        view,
        evaluation: evaluation,
        seen: seen,
        defensiveness: 0.4,
      ).id,
    );
  }

  /// A second lay-down after opening, if the rules allow it and it uses tiles
  /// the hand would otherwise carry as deadwood.
  GameAction? _extraMeld(PlayerView view) {
    if (!view.ruleSet.canLayNewMeldsAfterOpening) return null;
    final solution = BotUtils.solverFor(view).minimizeDeadwood(view.hand);
    if (solution.melds.isEmpty) return null;
    final meld = solution.melds.first;
    if (!BotUtils.meldLeavesALegalDiscard(view, meld)) return null;
    return GameAction.layMeld(meld: meld.toProposal());
  }

  GameAction? _pairsFinish(PlayerView view) {
    final pairs = BotUtils.solverFor(view).bestPairs(view.hand);
    if (pairs.isEmpty) return null;
    final onTable =
        view.table.where((m) => m.ownerSeat == view.seat).length;
    final used = <int>{
      for (final pair in pairs)
        for (final tile in pair.tiles) tile.id,
    };
    if (onTable + pairs.length >= view.ruleSet.pairsToFinish &&
        used.length == view.hand.length) {
      return GameAction.layPairs(
        pairs: pairs.map((p) => p.toProposal()).toList(),
      );
    }
    return null;
  }
}
