import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/tile.dart';

/// What each physical tile *means* once the indicator ("gosterge") is known.
///
/// Two distinct concepts live here and must not be confused:
///  * the okey is the wild tile, derived from the indicator;
///  * the 2 false jokers ("sahte okey") are NOT wild - they simply count as the
///    indicator tile itself.
class TileSemantics {
  const TileSemantics({
    required this.indicatorIdentity,
    required this.okey,
    required this.ruleSet,
  });

  /// Builds the semantics for an indicator tile.
  factory TileSemantics.fromIndicator(
    TileIdentity indicatorIdentity,
    RuleSet ruleSet,
  ) =>
      TileSemantics(
        indicatorIdentity: indicatorIdentity,
        okey: okeyForIndicator(indicatorIdentity),
        ruleSet: ruleSet,
      );

  final TileIdentity indicatorIdentity;
  final TileIdentity okey;
  final RuleSet ruleSet;

  /// Indicator (C, N) -> okey (C, N+1); if N is 13 the okey is 1 of colour C.
  ///
  /// This 13 -> 1 wrap exists ONLY to derive the okey. It deliberately shares
  /// no code with run validation, which is never circular. Do not wire these
  /// two paths together.
  static TileIdentity okeyForIndicator(TileIdentity indicator) => TileIdentity(
        color: indicator.color,
        number: indicator.number == 13 ? 1 : indicator.number + 1,
      );

  /// True for the two physical tiles that match the okey identity. A false
  /// joker is never wild.
  bool isWild(Tile tile) =>
      !tile.isFalseJoker &&
      tile.color == okey.color &&
      tile.number == okey.number;

  bool isFalseJoker(Tile tile) => tile.isFalseJoker;

  /// The identity a tile carries when it is NOT acting as a wild: its printed
  /// face, or the indicator's face for a false joker.
  TileIdentity fixedIdentity(Tile tile) =>
      tile.printedIdentity ?? indicatorIdentity;

  /// Face value of a tile left on the rack at the end of a hand.
  ///
  /// An okey counts [RuleSet.okeyDeadwoodValue]; a false joker is not wild, so
  /// it scores the indicator's number like any ordinary tile.
  int deadwoodValue(Tile tile) =>
      isWild(tile) ? ruleSet.okeyDeadwoodValue : fixedIdentity(tile).number;

  /// Total deadwood of a rack.
  int deadwoodOf(Iterable<Tile> tiles) {
    var total = 0;
    for (final tile in tiles) {
      total += deadwoodValue(tile);
    }
    return total;
  }
}
