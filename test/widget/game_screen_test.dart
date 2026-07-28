import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/app/providers.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/data/local_store.dart';
import 'package:okey101/data/models/app_settings.dart';
import 'package:okey101/data/models/saved_game.dart';
import 'package:okey101/data/models/wallet.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/features/game/game_controller.dart';
import 'package:okey101/features/game/game_screen.dart';
import 'package:okey101/features/game/game_session.dart';
import 'package:okey101/features/game/widgets/meld_board.dart';
import 'package:okey101/features/game/widgets/rack_widget.dart';
import 'package:okey101/features/game/widgets/seat_chip.dart';
import 'package:okey101/features/game/widgets/tile_widget.dart';
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

  /// Tiles sitting on the gridded table, as opposed to the rack or the deck
  /// column. An empty table shows the hint and no tiles at all.
  final boardTiles = find.descendant(
    of: find.byType(MeldBoard),
    matching: find.byType(TileWidget),
  );

  late LocalStore store;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    store = await LocalStore.open();
  });

  Future<AppLocalizations> pumpGame(
    WidgetTester tester,
    GameState state, {
    double textScale = 1.0,

    /// Drops the bots' think delay to zero. A test whose move ends the human's
    /// turn otherwise leaves that timer pending, and testWidgets fails any
    /// test that does.
    bool fastMode = false,

    /// Leaves the bots mid-think instead of settling. Settling plays their
    /// whole turn out, and with fastMode it plays the entire hand.
    bool settle = true,
  }) async {
    if (fastMode) {
      await store.saveSettings(const AppSettings(fastMode: true));
    }
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
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return const GameScreen();
            },
          ),
        ),
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
      await tester.pump();
    }
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

    expect(boardTiles, findsNothing);

    await tester.tap(find.widgetWithText(FilledButton, l10n.gameOpenAction));
    await tester.pumpAndSettle();

    expect(boardTiles, findsWidgets);
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
    expect(boardTiles, findsNothing);
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
    // the shape of the line is asserted here. Portrait keeps the HUD panel;
    // only the landscape board traded it for two corners.
    expect(find.textContaining('Açmak için: 101'), findsOneWidget);
    expect(
      find.textContaining('elinizdeki en iyi kombinasyon'),
      findsOneWidget,
    );
    expect(find.textContaining('Kalan taş değeri'), findsOneWidget);
  });

  testWidgets('the landscape board lays out on a 844x390 phone',
      (tester) async {
    // The shape handsets actually get: ForceLandscape rotates a portrait phone
    // into exactly this viewport before the board is built.
    tester.view.physicalSize = const Size(844, 390);
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

    // No RenderFlex overflow: those are hard errors and would have failed the
    // pump already, but assert the board really is there.
    expect(tester.takeException(), isNull);
    expect(find.byType(RackWidget), findsOneWidget);
    // Both turn-ending actions are on screen without scrolling.
    expect(
      find.widgetWithText(FilledButton, l10n.gameOpenAction),
      findsOneWidget,
    );

    // The header: the way out, the settings, and the purse.
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byIcon(Icons.monetization_on), findsOneWidget);
    expect(find.byIcon(Icons.diamond), findsOneWidget);
    // One pile at each corner of the table, plus the three opponents' circles.
    expect(find.byType(DiscardSpot), findsNWidgets(4));
    expect(find.byType(SeatChip), findsNWidgets(3));

    // The rack must not eat the board: it is capped to a share of the height.
    final rack = tester.getSize(find.byType(RackWidget));
    expect(rack.height, lessThanOrEqualTo(390 * 0.38));
    expect(rack.height, greaterThan(60));
  });

  testWidgets('the landscape board survives a 1.3 text scale', (tester) async {
    // The opponent rail used to divide its height into equal thirds, which
    // clipped each compact panel by 6.4 pixels as soon as text grew.
    tester.view.physicalSize = const Size(844, 390);
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
    await pumpGame(tester, state, textScale: 1.3);
    expect(tester.takeException(), isNull);
  });

  testWidgets('every action button is reachable without scrolling',
      (tester) async {
    // The actions are a strip directly above the rack: they act on the tiles in
    // it, so they belong beside them. That puts the whole row on one line, and
    // what can go wrong is a button running off the side of an 844 pixel phone
    // rather than off the bottom of a rail.
    tester.view.physicalSize = const Size(844, 390);
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

    // The strip sits between the table and the rack, so the rack's top edge is
    // the real fold: measuring against the screen height would pass even with a
    // button hidden behind the rack.
    final rackTop = tester.getRect(find.byType(RackWidget)).top;
    final screen = tester.view.physicalSize.width / tester.view.devicePixelRatio;
    final bar = find.byType(Wrap).first;

    for (final label in <String>[
      l10n.gameOpenAction,
      l10n.gameDiscardPile,
      l10n.gameLayMeld,
      l10n.gameLayPairs,
      l10n.commonUndo,
    ]) {
      // Scoped to the strip: "Iskarta" also labels the player's own discard
      // pile out on the table, and an unscoped finder measures that instead.
      final finder = find.descendant(of: bar, matching: find.text(label));
      expect(finder, findsOneWidget, reason: '$label is missing');
      final rect = tester.getRect(finder);
      expect(
        rect.bottom,
        lessThanOrEqualTo(rackTop),
        reason: '$label ends at ${rect.bottom}, below the rack top at $rackTop',
      );
      expect(rect.top, greaterThanOrEqualTo(0.0), reason: '$label is above');
      expect(rect.left, greaterThanOrEqualTo(0.0), reason: '$label is off left');
      expect(
        rect.right,
        lessThanOrEqualTo(screen),
        reason: '$label ends at ${rect.right}, past the screen at $screen',
      );
    }
  });

  testWidgets('the deck and the indicator fit above the rack', (tester) async {
    // The column scrolls, which is the safety net on a tiny viewport - and
    // also the trap: a slot pushed past the fold is still laid out, just
    // invisible. On the size the game is actually played at, both have to be
    // on screen.
    tester.view.physicalSize = const Size(844, 390);
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

    final rackTop = tester.getRect(find.byType(RackWidget)).top;
    for (final label in <String>[
      l10n.gameRemainingTiles(state.drawPile.length),
      l10n.gameIndicator,
    ]) {
      final finder = find.text(label);
      expect(finder, findsOneWidget, reason: '$label is missing');
      expect(
        tester.getRect(finder).bottom,
        lessThanOrEqualTo(rackTop),
        reason: '$label is hidden behind the rack',
      );
    }
  });

  testWidgets('tapping the deck after drawing explains the order',
      (tester) async {
    // The seat that deals starts with 22 tiles in the discard phase, so the
    // deck is legitimately dead on that turn - two or three hands of every
    // match. Silence there is what got reported as "I cannot draw".
    tester.view.physicalSize = const Size(844, 390);
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

    final pile = find.ancestor(
      of: find.text(l10n.gameRemainingTiles(state.drawPile.length)),
      matching: find.byType(GestureDetector),
    );
    await tester.tap(pile.first, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text(l10n.errWrongPhase), findsOneWidget);
  });

  testWidgets('a tile can be pulled off the deck onto the rack',
      (tester) async {
    // Tapping works, but taking hold of a tile and dragging it home is how the
    // game is played, and it was the missing gesture behind "I cannot draw
    // from the deck".
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final state = buildState(
      indicator: indicator,
      hands: buildHands(
        indicator: indicator,
        okey: okeyIdentity,
        cores: [tooLow, const <Tile>[], const <Tile>[], const <Tile>[]],
      ),
      phase: TurnPhase.awaitingDraw,
    );
    final l10n = await pumpGame(tester, state);

    final before = state.drawPile.length;
    final deck = find.text(l10n.gameRemainingTiles(before));
    expect(deck, findsOneWidget);

    final gesture =
        await tester.startGesture(tester.getCenter(deck));
    await tester.pump(const Duration(milliseconds: 40));
    await gesture.moveTo(tester.getCenter(find.byType(RackWidget)));
    await tester.pump(const Duration(milliseconds: 40));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(
      find.text(l10n.gameRemainingTiles(before - 1)),
      findsOneWidget,
      reason: 'dragging off the deck did not draw',
    );
  });

  testWidgets('a rack tile dropped on the discard pile is thrown',
      (tester) async {
    // Releasing a drag anywhere above the rack used to discard, which fired by
    // accident whenever a tile was moved between rows. Removing it took away
    // the only gesture anyone uses to throw. It is back, but only over the
    // pile itself.
    tester.view.physicalSize = const Size(844, 390);
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
    await pumpGame(tester, state, fastMode: true);

    final rack = tester.getRect(find.byType(RackWidget));
    // The player's own pile is at the bottom right corner: that is where they
    // and the seat on their right meet, and that seat is the one entitled to
    // take it. The right rail holds two piles, so height decides between them.
    final spots = find.byType(DiscardSpot).evaluate().toList()
      ..sort((a, b) {
        final left = tester.getCenter(find.byWidget(a.widget));
        final right = tester.getCenter(find.byWidget(b.widget));
        final byColumn = left.dx.compareTo(right.dx);
        return byColumn != 0 ? byColumn : left.dy.compareTo(right.dy);
      });
    final target = tester.getCenter(find.byWidget(spots.last.widget));

    // The rack is height-capped in landscape, so it is narrower than its box
    // and centred inside it: an offset from rack.left lands in the margin.
    // Grab an actual tile instead.
    expect(rack.width, greaterThan(0));
    final firstTile = find
        .descendant(
          of: find.byType(RackWidget),
          matching: find.byType(TileWidget),
        )
        .first;
    final gesture = await tester.startGesture(tester.getCenter(firstTile));
    await tester.pump(const Duration(milliseconds: 40));
    await gesture.moveTo(target);
    await tester.pump(const Duration(milliseconds: 40));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(
      state.players[0].hand.length,
      22,
      reason: 'the fixture should start with a tile to throw',
    );
    expect(
      tester
          .widget<RackWidget>(find.byType(RackWidget))
          .tilesById
          .length,
      21,
      reason: 'the tile dropped on the pile was not thrown',
    );
  });

  testWidgets('the rack still works while an opponent is playing',
      (tester) async {
    // Exactly the reported sequence: you throw a tile, the turn goes round to
    // the opponents, and now you cannot touch your own tiles. Arranging the
    // rack is not a move - the engine never learns about slots, and none of
    // the controller's layout methods look at the turn - so it had no business
    // being locked to it.
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final state = buildState(
      indicator: indicator,
      hands: buildHands(
        indicator: indicator,
        okey: okeyIdentity,
        cores: [tooLow, const <Tile>[], const <Tile>[], const <Tile>[]],
      ),
      currentSeat: 1,
    );
    // Unsettled on purpose: settling would play the bot's turn out and hand
    // the move straight back, which is not the state under test.
    final l10n = await pumpGame(tester, state, settle: false);
    // It is a bot's turn, so the moves are refused - which is the state under
    // test. The header no longer says so in words, so ask the buttons.
    expect(
      tester
          .widget<FilledButton>(
            find.ancestor(
              of: find.descendant(
                of: find.byType(Wrap).first,
                matching: find.text(l10n.gameDiscardPile),
              ),
              matching: find.byType(FilledButton),
            ),
          )
          .onPressed,
      isNull,
      reason: 'the move should be refused: it is a bot playing',
    );

    final before =
        List<int?>.of(tester.widget<RackWidget>(find.byType(RackWidget)).slots);
    final rack = tester.getRect(find.byType(RackWidget));
    final from = tester.getCenter(
      find
          .descendant(
            of: find.byType(RackWidget),
            matching: find.byType(TileWidget),
          )
          .first,
    );
    final gesture = await tester.startGesture(from);
    await tester.pump(const Duration(milliseconds: 40));
    await gesture.moveTo(Offset(from.dx + 140, rack.center.dy));
    await tester.pump(const Duration(milliseconds: 40));
    await gesture.up();
    await tester.pump();

    final after = tester.widget<RackWidget>(find.byType(RackWidget)).slots;
    expect(
      after,
      isNot(before),
      reason: 'the rack refused an arrangement while a bot was playing',
    );
    expect(
      after.whereType<int>().toSet(),
      before.whereType<int>().toSet(),
      reason: 'rearranging must not lose or gain a tile',
    );

    // Sorting is the same kind of thing, and was locked the same way. Both
    // buttons live beside the rack now.
    for (final label in <String>[
      l10n.gameSortRunsShort,
      l10n.gameSortSetsShort,
    ]) {
      expect(
        tester
            .widget<OutlinedButton>(
              find.ancestor(
                of: find.text(label),
                matching: find.byType(OutlinedButton),
              ),
            )
            .onPressed,
        isNotNull,
        reason: '$label arranges the rack, it is not a move',
      );
    }

    // Drain the bots so no think timer is left pending.
    await tester.pumpAndSettle(const Duration(minutes: 2));
  });

  testWidgets('loading gold adds to the purse and says where it came from',
      (tester) async {
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final state = buildState(
      indicator: indicator,
      hands: buildHands(
        indicator: indicator,
        okey: okeyIdentity,
        cores: [tooLow, const <Tile>[], const <Tile>[], const <Tile>[]],
      ),
    );
    final l10n = await pumpGame(tester, state);

    expect(find.text('5.000'), findsOneWidget, reason: 'the starting gold');
    expect(find.text('10'), findsWidgets, reason: 'the starting diamonds');

    await tester.tap(find.byIcon(Icons.add_circle));
    await tester.pumpAndSettle();

    expect(find.text('10.000'), findsOneWidget);
    // The game sells nothing, and the message says so rather than pretending a
    // purchase happened.
    expect(
      find.text(l10n.walletTopUpBody(Wallet.topUpAmount)),
      findsOneWidget,
    );
  });

  testWidgets('opening works on the landscape board too', (tester) async {
    tester.view.physicalSize = const Size(844, 390);
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

    expect(boardTiles, findsNothing);
    await tester.tap(find.widgetWithText(FilledButton, l10n.gameOpenAction));
    await tester.pumpAndSettle();
    expect(boardTiles, findsWidgets);
  });

  testWidgets('working a tile onto a table meld has its own button',
      (tester) async {
    // "Islemek" used to be reachable only by tapping a meld with exactly one
    // tile selected, which nobody discovers.
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final blueRun = Meld(
      id: 1,
      kind: MeldKind.run,
      ownerSeat: 1,
      tiles: [blue(4), blue(5), blue(6)],
      jokerAssignments: const [null, null, null],
    );
    final state = buildState(
      indicator: indicator,
      hands: buildHands(
        indicator: indicator,
        okey: okeyIdentity,
        cores: [
          [blue(7)],
          const <Tile>[],
          const <Tile>[],
          const <Tile>[],
        ],
        sizes: const [22, 21, 21, 21],
        reserved: [blue(4), blue(5), blue(6)],
      ),
      table: [blueRun],
      opened: const [true, true, false, false],
    );
    final l10n = await pumpGame(tester, state);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(GameScreen)),
    );
    final controller = container.read(gameControllerProvider.notifier);

    // Nothing selected: the button is there but does nothing.
    expect(find.text(l10n.gameAddToMeld), findsOneWidget);
    expect(controller.addableMeldIds(), isEmpty);

    // Selecting blue 7 marks the blue 4-5-6 run as a legal target.
    controller.toggleSelection(blue(7).id);
    await tester.pumpAndSettle();
    expect(controller.addableMeldIds(), {1});

    final before = tester.widgetList(boardTiles).length;
    await tester.tap(find.text(l10n.gameAddToMeld));
    await tester.pumpAndSettle();

    expect(tester.widgetList(boardTiles).length, before + 1);
    final table = container.read(gameControllerProvider)!.state.table;
    expect(table.single.tiles.length, 4);
    expect(table.single.tiles.last, blue(7));
  });

  testWidgets('a tile that fits nowhere says so instead of doing nothing',
      (tester) async {
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final blueRun = Meld(
      id: 1,
      kind: MeldKind.run,
      ownerSeat: 1,
      tiles: [blue(4), blue(5), blue(6)],
      jokerAssignments: const [null, null, null],
    );
    final state = buildState(
      indicator: indicator,
      hands: buildHands(
        indicator: indicator,
        okey: okeyIdentity,
        cores: [
          [blue(11)],
          const <Tile>[],
          const <Tile>[],
          const <Tile>[],
        ],
        sizes: const [22, 21, 21, 21],
        reserved: [blue(4), blue(5), blue(6)],
      ),
      table: [blueRun],
      opened: const [true, true, false, false],
    );
    await pumpGame(tester, state);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(GameScreen)),
    );
    final controller = container.read(gameControllerProvider.notifier)
      ..toggleSelection(blue(11).id);
    await tester.pumpAndSettle();

    expect(controller.addableMeldIds(), isEmpty);
    controller.workSelection();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Bu taş o ele işlenemez.'), findsOneWidget);
  });

  testWidgets('tapping a meld works the selected tile onto it', (tester) async {
    // Every tile of a meld paints itself and absorbs the tap, so the tap lands
    // on a tile, not on the meld background. A non-wild position used to be
    // routed to joker replacement, which always failed.
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final blueRun = Meld(
      id: 1,
      kind: MeldKind.run,
      ownerSeat: 0,
      tiles: [blue(4), blue(5), blue(6)],
      jokerAssignments: const [null, null, null],
    );
    final state = buildState(
      indicator: indicator,
      hands: buildHands(
        indicator: indicator,
        okey: okeyIdentity,
        cores: [
          [blue(7)],
          const <Tile>[],
          const <Tile>[],
          const <Tile>[],
        ],
        sizes: const [22, 21, 21, 21],
        reserved: [blue(4), blue(5), blue(6)],
      ),
      table: [blueRun],
      opened: const [true, false, false, false],
    );
    await pumpGame(tester, state);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(GameScreen)),
    );
    container.read(gameControllerProvider.notifier).toggleSelection(blue(7).id);
    await tester.pumpAndSettle();

    await tester.tap(boardTiles.first);
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsNothing, reason: 'should not error');
    final table = container.read(gameControllerProvider)!.state.table;
    expect(table.single.tiles.length, 4);
    expect(table.single.tiles.last, blue(7));
  });

  testWidgets('a tile that fits the LOW end of a run is accepted',
      (tester) async {
    // The tap path used to hard-code atStart: false, so only the high end of a
    // run could ever be extended.
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final blueRun = Meld(
      id: 1,
      kind: MeldKind.run,
      ownerSeat: 0,
      tiles: [blue(5), blue(6), blue(7)],
      jokerAssignments: const [null, null, null],
    );
    final state = buildState(
      indicator: indicator,
      hands: buildHands(
        indicator: indicator,
        okey: okeyIdentity,
        cores: [
          [blue(4)],
          const <Tile>[],
          const <Tile>[],
          const <Tile>[],
        ],
        sizes: const [22, 21, 21, 21],
        reserved: [blue(5), blue(6), blue(7)],
      ),
      table: [blueRun],
      opened: const [true, false, false, false],
    );
    await pumpGame(tester, state);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(GameScreen)),
    );
    final controller = container.read(gameControllerProvider.notifier)
      ..toggleSelection(blue(4).id);
    await tester.pumpAndSettle();
    expect(controller.addableMeldIds(), {1});

    controller.workSelection();
    await tester.pumpAndSettle();

    final table = container.read(gameControllerProvider)!.state.table;
    expect(table.single.tiles.length, 4);
    expect(table.single.tiles.first, blue(4), reason: 'went to the low end');
  });

  testWidgets('isleme does not depend on the order tiles were tapped',
      (tester) async {
    // Selecting 9 before 8 for a 5-6-7 run: 9 is illegal until 8 is down, so a
    // single pass would strand it.
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final blueRun = Meld(
      id: 1,
      kind: MeldKind.run,
      ownerSeat: 0,
      tiles: [blue(5), blue(6), blue(7)],
      jokerAssignments: const [null, null, null],
    );
    final state = buildState(
      indicator: indicator,
      hands: buildHands(
        indicator: indicator,
        okey: okeyIdentity,
        cores: [
          [blue(9), blue(8)],
          const <Tile>[],
          const <Tile>[],
          const <Tile>[],
        ],
        sizes: const [22, 21, 21, 21],
        reserved: [blue(5), blue(6), blue(7)],
      ),
      table: [blueRun],
      opened: const [true, false, false, false],
    );
    await pumpGame(tester, state);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(GameScreen)),
    );
    final controller = container.read(gameControllerProvider.notifier)
      // Deliberately the awkward order.
      ..toggleSelection(blue(9).id)
      ..toggleSelection(blue(8).id);
    await tester.pumpAndSettle();

    controller.workSelection();
    await tester.pumpAndSettle();

    final table = container.read(gameControllerProvider)!.state.table;
    expect(table.single.tiles.length, 5, reason: 'both tiles went down');
    expect(table.single.tiles.last, blue(9));
  });

  testWidgets('nothing is highlighted before the player has drawn',
      (tester) async {
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final blueRun = Meld(
      id: 1,
      kind: MeldKind.run,
      ownerSeat: 0,
      tiles: [blue(4), blue(5), blue(6)],
      jokerAssignments: const [null, null, null],
    );
    final state = buildState(
      indicator: indicator,
      hands: buildHands(
        indicator: indicator,
        okey: okeyIdentity,
        cores: [
          [blue(7)],
          const <Tile>[],
          const <Tile>[],
          const <Tile>[],
        ],
        reserved: [blue(4), blue(5), blue(6)],
      ),
      table: [blueRun],
      opened: const [true, false, false, false],
      phase: TurnPhase.awaitingDraw,
    );
    await pumpGame(tester, state);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(GameScreen)),
    );
    final controller = container.read(gameControllerProvider.notifier)
      ..toggleSelection(blue(7).id);
    await tester.pumpAndSettle();

    expect(
      controller.addableMeldIds(),
      isEmpty,
      reason: 'the engine would refuse it until a tile has been drawn',
    );
  });

  testWidgets('Seri and Per each rearrange the rack', (tester) async {
    // Two buttons beside the rack instead of a Sort button that opened a
    // sheet: sorting is reached far more often than any move, and it belongs
    // next to the tiles it sorts.
    tester.view.physicalSize = const Size(844, 390);
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

    List<int?> slots() =>
        List<int?>.of(tester.widget<RackWidget>(find.byType(RackWidget)).slots);

    final dealt = slots();
    await tester.tap(find.text(l10n.gameSortSetsShort));
    await tester.pumpAndSettle();
    final bySets = slots();

    await tester.tap(find.text(l10n.gameSortRunsShort));
    await tester.pumpAndSettle();
    final byRuns = slots();

    expect(bySets, isNot(byRuns), reason: 'the two modes must differ');
    expect(
      byRuns.whereType<int>().toSet(),
      dealt.whereType<int>().toSet(),
      reason: 'sorting must not lose or gain a tile',
    );
  });
}
