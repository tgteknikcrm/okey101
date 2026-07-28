import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/features/game/game_session.dart';

import '../domain/test_tiles.dart';

void main() {
  const indicator = TileIdentity(color: TileColor.black, number: 1);

  group('RackLayout.move', () {
    test('moves a tile into an empty slot', () {
      final slots = RackLayout.empty();
      slots[0] = 10;
      final moved = RackLayout.move(slots, 0, 5);
      expect(moved[0], isNull);
      expect(moved[5], 10);
    });

    test('dropping on an occupied slot shoves it to the nearest gap', () {
      final slots = RackLayout.empty();
      slots[0] = 1;
      slots[1] = 2;
      slots[2] = 3;
      // Tile 1 is put down on tile 3. The nearest gap is slot 3, so 3 steps
      // right and nothing else moves - tile 2 stays exactly where it was.
      final moved = RackLayout.move(slots, 0, 2);
      expect(moved.take(4).toList(), [null, 2, 1, 3]);
    });

    test('a full row trades places instead of shoving the whole rack', () {
      // The shape a hand is dealt in: the top row full, the bottom row part
      // filled. Carrying the last tile up into the top row used to rotate
      // every slot in between - seventeen tiles moving because one was
      // dropped, which is what made the rack look like it exploded.
      final slots = RackLayout.empty();
      for (var i = 0; i < kRackColumns; i++) {
        slots[i] = 100 + i;
      }
      for (var i = 0; i < 8; i++) {
        slots[kRackColumns + i] = 200 + i;
      }
      final before = List<int?>.of(slots);

      final moved = RackLayout.move(slots, kRackColumns + 7, 3);
      expect(moved[3], 207, reason: 'the carried tile lands where it was put');
      expect(moved[kRackColumns + 7], 103, reason: 'they trade places');

      final disturbed = <int>[
        for (var i = 0; i < kRackSlots; i++)
          if (moved[i] != before[i]) i,
      ];
      expect(disturbed, [3, kRackColumns + 7], reason: 'only those two move');
    });

    test('moving left shifts the block right', () {
      final slots = RackLayout.empty();
      slots[0] = 1;
      slots[1] = 2;
      slots[2] = 3;
      final moved = RackLayout.move(slots, 2, 0);
      expect(moved.take(3).toList(), [3, 1, 2]);
    });

    test('a no-op move changes nothing', () {
      final slots = RackLayout.empty();
      slots[4] = 7;
      expect(RackLayout.move(slots, 4, 4), slots);
      expect(RackLayout.move(slots, 3, 9), slots);
    });

    test('never loses or duplicates a tile', () {
      var slots = RackLayout.fromTiles([
        for (var i = 1; i <= 14; i++) red(i > 13 ? 13 : i, i > 13 ? 1 : 0),
      ]);
      final original = slots.whereType<int>().toSet();
      for (final pair in [(0, 20), (20, 3), (7, 7), (13, 0), (25, 1)]) {
        slots = RackLayout.move(slots, pair.$1, pair.$2);
        expect(slots.whereType<int>().toSet(), original);
        expect(slots.length, kRackSlots);
      }
    });
  });

  group('RackLayout.reconcile', () {
    test('keeps the arrangement and frees the slots of tiles that left', () {
      final slots = RackLayout.empty();
      slots[3] = red(5).id;
      slots[9] = blue(7).id;
      final next = RackLayout.reconcile(slots, [blue(7)]);
      expect(next[3], isNull);
      expect(next[9], blue(7).id);
    });

    test('a drawn tile takes the first free slot', () {
      final slots = RackLayout.empty();
      slots[1] = red(5).id;
      final next = RackLayout.reconcile(slots, [red(5), yellow(9)]);
      expect(next[0], yellow(9).id);
      expect(next[1], red(5).id);
    });

    test('always returns exactly 26 slots', () {
      expect(RackLayout.reconcile([red(1).id], [red(1)]).length, kRackSlots);
    });
  });

  group('sorting', () {
    final hand = <Tile>[
      blue(9), red(2), black(7), red(1), blue(8), red(3), black(7, 1),
    ];

    test('sortForRuns groups by colour then number', () {
      final slots = RackLayout.sortForRuns(hand, indicator);
      final order = <int>[for (final id in slots) ?id];
      final tiles = [
        for (final id in order) hand.firstWhere((t) => t.id == id),
      ];
      expect(tiles.length, hand.length);
      // Red 1-2-3 come first and are ascending.
      expect(tiles.take(3).map((t) => t.number).toList(), [1, 2, 3]);
      expect(tiles.take(3).every((t) => t.color == TileColor.red), isTrue);
    });

    test('sortForSets groups by number then colour', () {
      final slots = RackLayout.sortForSets(hand, indicator);
      final tiles = [
        for (final id in slots)
          if (id != null) hand.firstWhere((t) => t.id == id),
      ];
      final numbers = tiles.map((t) => t.number).toList();
      final sorted = List<int?>.of(numbers)..sort((a, b) => a!.compareTo(b!));
      expect(numbers, sorted);
    });

    test('sorting never drops a tile, even with a full rack', () {
      final full = <Tile>[
        for (var i = 1; i <= 13; i++) red(i),
        for (var i = 1; i <= 13; i++) blue(i),
      ];
      expect(full.length, kRackSlots);
      for (final slots in [
        RackLayout.sortForRuns(full, indicator),
        RackLayout.sortForSets(full, indicator),
      ]) {
        expect(slots.whereType<int>().length, full.length);
        expect(slots.length, kRackSlots);
      }
    });

    test('a false joker sorts as the indicator tile', () {
      final slots = RackLayout.sortForRuns([falseJoker0, black(2)], indicator);
      final ids = slots.whereType<int>().toList();
      // Indicator is black 1, so the false joker sorts before black 2.
      expect(ids.first, falseJoker0.id);
    });
  });
}
