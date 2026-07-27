import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/app/force_landscape.dart';

void main() {
  /// Pumps [child] under a ForceLandscape at the given viewport and reports the
  /// constraints the child actually received.
  Future<Size> constraintsAt(
    WidgetTester tester,
    Size viewport, {
    required bool enabled,
    Widget? child,
  }) async {
    tester.view.physicalSize = viewport;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    late Size seen;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, inner) =>
            ForceLandscape(enabled: enabled, child: inner!),
        home: LayoutBuilder(
          builder: (context, constraints) {
            seen = Size(constraints.maxWidth, constraints.maxHeight);
            return child ?? const SizedBox.expand();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    return seen;
  }

  group('ForceLandscape', () {
    testWidgets('a portrait handset gets landscape constraints',
        (tester) async {
      final size = await constraintsAt(
        tester,
        const Size(390, 844),
        enabled: true,
      );
      expect(size.width, 844);
      expect(size.height, 390);
    });

    testWidgets('a landscape handset is left alone', (tester) async {
      final size = await constraintsAt(
        tester,
        const Size(844, 390),
        enabled: true,
      );
      expect(size.width, 844);
      expect(size.height, 390);
    });

    testWidgets('a tall desktop window is left alone', (tester) async {
      // Shortest side is above the handset threshold, so a sideways desktop
      // window would be worse than the portrait layout.
      final size = await constraintsAt(
        tester,
        const Size(900, 1200),
        enabled: true,
      );
      expect(size.width, 900);
      expect(size.height, 1200);
    });

    testWidgets('turning the setting off stops the rotation', (tester) async {
      final size = await constraintsAt(
        tester,
        const Size(390, 844),
        enabled: false,
      );
      expect(size.width, 390);
      expect(size.height, 844);
    });

    test('wouldRotate bounds BOTH axes, not just the short one', () {
      // Handsets, in portrait: rotate.
      expect(ForceLandscape.wouldRotate(const Size(390, 844)), isTrue);
      expect(ForceLandscape.wouldRotate(const Size(360, 640)), isTrue);
      expect(ForceLandscape.wouldRotate(const Size(430, 932)), isTrue);

      // Already landscape: leave alone.
      expect(ForceLandscape.wouldRotate(const Size(844, 390)), isFalse);

      // Desktop windows and tablets, which keep the portrait layout.
      expect(ForceLandscape.wouldRotate(const Size(700, 1400)), isFalse);
      expect(ForceLandscape.wouldRotate(const Size(600, 900)), isFalse);
      expect(ForceLandscape.wouldRotate(const Size(768, 1024)), isFalse);
      expect(ForceLandscape.wouldRotate(const Size(900, 1200)), isFalse);
      // A very tall, narrow window is not a phone either.
      expect(ForceLandscape.wouldRotate(const Size(400, 1600)), isFalse);
    });

    testWidgets('taps still land on the right widget through the rotation',
        (tester) async {
      final tapped = <String>[];
      await constraintsAt(
        tester,
        const Size(390, 844),
        enabled: true,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                key: const Key('left'),
                behavior: HitTestBehavior.opaque,
                onTap: () => tapped.add('left'),
                child: const SizedBox.expand(),
              ),
            ),
            Expanded(
              child: GestureDetector(
                key: const Key('right'),
                behavior: HitTestBehavior.opaque,
                onTap: () => tapped.add('right'),
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      );

      await tester.tap(find.byKey(const Key('left')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('right')));
      await tester.pump();

      // RotatedBox rotates before layout, so hit testing goes through the same
      // transform and no coordinate maths of our own is involved.
      expect(tapped, ['left', 'right']);
    });

    testWidgets('the notch inset moves to the rotated left edge',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      tester.view.padding = const FakeViewPadding(top: 47);
      addTearDown(tester.view.reset);

      late EdgeInsets seen;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, inner) =>
              ForceLandscape(enabled: true, child: inner!),
          home: Builder(
            builder: (context) {
              seen = MediaQuery.paddingOf(context);
              return const SizedBox.expand();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(seen.left, 47);
      expect(seen.top, 0);
    });
  });
}
