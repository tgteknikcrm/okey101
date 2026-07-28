import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/features/game/game_session.dart';
import 'package:okey101/features/game/widgets/rack_widget.dart';
import 'package:okey101/features/game/widgets/tile_widget.dart';

import '../domain/test_tiles.dart';

void main() {
  const indicator = TileIdentity(color: TileColor.black, number: 1);
  const okey = TileIdentity(color: TileColor.black, number: 2);

  final hand = <Tile>[red(3), red(4), red(5), blue(9), yellow(12)];

  Future<({List<int?>? committed, List<int> tapped})> pumpRack(
    WidgetTester tester, {
    required Future<void> Function(WidgetTester tester, Rect rackRect) act,
    List<int?>? slots,
    double? maxHeight,
  }) async {
    List<int?>? committed;
    final tapped = <int>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 390,
              child: RackWidget(
                maxHeight: maxHeight,
                slots: slots ?? RackLayout.fromTiles(hand),
                tilesById: {for (final tile in hand) tile.id: tile},
                selection: const <int>{},
                okey: okey,
                indicator: indicator,
                onLayoutChanged: (value) => committed = value,
                onTapTile: tapped.add,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final rect = tester.getRect(find.byType(RackWidget));
    await act(tester, rect);
    await tester.pumpAndSettle();
    return (committed: committed, tapped: tapped);
  }

  /// Centre of a rack slot in global coordinates.
  Offset slotCentre(Rect rack, int slot) {
    const padding = 6.0;
    const gap = 3.0;
    const rowGap = 6.0;
    final cellWidth =
        (rack.width - padding * 2 - gap * (kRackColumns - 1)) / kRackColumns;
    final cellHeight = cellWidth * 1.42;
    final column = slot % kRackColumns;
    final row = slot ~/ kRackColumns;
    return Offset(
      rack.left + padding + column * (cellWidth + gap) + cellWidth / 2,
      rack.top + padding + row * (cellHeight + rowGap) + cellHeight / 2,
    );
  }

  testWidgets('tapping a tile reports it', (tester) async {
    final result = await pumpRack(
      tester,
      act: (tester, rack) async {
        await tester.tapAt(slotCentre(rack, 1));
      },
    );
    expect(result.tapped, [red(4).id]);
  });

  testWidgets('dragging a tile to another slot commits a new arrangement',
      (tester) async {
    final result = await pumpRack(
      tester,
      act: (tester, rack) async {
        final gesture = await tester.startGesture(slotCentre(rack, 0));
        await tester.pump(const Duration(milliseconds: 30));
        await gesture.moveTo(slotCentre(rack, 3));
        await tester.pump(const Duration(milliseconds: 30));
        await gesture.up();
      },
    );

    final committed = result.committed;
    expect(committed, isNotNull, reason: 'the drag should have committed');
    // Red 3 moved out of slot 0.
    expect(committed![0], isNot(red(3).id));
    // Nothing is lost.
    expect(
      committed.whereType<int>().toSet(),
      hand.map((t) => t.id).toSet(),
    );
    expect(committed.length, kRackSlots);
  });

  testWidgets('a pan that barely moves counts as a tap', (tester) async {
    // The pan recogniser wins the arena as soon as the finger moves at all, so
    // the tap recogniser has already lost by the time the finger lifts. Without
    // the fallback the touch is swallowed whole and the rack looks unresponsive
    // - the single most reported complaint about the old rack.
    final result = await pumpRack(
      tester,
      act: (tester, rack) async {
        final gesture = await tester.startGesture(slotCentre(rack, 2));
        await tester.pump(const Duration(milliseconds: 30));
        await gesture.moveBy(const Offset(1, 0));
        await tester.pump(const Duration(milliseconds: 30));
        await gesture.up();
      },
    );
    expect(result.committed, isNull);
    expect(result.tapped, [red(5).id]);
  });

  testWidgets('dragging a tile clear of the rack leaves it alone',
      (tester) async {
    // Releasing above the rack used to discard, which fired by accident every
    // time a tile was moved from the bottom row to the top. Now a drop outside
    // is reported to the board, which decides whether it landed on the discard
    // pile - and either way the arrangement is untouched, so a throw that
    // misses does not also scramble the rack.
    final result = await pumpRack(
      tester,
      act: (tester, rack) async {
        final gesture = await tester.startGesture(slotCentre(rack, 0));
        await tester.pump(const Duration(milliseconds: 30));
        await gesture.moveTo(Offset(rack.center.dx, rack.top - 120));
        await tester.pump(const Duration(milliseconds: 30));
        await gesture.up();
      },
    );
    expect(
      result.committed,
      isNull,
      reason: 'a drop off the rack must not rearrange it',
    );
  });

  testWidgets('nothing moves until the tile is put down', (tester) async {
    // Tiles used to jump aside as the finger passed over them, some of them
    // dropping to the other row, and the arrangement was rewritten on every
    // frame. Only the carried tile moves now, and the rack is rearranged once,
    // on release.
    late List<int?> midDrag;
    final result = await pumpRack(
      tester,
      act: (tester, rack) async {
        final gesture = await tester.startGesture(slotCentre(rack, 0));
        await tester.pump(const Duration(milliseconds: 30));
        await gesture.moveTo(slotCentre(rack, 2));
        await tester.pump(const Duration(milliseconds: 30));
        await gesture.moveTo(slotCentre(rack, 3));
        await tester.pump(const Duration(milliseconds: 30));
        midDrag = tester.widget<RackWidget>(find.byType(RackWidget)).slots;
        await gesture.up();
      },
    );

    expect(
      midDrag.take(5).toList(),
      RackLayout.fromTiles(hand).take(5).toList(),
      reason: 'the rack must not be rewritten while the finger is down',
    );
    final committed = result.committed;
    expect(committed, isNotNull, reason: 'the drop should have committed');
    // Red 3 was picked up from slot 0 and put down on slot 3, so the three it
    // passed over shuffle down one to make room - the one from the left and
    // one from the right that a player pushes apart.
    expect(committed![3], red(3).id);
    expect(committed[0], red(4).id);
    expect(
      committed.whereType<int>().toSet(),
      hand.map((t) => t.id).toSet(),
    );
  });

  testWidgets('a tile lands on the slot it was released over', (tester) async {
    // With a height cap the rack is narrower than the band it sits in and is
    // centred inside it. The drop point was being converted against the band
    // rather than the tiles, so a tile released over the fourth slot went down
    // on the eighth - and only when the cap was in play, which is every
    // landscape phone and none of the tests until this one.
    final result = await pumpRack(
      tester,
      // Low enough that the cap actually bites: at 390 wide the rack is 93
      // tall by itself, so anything above that leaves it full width and the
      // inset at zero - which is how this went unnoticed.
      maxHeight: 70,
      act: (tester, rack) async {
        final tiles = find.descendant(
          of: find.byType(RackWidget),
          matching: find.byType(TileWidget),
        );
        final from = tester.getCenter(tiles.at(0));
        final to = tester.getCenter(tiles.at(3));
        final gesture = await tester.startGesture(from);
        await tester.pump(const Duration(milliseconds: 30));
        await gesture.moveTo(to);
        await tester.pump(const Duration(milliseconds: 30));
        await gesture.up();
      },
    );

    final committed = result.committed;
    expect(committed, isNotNull);
    expect(
      committed![3],
      red(3).id,
      reason: 'released over the fourth slot, so that is where it belongs',
    );
    expect(
      committed.whereType<int>().toSet(),
      hand.map((t) => t.id).toSet(),
    );
  });

  testWidgets('a second finger cannot strand a tile in mid-air',
      (tester) async {
    // One pan recogniser covers the whole rack and only reports onPanEnd when
    // the LAST finger lifts. The rack is the band your hands rest on, so a
    // thumb touching it while the other finger drags used to leave the tile
    // stuck to the screen, following the thumb, until every finger came off.
    final result = await pumpRack(
      tester,
      act: (tester, rack) async {
        final drag = await tester.startGesture(slotCentre(rack, 0), pointer: 1);
        await tester.pump(const Duration(milliseconds: 20));
        await drag.moveTo(slotCentre(rack, 3));
        await tester.pump(const Duration(milliseconds: 20));
        final resting =
            await tester.startGesture(slotCentre(rack, 12), pointer: 2);
        await tester.pump(const Duration(milliseconds: 20));
        await drag.up();
        await tester.pump(const Duration(milliseconds: 20));

        expect(
          find.byKey(const ValueKey<String>('dragged')),
          findsNothing,
          reason: 'the tile must not stay stuck to the screen',
        );
        await resting.up();
      },
    );
    expect(result.committed, isNotNull, reason: 'the drag should have landed');
  });

  testWidgets('the rack arranges out of turn as well as in it', (tester) async {
    // The rack used to be locked to the player's own turn, so for the three
    // bot turns between each of yours you could not touch your own tiles.
    // Arranging them is not a move - the engine never learns about slots - and
    // it is the whole of what a player does while waiting.
    final result = await pumpRack(
      tester,
      act: (tester, rack) async {
        await tester.tapAt(slotCentre(rack, 1));
        final gesture = await tester.startGesture(slotCentre(rack, 0));
        await tester.pump(const Duration(milliseconds: 30));
        await gesture.moveTo(slotCentre(rack, 4));
        await tester.pump(const Duration(milliseconds: 30));
        await gesture.up();
      },
    );
    expect(result.tapped, [red(4).id]);
    expect(result.committed, isNotNull);
  });

  testWidgets('an empty slot is not draggable', (tester) async {
    final result = await pumpRack(
      tester,
      act: (tester, rack) async {
        // Slot 20 is beyond the five tiles that were dealt.
        final gesture = await tester.startGesture(slotCentre(rack, 20));
        await tester.pump(const Duration(milliseconds: 30));
        await gesture.moveTo(slotCentre(rack, 0));
        await tester.pump(const Duration(milliseconds: 30));
        await gesture.up();
      },
    );
    expect(result.committed, isNull);
    expect(result.tapped, isEmpty);
  });
}
