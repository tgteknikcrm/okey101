import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/app/providers.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/data/local_store.dart';
import 'package:okey101/data/models/saved_game.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/features/game/game_controller.dart';
import 'package:okey101/features/game/game_screen.dart';
import 'package:okey101/features/game/game_session.dart';
import 'package:okey101/features/game/widgets/meld_view.dart';
import 'package:okey101/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/engine_support.dart';
import '../domain/test_tiles.dart';

void main() {
  final indicator = black(1);
  const okeyIdentity = TileIdentity(color: TileColor.black, number: 2);

  // Exactly 101: four 13s (52) + three 9s (27) + run red 4-5-6-7 (22).
  final open101 = <Tile>[
    red(13), yellow(13), black(13), blue(13), //
    red(9), yellow(9), blue(9), //
    red(4), red(5), red(6), red(7),
  ];

  // Nine low tiles worth 18 in melds - nowhere near the threshold.
  final tooLow = <Tile>[
    red(1), red(2), red(3), //
    yellow(1), yellow(2), yellow(3), //
    blue(1), blue(2), blue(3),
  ];

  late LocalStore store;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    store = await LocalStore.open();
  });

  Future<AppLocalizations> pumpGame(
    WidgetTester tester,
    GameState state,
  ) async {
    late AppLocalizations l10n;
    final container = ProviderContainer(
      overrides: [
        localStoreProvider.overrideWithValue(store),
        nowProvider.overrideWithValue(() => 0),
      ],
    );
    addTearDown(container.dispose);

    container.read(gameControllerProvider.notifier).restore(
          SavedGame(
            state: state,
            rackSlots: RackLayout.fromTiles(state.players[0].hand),
            savedAtMs: 0,
          ),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('tr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildOkeyTheme(),
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return const GameScreen();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return l10n;
  }

  testWidgets('opening with 101 puts the melds on the table', (tester) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final state = buildState(
      indicator: indicator,
      hands: buildHands(
        indicator: indicator,
        okey: okeyIdentity,
        cores: [open101, const <Tile>[], const <Tile>[], const <Tile>[]],
        sizes: const [22, 21, 21, 21],
      ),
    );
    final l10n = await pumpGame(tester, state);

    expect(find.byType(MeldView), findsNothing);

    await tester.tap(find.widgetWithText(FilledButton, l10n.gameOpenAction));
    await tester.pumpAndSettle();

    expect(find.byType(MeldView), findsWidgets);
  });

  testWidgets('an illegal open explains why, in the player language',
      (tester) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final state = buildState(
      indicator: indicator,
      hands: buildHands(
        indicator: indicator,
        okey: okeyIdentity,
        cores: [tooLow, const <Tile>[], const <Tile>[], const <Tile>[]],
        sizes: const [22, 21, 21, 21],
      ),
    );
    final l10n = await pumpGame(tester, state);

    await tester.tap(find.widgetWithText(FilledButton, l10n.gameOpenAction));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(SnackBar), findsOneWidget);
    // The message says how many points are needed and how many the hand has.
    expect(
      find.textContaining('Açmak için 101 puan gerekiyor'),
      findsOneWidget,
    );
    expect(find.byType(MeldView), findsNothing);
  });

  testWidgets('the HUD reports the best combination in hand', (tester) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final state = buildState(
      indicator: indicator,
      hands: buildHands(
        indicator: indicator,
        okey: okeyIdentity,
        cores: [open101, const <Tile>[], const <Tile>[], const <Tile>[]],
        sizes: const [22, 21, 21, 21],
      ),
    );
    await pumpGame(tester, state);

    // The live indicator names the threshold and the best combination found.
    // The exact score depends on what the filler tiles happen to add, so only
    // the shape of the line is asserted here.
    expect(find.textContaining('Açmak için: 101'), findsOneWidget);
    expect(
      find.textContaining('elinizdeki en iyi kombinasyon'),
      findsOneWidget,
    );
    expect(find.textContaining('Kalan taş değeri'), findsOneWidget);
  });

  testWidgets('the sort button offers both modes', (tester) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final state = buildState(
      indicator: indicator,
      hands: buildHands(
        indicator: indicator,
        okey: okeyIdentity,
        cores: [open101, const <Tile>[], const <Tile>[], const <Tile>[]],
        sizes: const [22, 21, 21, 21],
      ),
    );
    final l10n = await pumpGame(tester, state);

    await tester.tap(find.text(l10n.gameSort));
    await tester.pumpAndSettle();

    expect(find.text(l10n.gameSortRuns), findsOneWidget);
    expect(find.text(l10n.gameSortSets), findsOneWidget);

    await tester.tap(find.text(l10n.gameSortRuns));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);
  });
}
