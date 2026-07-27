import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/tile.dart';

/// Builds the canonical 106-tile Okey set.
abstract final class TileDeck {
  /// Number of numbered tiles: 4 colours x 13 numbers x 2 copies.
  static const int numberedCount = 104;

  /// Id of the first false joker. Ids 104 and 105 are the two false jokers.
  static const int firstFalseJokerId = 104;

  /// Stable id for a numbered tile, so ids survive a JSON round-trip.
  static int idFor(TileColor color, int number, int copyIndex) =>
      color.index * 26 + (number - 1) * 2 + copyIndex;

  /// The full set, in canonical order. Never shuffled here - shuffling is the
  /// engine's job and goes through the injected `RandomSource`.
  static List<Tile> standard() {
    final tiles = <Tile>[];
    for (final color in TileColor.values) {
      for (var number = 1; number <= 13; number++) {
        for (var copyIndex = 0; copyIndex < 2; copyIndex++) {
          tiles.add(
            Tile(
              id: idFor(color, number, copyIndex),
              copyIndex: copyIndex,
              color: color,
              number: number,
            ),
          );
        }
      }
    }
    tiles
      ..add(const Tile(id: firstFalseJokerId, copyIndex: 0, isFalseJoker: true))
      ..add(
        const Tile(id: firstFalseJokerId + 1, copyIndex: 1, isFalseJoker: true),
      );
    assert(
      tiles.length == kTotalTiles,
      'A standard Okey set is exactly $kTotalTiles tiles',
    );
    return tiles;
  }
}
