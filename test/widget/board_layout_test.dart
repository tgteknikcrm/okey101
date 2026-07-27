import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/features/game/board_layout.dart';

import '../domain/test_tiles.dart';

void main() {
  var nextId = 0;

  Meld run(int length) => Meld(
        id: nextId++,
        kind: MeldKind.run,
        ownerSeat: 0,
        tiles: [for (var i = 1; i <= length; i++) red(i)],
        jokerAssignments: List<TileIdentity?>.filled(length, null),
      );

  Meld pair() => Meld(
        id: nextId++,
        kind: MeldKind.pair,
        ownerSeat: 0,
        tiles: [red(5), red(5, 1)],
        jokerAssignments: const [null, null],
      );

  setUp(() => nextId = 0);

  group('BoardLayout.place', () {
    test('a meld never wraps: it is consecutive cells in one row', () {
      final placements = BoardLayout.place([run(5)], halves: 1);
      expect(placements, hasLength(1));
      expect(placements.single.row, 0);
      expect(placements.single.column, 0);
      expect(placements.single.length, 5);
    });

    test('melds share a row until it runs out, with a gap between them', () {
      // 5 + gap + 5 = 11 of 13, so the third meld cannot join them.
      final placements = BoardLayout.place(
        [run(5), run(5), run(5)],
        halves: 1,
      );
      expect(placements[0].row, 0);
      expect(placements[0].column, 0);
      expect(placements[1].row, 0);
      expect(placements[1].column, 6, reason: 'one empty cell between melds');
      expect(placements[2].row, 1, reason: 'no room left on row 0');
      expect(placements[2].column, 0);
    });

    test('a meld never crosses the divider between halves', () {
      final placements = BoardLayout.place(
        [run(13), run(13)],
        halves: 2,
      );
      expect(placements[0].half, 0);
      expect(placements[0].column, 0);
      expect(placements[1].half, 1, reason: 'the second half takes it whole');
      expect(placements[1].column, 0);
      expect(placements[1].row, 0);
    });

    test('rows fill across both halves before a new row opens', () {
      final placements = BoardLayout.place(
        [run(7), run(7), run(7)],
        halves: 2,
      );
      expect(placements[0], isA<BoardPlacement>());
      expect((placements[0].half, placements[0].row), (0, 0));
      expect((placements[1].half, placements[1].row), (1, 0));
      // 7 + gap + 7 = 15 > 13, so row 0 is spent on both sides.
      expect(placements[2].row, 1);
    });

    test('the longest legal run fits on one row', () {
      // Thirteen columns exists precisely so a 1..13 run never has to wrap.
      final placements = BoardLayout.place([run(13)], halves: 1);
      expect(placements.single.column, 0);
      expect(placements.single.length, BoardLayout.columnsPerHalf);
    });

    test('every meld gets a placement, however many there are', () {
      final melds = [for (var i = 0; i < 24; i++) run(4)];
      final placements = BoardLayout.place(melds, halves: 1);
      expect(placements, hasLength(24));
      expect(
        placements.map((p) => p.meldId).toSet(),
        melds.map((m) => m.id).toSet(),
      );
    });

    test('placements never overlap', () {
      final melds = [
        for (var i = 0; i < 30; i++) run(3 + (i % 4)),
      ];
      final placements = BoardLayout.place(melds, halves: 2);
      final occupied = <String>{};
      for (final placement in placements) {
        for (var c = placement.column; c < placement.column + placement.length; c++) {
          final key = '${placement.half}:${placement.row}:$c';
          expect(
            occupied.add(key),
            isTrue,
            reason: 'cell $key used twice by meld ${placement.meldId}',
          );
        }
        expect(
          placement.column + placement.length,
          lessThanOrEqualTo(BoardLayout.columnsPerHalf),
          reason: 'meld ${placement.meldId} ran past the divider',
        );
      }
    });

    test('pairs are left to the pairs panel', () {
      final placements = BoardLayout.place([run(4), pair(), run(3)], halves: 1);
      expect(placements, hasLength(2));
      expect(placements.map((p) => p.length), [4, 3]);
    });

    test('is a pure function of the meld list', () {
      final melds = [run(5), run(4), run(6), run(3)];
      final first = BoardLayout.place(melds, halves: 2);
      final second = BoardLayout.place(melds, halves: 2);
      expect(
        second.map((p) => '${p.half}:${p.row}:${p.column}').toList(),
        first.map((p) => '${p.half}:${p.row}:${p.column}').toList(),
      );
    });

    test('an empty table places nothing', () {
      expect(BoardLayout.place(const [], halves: 2), isEmpty);
      expect(BoardLayout.rowsUsed(const []), 0);
    });
  });

  group('BoardLayout.placePairs', () {
    test('packs two pairs to a row', () {
      final pairs = [pair(), pair(), pair(), pair(), pair()];
      final placements = BoardLayout.placePairs(pairs);
      expect(placements, hasLength(5));
      expect((placements[0].row, placements[0].column), (0, 0));
      expect((placements[1].row, placements[1].column), (0, 2));
      expect((placements[2].row, placements[2].column), (1, 0));
      expect((placements[3].row, placements[3].column), (1, 2));
      expect((placements[4].row, placements[4].column), (2, 0));
    });

    test('an eleven-pair finish fits without overlapping', () {
      final pairs = [for (var i = 0; i < 11; i++) pair()];
      final placements = BoardLayout.placePairs(pairs);
      expect(placements, hasLength(11));
      final occupied = <String>{};
      for (final placement in placements) {
        for (var c = placement.column; c < placement.column + 2; c++) {
          expect(occupied.add('${placement.row}:$c'), isTrue);
          expect(c, lessThan(BoardLayout.pairColumns));
        }
      }
      expect(BoardLayout.rowsUsed(placements), 6);
    });

    test('runs and sets are left to the main board', () {
      expect(BoardLayout.placePairs([run(4), run(3)]), isEmpty);
    });
  });
}
