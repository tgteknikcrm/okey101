import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/tile_deck.dart';

/// Shared tile builders for the domain tests.
///
/// Copy indices matter: two identical-looking tiles are still distinct objects
/// with distinct ids, and several rules depend on that.
Tile tile(TileColor color, int number, [int copy = 0]) => Tile(
      id: TileDeck.idFor(color, number, copy),
      copyIndex: copy,
      color: color,
      number: number,
    );

Tile red(int number, [int copy = 0]) => tile(TileColor.red, number, copy);
Tile yellow(int number, [int copy = 0]) => tile(TileColor.yellow, number, copy);
Tile black(int number, [int copy = 0]) => tile(TileColor.black, number, copy);
Tile blue(int number, [int copy = 0]) => tile(TileColor.blue, number, copy);

const Tile falseJoker0 = Tile(
  id: TileDeck.firstFalseJokerId,
  copyIndex: 0,
  isFalseJoker: true,
);

const Tile falseJoker1 = Tile(
  id: TileDeck.firstFalseJokerId + 1,
  copyIndex: 1,
  isFalseJoker: true,
);
