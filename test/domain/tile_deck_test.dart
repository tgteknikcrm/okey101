import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/tile_deck.dart';

void main() {
  group('TileDeck.standard', () {
    final deck = TileDeck.standard();

    test('holds exactly 106 tiles', () {
      expect(deck.length, kTotalTiles);
    });

    test('holds exactly two copies of every colour/number pair', () {
      for (final color in TileColor.values) {
        for (var number = 1; number <= 13; number++) {
          final matching = deck
              .where((t) => t.color == color && t.number == number)
              .toList();
          expect(
            matching.length,
            2,
            reason: 'expected 2 of $color $number, got ${matching.length}',
          );
          expect(matching.map((t) => t.copyIndex).toSet(), {0, 1});
        }
      }
    });

    test('holds exactly two false jokers with no colour or number', () {
      final jokers = deck.where((t) => t.isFalseJoker).toList();
      expect(jokers.length, 2);
      for (final joker in jokers) {
        expect(joker.color, isNull);
        expect(joker.number, isNull);
        expect(joker.printedIdentity, isNull);
      }
    });

    test('assigns every tile a unique id in 0..105', () {
      final ids = deck.map((t) => t.id).toSet();
      expect(ids.length, kTotalTiles);
      expect(ids.reduce((a, b) => a < b ? a : b), 0);
      expect(ids.reduce((a, b) => a > b ? a : b), kTotalTiles - 1);
    });

    test('has 104 numbered tiles', () {
      expect(
        deck.where((t) => !t.isFalseJoker).length,
        TileDeck.numberedCount,
      );
    });

    test('produces a fresh list each call', () {
      final other = TileDeck.standard();
      expect(identical(deck, other), isFalse);
      expect(other.length, kTotalTiles);
    });
  });

  group('TileIdentity', () {
    test('index packs colour and number into 0..51', () {
      final seen = <int>{};
      for (final color in TileColor.values) {
        for (var number = 1; number <= 13; number++) {
          final identity = TileIdentity(color: color, number: number);
          expect(seen.add(identity.index), isTrue);
          expect(identity.index, inInclusiveRange(0, 51));
          expect(TileIdentity.fromIndex(identity.index), identity);
        }
      }
      expect(seen.length, 52);
    });
  });
}
