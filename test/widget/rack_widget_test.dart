import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/features/game/game_session.dart';
import 'package:okey101/features/game/widgets/rack_widget.dart';

import '../domain/test_tiles.dart';

void main() {
  const indicator = TileIdentity(color: TileColor.black, number: 1);
  const okey = TileIdentity(color: TileColor.black, number: 2);

  final hand = <Tile>[red(3), red(4), red(5), blue(9), yellow(12)];

  Future<({List<int?>? committed, List<int> tapped})> pumpRack(
    WidgetTester tester, {
    required Future<void> Function(WidgetTester tester, Rect rackRect) act,
    List<int?>? slots,
    bool enabled = true,
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
                slots: slots ?? RackLayout.fromTiles(hand),
                tilesById: {for (final tile in hand) tile.id: tile},
                selection: const <int>{},
                okey: okey,
                indicator: indicator,
                enabled: enabled,
                animate: false,
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

  testWidgets('dragging a tile clear of the rack never discards it',
      (tester) async {
    // Releasing above the rack used to discard, which fired by accident every
    // time a tile was moved from the bottom row to the top one. It now just
    // rearranges: discarding is the button and nothing else.
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
    final committed = result.committed;
    expect(committed, isNotNull);
    expect(
      committed!.whereType<int>().toSet(),
      hand.map((t) => t.id).toSet(),
      reason: 'no tile may leave the rack by being dragged off it',
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

  testWidgets('a rack disabled mid-drag still releases the tile',
      (tester) async {
    // A GestureDetector drops its recogniser once every pan callback is null,
    // and disposing one mid-drag clears its tracked pointers without calling
    // either terminal callback - so the tile was stranded for good when the
    // turn ended under the player's finger.
    late StateSetter setEnabled;
    var enabled = true;
    List<int?>? committed;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              setEnabled = setState;
              return Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 390,
                  child: RackWidget(
                    slots: RackLayout.fromTiles(hand),
                    tilesById: {for (final tile in hand) tile.id: tile},
                    selection: const <int>{},
                    okey: okey,
                    indicator: indicator,
                    enabled: enabled,
                    animate: false,
                    onLayoutChanged: (value) => committed = value,
                    onTapTile: (_) {},
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final rack = tester.getRect(find.byType(RackWidget));
    final gesture = await tester.startGesture(slotCentre(rack, 0));
    await tester.pump(const Duration(milliseconds: 20));
    await gesture.moveTo(slotCentre(rack, 3));
    await tester.pump(const Duration(milliseconds: 20));
    setEnabled(() => enabled = false);
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('dragged')), findsNothing);
    expect(committed, isNotNull);
  });

  testWidgets('a disabled rack ignores taps and drags', (tester) async {
    final result = await pumpRack(
      tester,
      enabled: false,
      act: (tester, rack) async {
        await tester.tapAt(slotCentre(rack, 1));
        final gesture = await tester.startGesture(slotCentre(rack, 0));
        await gesture.moveTo(slotCentre(rack, 4));
        await gesture.up();
      },
    );
    expect(result.tapped, isEmpty);
    expect(result.committed, isNull);
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
