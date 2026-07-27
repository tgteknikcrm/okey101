import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/ai/bot_utils.dart';
import 'package:okey101/domain/ai/easy_bot.dart';
import 'package:okey101/domain/ai/hard_bot.dart';
import 'package:okey101/domain/ai/medium_bot.dart';
import 'package:okey101/domain/engine/player_view_factory.dart';
import 'package:okey101/domain/engine/random_source.dart';
import 'package:okey101/domain/models/game_action.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/player_view.dart';
import 'package:okey101/domain/models/tile.dart';

import 'engine_support.dart';
import 'test_tiles.dart';

/// The bots' pairs decisions, which had no test at all - which is how a road
/// with zero reachable finishes shipped.
void main() {
  final indicator = black(1);
  const okeyIdentity = TileIdentity(color: TileColor.black, number: 2);

  /// Five clean pairs plus one spare, which the rules need: an opening that
  /// used the whole rack would leave nothing to discard and be refused.
  ///
  /// Hand sizes here are exact. buildHands pads a short hand with filler, and
  /// filler makes pairs of its own - which is how the first version of this
  /// test asked about four pairs and was handed seven.
  final fivePairs = <Tile>[
    red(3), red(3, 1), //
    red(7), red(7, 1), //
    yellow(5), yellow(5, 1), //
    blue(9), blue(9, 1), //
    black(11), black(11, 1), //
    black(8),
  ];

  /// Nine low tiles worth 18 melded - the normal open is nowhere near.
  final tooLow = <Tile>[
    red(1), red(2), //
    yellow(1), yellow(2), //
    blue(1), blue(2), //
    black(4), black(6), black(8),
  ];

  PlayerView viewOf(
    GameState state, {
    int seat = 0,
  }) =>
      PlayerViewFactory.forSeat(state, seat);

  GameState stateWith({
    required List<Tile> core,
    List<Meld> table = const <Meld>[],
    List<bool> opened = const [false, false, false, false],
    List<bool> openedWithPairs = const [false, false, false, false],
    int handSize = 21,
  }) =>
      buildState(
        indicator: indicator,
        hands: buildHands(
          indicator: indicator,
          okey: okeyIdentity,
          cores: [core, const <Tile>[], const <Tile>[], const <Tile>[]],
          sizes: [handSize, 21, 21, 21],
        ),
        table: table,
        opened: opened,
        openedWithPairs: openedWithPairs,
        openedCount: opened.where((o) => o).length,
      );

  group('opening on the pairs road', () {
    test('every difficulty lays five pairs when the normal open is out of '
        'reach', () {
      final state = stateWith(core: fivePairs, handSize: fivePairs.length);
      final view = viewOf(state);

      for (final brain in <({String name, GameAction Function() decide})>[
        // mistakeRate 0: the question is whether the branch exists at all, not
        // whether this particular seed rolled a beginner's blunder.
        (name: 'easy',
            decide: () =>
                const EasyBot(mistakeRate: 0).decide(view, RandomSource(7))),
        (name: 'medium', decide: () => const MediumBot().decide(view, RandomSource(7))),
        (name: 'hard', decide: () => const HardBot().decide(view, RandomSource(7))),
      ]) {
        expect(
          brain.decide(),
          isA<LayPairs>(),
          reason: '${brain.name} passed up a five-pair opening',
        );
      }
    });

    test('a hand that leans to pairs commits to the road', () {
      // Four pairs and a normal open a long way off. This is the state a hand
      // has to be able to recognise: five pairs are never dealt, so a bot only
      // ever reaches the road by committing early and collecting.
      final fourPairs = <Tile>[
        red(3), red(3, 1), //
        red(7), red(7, 1), //
        yellow(5), yellow(5, 1), //
        blue(9), blue(9, 1),
      ];
      final view =
          viewOf(stateWith(core: fourPairs, handSize: fourPairs.length));
      final road = BotUtils.pairsRoad(view, bestPoints: 40);
      expect(road.count, 4);
      expect(road.committed, isTrue);
    });

    test('a hand that can already open normally does not', () {
      final view =
          viewOf(stateWith(core: fivePairs, handSize: fivePairs.length));
      final road = BotUtils.pairsRoad(
        view,
        // Above the threshold: the normal lay-down is there for the taking.
        bestPoints: 120,
      );
      expect(road.committed, isFalse);
    });
  });

  group('after opening on pairs', () {
    Meld pairMeld(int id, Tile a, Tile b) => Meld(
          id: id,
          kind: MeldKind.pair,
          ownerSeat: 0,
          tiles: [a, b],
          jokerAssignments: const [null, null],
        );

    test('the sixth pair goes down instead of waiting for the eleventh', () {
      // Five pairs are already on the table and the rack holds one more plus
      // spares. Every bot used to demand the whole jump from five to eleven in
      // a single move, which happened zero times in 38,000 simulated hands: a
      // bot that opened on pairs had guaranteed itself a loss.
      final table = <Meld>[
        pairMeld(1, red(3), red(3, 1)),
        pairMeld(2, red(7), red(7, 1)),
        pairMeld(3, yellow(5), yellow(5, 1)),
        pairMeld(4, blue(9), blue(9, 1)),
        pairMeld(5, black(11), black(11, 1)),
      ];
      final rack = <Tile>[
        yellow(12), yellow(12, 1), // the sixth pair
        ...tooLow,
      ];
      final state = stateWith(
        core: rack,
        table: table,
        opened: const [true, false, false, false],
        openedWithPairs: const [true, false, false, false],
        handSize: 11,
      );
      final view = viewOf(state);

      final laid = BotUtils.pairsToLayAfterOpening(view);
      expect(laid, isNotNull);
      expect(laid, isNotEmpty);

      expect(const MediumBot().decide(view, RandomSource(7)), isA<LayPairs>());
      expect(const HardBot().decide(view, RandomSource(7)), isA<LayPairs>());
    });

    test('a rack with no pair left lays nothing', () {
      final state = stateWith(
        core: tooLow,
        table: <Meld>[pairMeld(1, red(3), red(3, 1))],
        opened: const [true, false, false, false],
        openedWithPairs: const [true, false, false, false],
        handSize: 9,
      );
      expect(BotUtils.pairsToLayAfterOpening(viewOf(state)), isNull);
    });
  });
}
