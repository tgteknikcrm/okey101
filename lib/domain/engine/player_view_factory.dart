import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/player_view.dart';

/// Redacts a [GameState] down to what one seat may legitimately see.
///
/// This is the only bridge from full state to a bot. Bots take a [PlayerView]
/// and never a [GameState], so hidden information is unreachable at the type
/// level rather than by discipline.
abstract final class PlayerViewFactory {
  static PlayerView forSeat(GameState state, int seat) {
    final me = state.players[seat];
    return PlayerView(
      ruleSet: state.ruleSet,
      seat: seat,
      name: me.name,
      hand: me.hand,
      indicator: state.indicator,
      okey: state.okey,
      // Count only. The tiles themselves never cross this boundary.
      drawPileCount: state.drawPile.length,
      table: state.table,
      opponents: <OpponentView>[
        for (var step = 1; step < kSeatCount; step++)
          _opponent(state.players[(seat + step) % kSeatCount]),
      ],
      ownDiscards: me.discards,
      phase: state.phase,
      hasOpened: me.hasOpened,
      openedWithPairs: me.openedWithPairs,
      openedCount: state.openedCount,
      handNumber: state.handNumber,
      score: me.score,
      takenFromDiscardTileId:
          seat == state.currentSeat ? state.takenFromDiscardTileId : null,
    );
  }

  static OpponentView _opponent(PlayerState player) => OpponentView(
        seat: player.seat,
        name: player.name,
        tileCount: player.hand.length,
        hasOpened: player.hasOpened,
        openedWithPairs: player.openedWithPairs,
        score: player.score,
        discards: player.discards,
      );
}
