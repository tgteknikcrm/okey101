import 'package:okey101/domain/ai/bot_brain.dart';
import 'package:okey101/domain/ai/bot_utils.dart';
import 'package:okey101/domain/ai/discard_strategy.dart';
import 'package:okey101/domain/ai/hand_evaluator.dart';
import 'package:okey101/domain/ai/opponent_model.dart';
import 'package:okey101/domain/ai/seen_tiles.dart';
import 'package:okey101/domain/engine/random_source.dart';
import 'package:okey101/domain/models/game_action.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/player_view.dart';
import 'package:okey101/domain/models/tile.dart';

/// Plays the whole table, not just its own rack.
///
/// On top of what MediumBot does it:
///  * tracks every tile it has seen and prices draws by what is still live;
///  * estimates how close each opponent is to opening;
///  * holds the okey while a high-value finish is reachable and dumps it when
///    the hand has gone bad;
///  * takes the pairs road when the rack skews to duplicates;
///  * gets steadily more defensive as the 20-tile pile empties;
///  * weighs the flat never-opened penalty against holding out for more.
class HardBot implements BotBrain {
  const HardBot();

  /// Draws left in a hand once the pile is this low: time to stop dreaming.
  static const int lateGameDrawsLeft = 7;

  @override
  BotDifficulty get difficulty => BotDifficulty.hard;

  @override
  GameAction decide(PlayerView view, RandomSource rng) {
    final seen = SeenTiles.fromView(view);
    if (view.phase == TurnPhase.awaitingDraw) {
      return _draw(view, seen);
    }
    return _play(view, seen, rng);
  }

  GameAction _draw(PlayerView view, SeenTiles seen) {
    final top = view.leftNeighbour.topDiscard;
    if (top == null || !BotUtils.canTakeDiscard(view)) {
      return view.drawPileCount > 0
          ? const GameAction.drawFromPile()
          : const GameAction.drawFromDiscard();
    }
    if (view.drawPileCount == 0) return const GameAction.drawFromDiscard();

    final semantics = BotUtils.semanticsOf(view);
    // The okey off a discard pile is always worth taking.
    if (semantics.isWild(top)) return const GameAction.drawFromDiscard();

    final solver = BotUtils.solverFor(view);
    final withTop = <Tile>[...view.hand, top];

    // The single most valuable draw in the game: one that turns a hand that
    // cannot open into one that can. Failing to open costs a flat 202 whenever
    // anybody goes out, which dwarfs every deadwood consideration.
    if (!view.hasOpened) {
      final threshold = view.ruleSet.openThresholdFor(view.openedCount);
      if (solver.maximizePoints(view.hand).points < threshold &&
          solver.maximizePoints(withTop).points >= threshold) {
        return const GameAction.drawFromDiscard();
      }
    } else if (solver.canFinish(view.hand) == null &&
        solver.canFinish(withTop) != null) {
      // Second most valuable: the tile that lets the hand go out.
      return const GameAction.drawFromDiscard();
    }

    final without = solver.minimizeDeadwood(view.hand);
    final with_ = solver.minimizeDeadwood(withTop);
    final gain = without.deadwood - with_.deadwood;

    // There are only 20 draws in a whole hand, so a tile that measurably
    // improves the rack beats a blind one. Being pickier than this was
    // measurably worse in simulation.
    if (gain > 0) return const GameAction.drawFromDiscard();

    // Late in the hand, a tile that at least does not hurt still beats a
    // lottery ticket, because there is no time left to use a lucky draw.
    if (view.drawPileCount <= lateGameDrawsLeft && gain >= 0) {
      final semantics = BotUtils.semanticsOf(view);
      final identity = semantics.fixedIdentity(top);
      // ...unless it is a big tile that would just add deadwood.
      if (identity.number <= 6) return const GameAction.drawFromDiscard();
    }
    return const GameAction.drawFromPile();
  }

  GameAction _play(PlayerView view, SeenTiles seen, RandomSource rng) {
    final evaluation = HandEvaluator.evaluate(view, seen: seen);
    final beliefs = OpponentModel.beliefs(view);

    if (!view.hasOpened) {
      final action = _openingDecision(view, evaluation, beliefs);
      if (action != null) return action;
    } else if (view.openedWithPairs) {
      final finishing = _pairsFinish(view);
      if (finishing != null) return finishing;
    } else {
      final action = _afterOpening(view, evaluation);
      if (action != null) return action;
    }

    return GameAction.discard(
      tileId: _discard(view, evaluation, seen, beliefs).id,
    );
  }

  GameAction? _openingDecision(
    PlayerView view,
    HandEvaluation evaluation,
    List<OpponentBelief> beliefs,
  ) {
    // Going out in one turn from a full hand is the biggest score at the table.
    // The rules require a kafa to clear the opening threshold like any other
    // open, so this is only ever offered when it genuinely does.
    final kafa = BotUtils.finishingOpeningFor(view);
    if (kafa != null) {
      return GameAction.open(melds: kafa.toProposals());
    }

    // Past the threshold, extra points on the table buy nothing; extra tiles
    // off the rack buy both a smaller exhausted-deck score and a shorter road
    // to going out.
    final opening = BotUtils.denseOpeningFor(view);
    if (opening != null) {
      return GameAction.open(melds: opening.toProposals());
    }

    final pairs = BotUtils.pairsOpeningFor(view);
    if (pairs != null && _pairsRoadIsBetter(view, evaluation, pairs.length)) {
      return GameAction.layPairs(
        pairs: pairs.map((p) => p.toProposal()).toList(),
      );
    }
    return null;
  }

  /// The pairs road pays 202 and doubles what the opponents write, but it
  /// forfeits runs and sets entirely. Worth it when the rack is full of
  /// duplicates and the normal lay-down is a long way off.
  bool _pairsRoadIsBetter(
    PlayerView view,
    HandEvaluation evaluation,
    int pairCount,
  ) {
    if (pairCount < view.ruleSet.minPairsToOpen) return false;
    if (pairCount >= view.ruleSet.pairsToFinish) return true;
    final shortfall = view.ruleSet.openThresholdFor(view.openedCount) -
        evaluation.bestPoints;
    // Plenty of pairs and a normal open that is not close.
    return pairCount >= view.ruleSet.minPairsToOpen + 2 && shortfall > 25;
  }

  GameAction? _afterOpening(PlayerView view, HandEvaluation evaluation) {
    if (view.hand.length <= 1) return null;

    // Take a table okey when the real tile is spare: a wild in hand is worth
    // far more than the tile it replaces.
    if (view.ruleSet.canReplaceJokerOnTable) {
      final swap = _jokerSwap(view, evaluation);
      if (swap != null) return swap;
    }

    final additions = BotUtils.tableAdditions(view);
    if (additions.isNotEmpty) {
      final semantics = BotUtils.semanticsOf(view);
      // Shed the biggest tile that fits, so the rack gets cheaper fastest.
      var best = additions.first;
      var bestValue = -1;
      for (final option in additions) {
        final tile = view.hand.firstWhere((t) => t.id == option.tileId);
        if (semantics.isWild(tile)) continue;
        final value = semantics.fixedIdentity(tile).number;
        if (value > bestValue) {
          bestValue = value;
          best = option;
        }
      }
      return GameAction.addToMeld(
        meldId: best.meldId,
        tileId: best.tileId,
        atStart: best.atStart,
      );
    }

    if (view.ruleSet.canLayNewMeldsAfterOpening &&
        evaluation.deadwoodSolution.melds.isNotEmpty) {
      final meld = evaluation.deadwoodSolution.melds.first;
      if (BotUtils.meldLeavesALegalDiscard(view, meld)) {
        return GameAction.layMeld(meld: meld.toProposal());
      }
    }
    return null;
  }

  /// Take a table okey only when the hand can actually put it to work.
  ///
  /// The swap trades a tile worth at most 13 on the rack for one worth 25, so
  /// it is a loss unless the okey lands in a meld. Most hands end with the deck
  /// exhausted and are scored on exactly that rack value, so this is checked
  /// against the solver rather than taken on faith.
  GameAction? _jokerSwap(PlayerView view, HandEvaluation evaluation) {
    final semantics = BotUtils.semanticsOf(view);
    final solver = BotUtils.solverFor(view);
    for (final meld in view.table) {
      for (var index = 0; index < meld.tiles.length; index++) {
        final assigned = meld.jokerAssignments[index];
        if (assigned == null) continue;
        final standing = meld.tiles[index];
        if (!semantics.isWild(standing)) continue;
        for (final tile in view.hand) {
          if (semantics.isWild(tile)) continue;
          if (semantics.fixedIdentity(tile) != assigned) continue;

          final after = <Tile>[
            for (final held in view.hand)
              if (held.id != tile.id) held,
            standing,
          ];
          if (solver.minimizeDeadwood(after).deadwood >=
              evaluation.deadwood) {
            continue;
          }
          return GameAction.replaceJoker(
            meldId: meld.id,
            index: index,
            tileId: tile.id,
          );
        }
      }
    }
    return null;
  }

  Tile _discard(
    PlayerView view,
    HandEvaluation evaluation,
    SeenTiles seen,
    List<OpponentBelief> beliefs,
  ) {
    // Caution rises as the pile empties and as the player on the right gets
    // closer to opening. It is deliberately kept modest: the draw pile is only
    // 20 tiles, so most hands end exhausted and are decided on deadwood, and a
    // bot that hoards dangerous-but-expensive tiles simply loses on points.
    final pilePressure = 1.0 - (view.drawPileCount / 20.0).clamp(0.0, 1.0);
    final rightThreat = beliefs
        .firstWhere((b) => b.seat == seatToRightOf(view.seat))
        .openThreat;
    final defensiveness = (0.12 + 0.28 * pilePressure + 0.18 * rightThreat)
        .clamp(0.0, 1.0);

    return DiscardStrategy.choose(
      view,
      evaluation: evaluation,
      seen: seen,
      defensiveness: defensiveness,
      willingToDropOkey: _shouldDropOkey(view, evaluation),
      openingFocus: _stillChasingTheOpen(view, evaluation),
    );
  }

  /// Whether the 101 is still worth playing for.
  ///
  /// It stays worth it while the hand is within reach of the threshold, or
  /// while there are enough draws left to get there. Once neither holds, the
  /// bot switches to keeping the rack cheap, because the hand is most likely
  /// heading for an exhausted deck where only deadwood is written.
  bool _stillChasingTheOpen(PlayerView view, HandEvaluation evaluation) {
    if (view.hasOpened) return false;
    final shortfall =
        view.ruleSet.openThresholdFor(view.openedCount) - evaluation.bestPoints;
    if (shortfall <= 45) return true;
    return view.drawPileCount > 6 && shortfall <= 80;
  }

  /// Hold the okey while any finish is still on. Once the hand is clearly dead,
  /// 25 points of deadwood is a real cost in the exhausted-deck case - and the
  /// okey discard is legal, so the neighbour on the right may take it.
  ///
  /// Deliberately rare: handing the table its best tile is a large concession,
  /// and it only pays when the bot is certain the hand is going nowhere.
  bool _shouldDropOkey(PlayerView view, HandEvaluation evaluation) {
    final semantics = BotUtils.semanticsOf(view);
    if (!view.hand.any(semantics.isWild)) return false;
    if (evaluation.finishingDiscard != null) return false;
    if (view.hasOpened) return false;

    // A finish carrying the okey is worth -202 or better, so it is worth
    // waiting for while there are draws left to find it.
    if (view.drawPileCount > 4) return false;

    // Last couple of turns, unopened, and nowhere near the threshold. The
    // never-opened penalty only bites if somebody actually goes out; if the
    // deck runs out instead, the whole hand is decided on deadwood, and 25
    // points is the single biggest tile on the rack.
    final shortfall =
        view.ruleSet.openThresholdFor(view.openedCount) - evaluation.bestPoints;
    if (shortfall <= 45) return false;

    // Never feed the okey to somebody who has already opened: they can work it
    // straight onto the table.
    return !view.rightNeighbour.hasOpened;
  }

  GameAction? _pairsFinish(PlayerView view) {
    final pairs = BotUtils.solverFor(view).bestPairs(view.hand);
    if (pairs.isEmpty) return null;
    final onTable = view.table.where((m) => m.ownerSeat == view.seat).length;
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
