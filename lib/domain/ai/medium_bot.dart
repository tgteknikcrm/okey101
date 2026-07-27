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
    // On the pairs road the twin of a tile already held is the whole point of
    // drawing; the deadwood comparison below is about runs and sets and would
    // pass it over.
    if (!view.hasOpened && BotUtils.completesAPair(view, top)) {
      final road = BotUtils.pairsRoad(
        view,
        bestPoints: solver.maximizePoints(view.hand).points,
      );
      if (road.committed) return const GameAction.drawFromDiscard();
    }

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
    final road = BotUtils.pairsRoad(view, bestPoints: evaluation.bestPoints);

    if (!view.hasOpened) {
      // Pairs first: the road only commits while the normal lay-down is out of
      // reach, and by the time there are five of them the rack has been played
      // for pairs for several turns and holds little else.
      if (road.committed) {
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
        pairsFocus: road.committed,
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

}
