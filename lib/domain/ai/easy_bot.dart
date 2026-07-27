import 'package:okey101/domain/ai/bot_brain.dart';
import 'package:okey101/domain/ai/bot_utils.dart';
import 'package:okey101/domain/engine/random_source.dart';
import 'package:okey101/domain/models/game_action.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/player_view.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

/// Greedy, short-sighted, and occasionally wrong on purpose.
///
/// Draws from the pile unless the discard obviously completes something,
/// discards the highest tile it cannot immediately use, and opens the moment it
/// can. It never runs the deadwood solver for its discard, which is both what
/// makes it weak and what makes it cheap.
class EasyBot implements BotBrain {
  const EasyBot({this.mistakeRate = 0.15});

  /// How often it throws the wrong tile or ignores a useful discard. Real
  /// beginners do both.
  final double mistakeRate;

  @override
  BotDifficulty get difficulty => BotDifficulty.easy;

  @override
  GameAction decide(PlayerView view, RandomSource rng) {
    final semantics = BotUtils.semanticsOf(view);

    if (view.phase == TurnPhase.awaitingDraw) {
      final top = view.leftNeighbour.topDiscard;
      final wantsIt = top != null &&
          BotUtils.canTakeDiscard(view) &&
          (semantics.isWild(top) || _obviouslyHelps(view, top, semantics));
      if (wantsIt && !rng.nextBool(mistakeRate)) {
        return const GameAction.drawFromDiscard();
      }
      if (view.drawPileCount > 0) return const GameAction.drawFromPile();
      return const GameAction.drawFromDiscard();
    }

    if (!view.hasOpened) {
      final opening = BotUtils.openingFor(view);
      if (opening != null) {
        return GameAction.open(melds: opening.toProposals());
      }
    } else if (!view.openedWithPairs && view.hand.length > 1) {
      final additions = BotUtils.tableAdditions(view);
      if (additions.isNotEmpty) {
        final pick = additions.first;
        return GameAction.addToMeld(
          meldId: pick.meldId,
          tileId: pick.tileId,
          atStart: pick.atStart,
        );
      }
    }

    return GameAction.discard(
      tileId: _chooseDiscard(view, semantics, rng).id,
    );
  }

  /// Highest tile that is not part of any obvious group. Sometimes just any
  /// tile, which is the deliberate mistake.
  Tile _chooseDiscard(
    PlayerView view,
    TileSemantics semantics,
    RandomSource rng,
  ) {
    final legal = BotUtils.discardableTiles(view);
    if (rng.nextBool(mistakeRate)) {
      return rng.pick(legal);
    }

    Tile? best;
    var bestValue = -1;
    for (final tile in legal) {
      // It never throws the okey; even a beginner knows that much.
      if (semantics.isWild(tile)) continue;
      if (_partOfAGroup(view, tile, semantics)) continue;
      final value = semantics.fixedIdentity(tile).number;
      if (value > bestValue) {
        bestValue = value;
        best = tile;
      }
    }
    if (best != null) return best;

    // Everything looks useful, so throw the biggest non-okey tile.
    for (final tile in legal) {
      if (semantics.isWild(tile)) continue;
      final value = semantics.fixedIdentity(tile).number;
      if (value > bestValue) {
        bestValue = value;
        best = tile;
      }
    }
    return best ?? legal.first;
  }

  /// Two other tiles in hand already sit next to this one, or share its number.
  bool _partOfAGroup(PlayerView view, Tile tile, TileSemantics semantics) {
    final identity = semantics.fixedIdentity(tile);
    var sameNumber = 0;
    var runNeighbours = 0;
    for (final other in view.hand) {
      if (other.id == tile.id) continue;
      if (semantics.isWild(other)) continue;
      final id = semantics.fixedIdentity(other);
      if (id.number == identity.number && id.color != identity.color) {
        sameNumber++;
      }
      if (id.color == identity.color &&
          (id.number - identity.number).abs() <= 2) {
        runNeighbours++;
      }
    }
    return sameNumber >= 2 || runNeighbours >= 2;
  }

  /// The discard would immediately be the third tile of a run or a set.
  bool _obviouslyHelps(
    PlayerView view,
    Tile candidate,
    TileSemantics semantics,
  ) {
    final identity = semantics.fixedIdentity(candidate);
    var sameNumber = 0;
    var below = false;
    var above = false;
    var twoBelow = false;
    var twoAbove = false;
    for (final tile in view.hand) {
      if (semantics.isWild(tile)) continue;
      final id = semantics.fixedIdentity(tile);
      if (id.number == identity.number && id.color != identity.color) {
        sameNumber++;
      }
      if (id.color != identity.color) continue;
      final delta = id.number - identity.number;
      if (delta == -1) below = true;
      if (delta == 1) above = true;
      if (delta == -2) twoBelow = true;
      if (delta == 2) twoAbove = true;
    }
    if (sameNumber >= 2) return true;
    if (below && above) return true;
    if (below && twoBelow) return true;
    if (above && twoAbove) return true;
    return false;
  }
}
