import 'package:freezed_annotation/freezed_annotation.dart';

part 'tile.freezed.dart';
part 'tile.g.dart';

/// The four tile colours of a Turkish Okey set.
///
/// The declaration order is load bearing: [TileIdentity.index] packs
/// `color.index * 13 + (number - 1)` into a 0..51 slot, and the solver relies on
/// that ordering to know that "the lowest remaining index" is the first tile of
/// its colour that still has a copy left.
enum TileColor { red, yellow, black, blue }

/// A colour/number pair, i.e. what a tile *counts as* rather than which physical
/// tile it is. A false joker resolves to the indicator's identity, and the okey
/// resolves to whichever tile it was laid down as.
@freezed
abstract class TileIdentity with _$TileIdentity {
  const TileIdentity._();

  const factory TileIdentity({
    required TileColor color,
    required int number,
  }) = _TileIdentity;

  factory TileIdentity.fromJson(Map<String, dynamic> json) =>
      _$TileIdentityFromJson(json);

  /// Dense 0..51 slot used by the solver's count vectors.
  int get index => color.index * 13 + (number - 1);

  /// Rebuilds an identity from [index].
  static TileIdentity fromIndex(int index) => TileIdentity(
        color: TileColor.values[index ~/ 13],
        number: (index % 13) + 1,
      );

  String get shortLabel => '${_colorCode(color)}$number';

  static String _colorCode(TileColor color) => switch (color) {
        TileColor.red => 'R',
        TileColor.yellow => 'Y',
        TileColor.black => 'K',
        TileColor.blue => 'B',
      };
}

/// One physical tile. Two identical-looking tiles are still distinct objects
/// with distinct [id]s, which is what makes the 106-tile invariant checkable.
///
/// [color] and [number] are null exactly when [isFalseJoker] is true.
@freezed
abstract class Tile with _$Tile {
  const Tile._();

  const factory Tile({
    required int id,
    required int copyIndex,
    TileColor? color,
    int? number,
    @Default(false) bool isFalseJoker,
  }) = _Tile;

  factory Tile.fromJson(Map<String, dynamic> json) => _$TileFromJson(json);

  /// The printed identity of a numbered tile. Null for a false joker, whose
  /// identity is only knowable once the indicator is known.
  TileIdentity? get printedIdentity => isFalseJoker
      ? null
      // Safe: color and number are non-null for every non-false-joker tile, an
      // invariant enforced by TileDeck being the only construction site.
      : TileIdentity(color: color!, number: number!);

  String get debugLabel => isFalseJoker ? 'FJ$copyIndex' : printedIdentity!.shortLabel;
}
