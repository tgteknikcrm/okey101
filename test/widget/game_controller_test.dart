import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/app/providers.dart';
import 'package:okey101/data/local_store.dart';
import 'package:okey101/data/models/saved_game.dart';
import 'package:okey101/domain/models/game_error.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/features/game/game_controller.dart';
import 'package:okey101/features/game/game_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/engine_support.dart';
import '../domain/test_tiles.dart';
/// A plain test rather than a widget test: putting the table on a bot's turn
/// starts the think timer, and testWidgets fails any test that leaves one
/// pending. The behaviour under test lives in the controller anyway.
void main() {
  final indicator = black(1);
  const okeyIdentity = TileIdentity(color: TileColor.black, number: 2);
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
  test('a move made out of turn is refused out loud, not in silence', () async {
    // A control that does nothing at all when tapped is indistinguishable from
    // a broken game. Between your turns the three bots think for a couple of
    // seconds apiece, and every tap on the deck in that window used to be
    // swallowed - which reads exactly like "I cannot draw from the deck".
    final container = ProviderContainer(
      overrides: [
        localStoreProvider.overrideWithValue(store),
        nowProvider.overrideWithValue(() => 0),
      ],
    );
    addTearDown(container.dispose);
    final state = buildState(
      indicator: indicator,
      hands: buildHands(
        indicator: indicator,
        okey: okeyIdentity,
        cores: [tooLow, const <Tile>[], const <Tile>[], const <Tile>[]],
      ),
      currentSeat: 1,
    );
    final controller = container.read(gameControllerProvider.notifier)
      ..restore(
        SavedGame(
          state: state,
          rackSlots: RackLayout.fromTiles(state.players[0].hand),
          savedAtMs: 0,
        ),
      )
      ..drawFromPile();
    expect(
      container.read(gameControllerProvider)?.lastError,
      isA<NotYourTurn>(),
    );
    controller.leave();
  });
}
