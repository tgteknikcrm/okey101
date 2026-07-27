import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/tile_deck.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

void main() {
  Tile numbered(TileColor color, int number, [int copy = 0]) => Tile(
        id: TileDeck.idFor(color, number, copy),
        copyIndex: copy,
        color: color,
        number: number,
      );

  const falseJoker = Tile(
    id: TileDeck.firstFalseJokerId,
    copyIndex: 0,
    isFalseJoker: true,
  );

  group('okey derivation', () {
    test('indicator N gives okey N+1 in the same colour', () {
      for (final color in TileColor.values) {
        for (var number = 1; number <= 12; number++) {
          final okey = TileSemantics.okeyForIndicator(
            TileIdentity(color: color, number: number),
          );
          expect(okey.color, color);
          expect(okey.number, number + 1);
        }
      }
    });

    test('indicator 13 wraps to okey 1 of the same colour', () {
      for (final color in TileColor.values) {
        final okey = TileSemantics.okeyForIndicator(
          TileIdentity(color: color, number: 13),
        );
        expect(okey.color, color);
        expect(okey.number, 1);
      }
    });
  });

  group('wildness', () {
    final semantics = TileSemantics.fromIndicator(
      const TileIdentity(color: TileColor.red, number: 7),
      RulePresets.standard,
    );

    test('both copies of the okey tile are wild', () {
      expect(semantics.okey, const TileIdentity(color: TileColor.red, number: 8));
      expect(semantics.isWild(numbered(TileColor.red, 8)), isTrue);
      expect(semantics.isWild(numbered(TileColor.red, 8, 1)), isTrue);
    });

    test('other tiles are not wild', () {
      expect(semantics.isWild(numbered(TileColor.blue, 8)), isFalse);
      expect(semantics.isWild(numbered(TileColor.red, 7)), isFalse);
    });

    test('a false joker is never wild - it is the indicator tile', () {
      expect(semantics.isWild(falseJoker), isFalse);
      expect(
        semantics.fixedIdentity(falseJoker),
        const TileIdentity(color: TileColor.red, number: 7),
      );
    });
  });

  group('deadwood values', () {
    final semantics = TileSemantics.fromIndicator(
      const TileIdentity(color: TileColor.black, number: 4),
      RulePresets.standard,
    );

    test('an ordinary tile counts its face value', () {
      expect(semantics.deadwoodValue(numbered(TileColor.blue, 11)), 11);
      expect(semantics.deadwoodValue(numbered(TileColor.yellow, 1)), 1);
    });

    test('an okey left in hand counts okeyDeadwoodValue (25 by default)', () {
      expect(semantics.okey, const TileIdentity(color: TileColor.black, number: 5));
      expect(semantics.deadwoodValue(numbered(TileColor.black, 5)), 25);
    });

    test("a false joker counts the indicator's number, not 25", () {
      expect(semantics.deadwoodValue(falseJoker), 4);
    });

    test('okeyDeadwoodValue is configurable', () {
      final custom = TileSemantics.fromIndicator(
        const TileIdentity(color: TileColor.black, number: 4),
        RulePresets.standard.copyWith(okeyDeadwoodValue: 50),
      );
      expect(custom.deadwoodValue(numbered(TileColor.black, 5)), 50);
    });

    test('deadwoodOf sums a rack', () {
      final rack = [
        numbered(TileColor.blue, 11),
        numbered(TileColor.black, 5), // the okey
        falseJoker,
      ];
      expect(semantics.deadwoodOf(rack), 11 + 25 + 4);
    });
  });
}
