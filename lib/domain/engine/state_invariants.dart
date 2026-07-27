import 'package:okey101/domain/models/game_state.dart';

/// The 106-tile invariant, checkable at every moment of every game.
///
/// draw pile + all racks + all discard piles + all melds on the table +
/// indicator == exactly 106 tiles, each id present exactly once.
abstract final class StateInvariants {
  /// Returns a human-readable description of the first violation found, or null
  /// when the state is consistent.
  static String? violation(GameState state) {
    final tiles = state.allTiles();
    if (tiles.length != kTotalTiles) {
      return 'tile count is ${tiles.length}, expected $kTotalTiles';
    }
    final seen = List<bool>.filled(kTotalTiles, false);
    for (final tile in tiles) {
      if (tile.id < 0 || tile.id >= kTotalTiles) {
        return 'tile id ${tile.id} is out of range';
      }
      if (seen[tile.id]) {
        return 'tile id ${tile.id} appears more than once';
      }
      seen[tile.id] = true;
    }

    if (state.players.length != kSeatCount) {
      return 'expected $kSeatCount players, got ${state.players.length}';
    }
    for (var seat = 0; seat < kSeatCount; seat++) {
      if (state.players[seat].seat != seat) {
        return 'player at index $seat carries seat ${state.players[seat].seat}';
      }
    }

    for (final meld in state.table) {
      if (meld.jokerAssignments.length != meld.tiles.length) {
        return 'meld ${meld.id} has ${meld.jokerAssignments.length} '
            'assignments for ${meld.tiles.length} tiles';
      }
      if (meld.tiles.isEmpty) {
        return 'meld ${meld.id} is empty';
      }
    }

    if (!state.isHandOver) {
      final hand = state.currentPlayer.hand.length;
      final expected = state.phase == TurnPhase.awaitingDraw ? '<= 21' : '<= 22';
      if (state.phase == TurnPhase.awaitingDraw && hand > kHandSize) {
        return 'seat ${state.currentSeat} holds $hand tiles before drawing '
            '(expected $expected)';
      }
      if (state.phase == TurnPhase.awaitingDiscard && hand > kHandSize + 1) {
        return 'seat ${state.currentSeat} holds $hand tiles after drawing '
            '(expected $expected)';
      }
    }

    return null;
  }

  /// Debug-build assertion. Compiled out of release builds.
  static void assertValid(GameState state) {
    assert(() {
      final problem = violation(state);
      if (problem != null) {
        throw StateError('Game state invariant broken: $problem');
      }
      return true;
    }(), 'invariant check');
  }
}
