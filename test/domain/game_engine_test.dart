import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/engine/engine_result.dart';
import 'package:okey101/domain/engine/game_engine.dart';
import 'package:okey101/domain/engine/state_invariants.dart';
import 'package:okey101/domain/models/game_action.dart';
import 'package:okey101/domain/models/game_error.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/scoring.dart';
import 'package:okey101/domain/models/tile.dart';

import 'engine_support.dart';
import 'test_tiles.dart';

void main() {
  // Indicator black 1 -> the okey is black 2. No fixture below uses black 2
  // unless it means to.
  final indicator = black(1);
  const okeyIdentity = TileIdentity(color: TileColor.black, number: 2);

  /// Four hands: seat 0 gets [core] padded to [size0], the rest get 21 fillers.
  List<List<Tile>> hands(
    List<Tile> core, {
    int size0 = 22,
    List<Tile> reserved = const <Tile>[],
    List<List<Tile>>? otherCores,
    List<int>? otherSizes,
  }) =>
      buildHands(
        indicator: indicator,
        okey: okeyIdentity,
        cores: [
          core,
          ...otherCores ?? const [<Tile>[], <Tile>[], <Tile>[]],
        ],
        sizes: [size0, ...otherSizes ?? const [21, 21, 21]],
        reserved: reserved,
      );

  // Exactly 101: four 13s (52) + three 9s (27) + run red 4-5-6-7 (22).
  final open101 = <Tile>[
    red(13), yellow(13), black(13), blue(13), //
    red(9), yellow(9), blue(9), //
    red(4), red(5), red(6), red(7),
  ];
  final proposals101 = <MeldProposal>[
    MeldProposal(
      kind: MeldKind.set,
      tileIds: [red(13).id, yellow(13).id, black(13).id, blue(13).id],
    ),
    MeldProposal(
      kind: MeldKind.set,
      tileIds: [red(9).id, yellow(9).id, blue(9).id],
    ),
    MeldProposal(
      kind: MeldKind.run,
      tileIds: [red(4).id, red(5).id, red(6).id, red(7).id],
    ),
  ];

  // Exactly 100: four 13s (52) + three 9s (27) + run blue 6-7-8 (21).
  final open100 = <Tile>[
    red(13), yellow(13), black(13), blue(13), //
    red(9), yellow(9), blue(9), //
    blue(6), blue(7), blue(8),
  ];
  final proposals100 = <MeldProposal>[
    MeldProposal(
      kind: MeldKind.set,
      tileIds: [red(13).id, yellow(13).id, black(13).id, blue(13).id],
    ),
    MeldProposal(
      kind: MeldKind.set,
      tileIds: [red(9).id, yellow(9).id, blue(9).id],
    ),
    MeldProposal(
      kind: MeldKind.run,
      tileIds: [blue(6).id, blue(7).id, blue(8).id],
    ),
  ];

  GameError errorOf(EngineResult result) => (result as EngineErr).error;
  GameState stateOf(EngineResult result) => (result as EngineOk).state;

  group('drawing', () {
    test('drawing from the pile moves one tile and switches to discard phase',
        () {
      final state = buildState(
        indicator: indicator,
        hands: hands(const [], size0: 21),
        phase: TurnPhase.awaitingDraw,
      );
      final before = state.drawPile.length;
      final next = stateOf(
        GameEngine.apply(state, const GameAction.drawFromPile()),
      );
      expect(next.players[0].hand.length, 22);
      expect(next.drawPile.length, before - 1);
      expect(next.phase, TurnPhase.awaitingDiscard);
      expect(StateInvariants.violation(next), isNull);
    });

    test('drawing twice is rejected with WrongPhase', () {
      final state = buildState(
        indicator: indicator,
        hands: hands(const [], size0: 21),
        phase: TurnPhase.awaitingDraw,
      );
      final once = stateOf(
        GameEngine.apply(state, const GameAction.drawFromPile()),
      );
      expect(
        errorOf(GameEngine.apply(once, const GameAction.drawFromPile())),
        const GameError.wrongPhase(),
      );
    });

    test('the discard drawn from belongs to the LEFT neighbour', () {
      // Seat 3 is seat 0's left neighbour and plays immediately before it.
      final state = buildState(
        indicator: indicator,
        hands: hands(const [], size0: 21, reserved: [blue(12)]),
        discards: [<Tile>[], <Tile>[], <Tile>[], [blue(12)]],
        phase: TurnPhase.awaitingDraw,
      );
      final next = stateOf(
        GameEngine.apply(state, const GameAction.drawFromDiscard()),
      );
      expect(next.players[0].hand.any((t) => t.id == blue(12).id), isTrue);
      expect(next.players[3].discards.any((t) => t.id == blue(12).id), isFalse);
      expect(next.takenFromDiscardTileId, blue(12).id);
      expect(StateInvariants.violation(next), isNull);
    });

    test('a tile taken from the discard pile cannot go straight back', () {
      final state = buildState(
        indicator: indicator,
        hands: hands(const [], size0: 21, reserved: [blue(12)]),
        discards: [<Tile>[], <Tile>[], <Tile>[], [blue(12)]],
        phase: TurnPhase.awaitingDraw,
      );
      final drawn = stateOf(
        GameEngine.apply(state, const GameAction.drawFromDiscard()),
      );
      expect(
        errorOf(
          GameEngine.apply(drawn, GameAction.discard(tileId: blue(12).id)),
        ),
        GameError.sameTileDiscardedBack(tileId: blue(12).id),
      );
      // Any other tile is fine.
      final other =
          drawn.players[0].hand.firstWhere((t) => t.id != blue(12).id);
      expect(
        GameEngine.apply(drawn, GameAction.discard(tileId: other.id)),
        isA<EngineOk>(),
      );
    });

    test('canTakeDiscardBeforeOpening gates the discard draw', () {
      final state = buildState(
        indicator: indicator,
        hands: hands(const [], size0: 21, reserved: [blue(12)]),
        discards: [<Tile>[], <Tile>[], <Tile>[], [blue(12)]],
        phase: TurnPhase.awaitingDraw,
        rules:
            RulePresets.standard.copyWith(canTakeDiscardBeforeOpening: false),
      );
      expect(
        errorOf(GameEngine.apply(state, const GameAction.drawFromDiscard())),
        const GameError.takeDiscardBeforeOpeningDisabled(),
      );
    });

    test('an empty left-hand discard pile is rejected', () {
      final state = buildState(
        indicator: indicator,
        hands: hands(const [], size0: 21),
        // Everything the helper cannot place goes to the bottom of the piles,
        // so force the surplus into the draw pile instead.
        drawPileSize: 1000,
        phase: TurnPhase.awaitingDraw,
      );
      expect(
        errorOf(GameEngine.apply(state, const GameAction.drawFromDiscard())),
        const GameError.discardPileEmpty(),
      );
    });
  });

  group('discarding and turn order', () {
    test('discarding passes the turn counter-clockwise to the right', () {
      final state = buildState(indicator: indicator, hands: hands(const []));
      final tile = state.players[0].hand.first;
      final next =
          stateOf(GameEngine.apply(state, GameAction.discard(tileId: tile.id)));
      expect(next.currentSeat, 1);
      expect(next.phase, TurnPhase.awaitingDraw);
      expect(next.players[0].hand.length, 21);
      expect(next.players[0].discards.last, tile);
      expect(StateInvariants.violation(next), isNull);
    });

    test('discarding a tile that is not in hand is rejected', () {
      final state = buildState(indicator: indicator, hands: hands(const []));
      final absent = state.drawPile.first;
      expect(
        errorOf(GameEngine.apply(state, GameAction.discard(tileId: absent.id))),
        GameError.tileNotInHand(tileId: absent.id),
      );
    });

    test('discarding out of turn phase is rejected', () {
      final state = buildState(
        indicator: indicator,
        hands: hands(const [], size0: 21),
        phase: TurnPhase.awaitingDraw,
      );
      expect(
        errorOf(
          GameEngine.apply(
            state,
            GameAction.discard(tileId: state.players[0].hand.first.id),
          ),
        ),
        const GameError.wrongPhase(),
      );
    });
  });

  group('opening (acma)', () {
    GameState openingState({
      RuleSet? rules,
      List<Tile>? core,
      int openedCount = 0,
    }) =>
        buildState(
          indicator: indicator,
          hands: hands(core ?? open101),
          rules: rules ?? RulePresets.standard,
          openedCount: openedCount,
        );

    test('exactly 101 is accepted', () {
      final result = GameEngine.apply(
        openingState(),
        GameAction.open(melds: proposals101),
      );
      expect(result, isA<EngineOk>());
      final next = stateOf(result);
      expect(next.players[0].hasOpened, isTrue);
      expect(next.table.length, 3);
      expect(next.openedCount, 1);
      expect(next.openedThisTurn, isTrue);
      expect(next.players[0].hand.length, 22 - 11);
      expect(StateInvariants.violation(next), isNull);
    });

    test('exactly 100 is rejected', () {
      final result = GameEngine.apply(
        openingState(core: open100),
        GameAction.open(melds: proposals100),
      );
      expect(
        errorOf(result),
        const GameError.openThresholdNotMet(
          requiredPoints: 101,
          actualPoints: 100,
        ),
      );
    });

    test('a rejected open leaves the state completely untouched', () {
      final state = openingState(core: open100);
      final result =
          GameEngine.apply(state, GameAction.open(melds: proposals100));
      expect(result, isA<EngineErr>());
      expect(result.stateOrNull, isNull);
      expect(state.table, isEmpty);
      expect(state.players[0].hasOpened, isFalse);
      expect(state.players[0].hand.length, 22);
    });

    test('opening twice is rejected', () {
      final opened = stateOf(
        GameEngine.apply(openingState(), GameAction.open(melds: proposals101)),
      );
      expect(
        errorOf(GameEngine.apply(opened, GameAction.open(melds: proposals101))),
        const GameError.alreadyOpened(),
      );
    });

    test('the escalating threshold raises the bar per opener in the hand', () {
      final rules =
          RulePresets.standard.copyWith(escalatingOpenThreshold: true);
      // The first opener still needs 101.
      expect(
        GameEngine.apply(
          openingState(rules: rules),
          GameAction.open(melds: proposals101),
        ),
        isA<EngineOk>(),
      );
      // The second opener needs 102, so the same 101 lay-down fails.
      expect(
        errorOf(
          GameEngine.apply(
            openingState(rules: rules, openedCount: 1),
            GameAction.open(melds: proposals101),
          ),
        ),
        const GameError.openThresholdNotMet(
          requiredPoints: 102,
          actualPoints: 101,
        ),
      );
    });

    test('the escalating threshold resets when a new hand is dealt', () {
      final rules = RulePresets.standard.copyWith(
        escalatingOpenThreshold: true,
        handsPerMatch: 5,
      );
      final state = buildState(
        indicator: indicator,
        hands: hands(const [], size0: 1),
        rules: rules,
        openedCount: 3,
        opened: const [true, true, true, false],
      );
      final finished = stateOf(
        GameEngine.apply(
          state,
          GameAction.discard(tileId: state.players[0].hand.single.id),
        ),
      );
      expect(finished.phase, TurnPhase.handOver);
      final dealt =
          stateOf(GameEngine.apply(finished, const GameAction.startNextHand()));
      expect(dealt.openedCount, 0);
      expect(dealt.players.every((p) => !p.hasOpened), isTrue);
      expect(dealt.players.every((p) => p.openOrder == -1), isTrue);
      expect(dealt.handNumber, 2);
      expect(dealt.drawPile.length, kDrawPileSize);
      expect(StateInvariants.violation(dealt), isNull);
    });

    test('a pair may not be smuggled into a normal open', () {
      expect(
        errorOf(
          GameEngine.apply(
            openingState(),
            GameAction.open(
              melds: [
                ...proposals101,
                MeldProposal(kind: MeldKind.pair, tileIds: [red(4).id]),
              ],
            ),
          ),
        ),
        const GameError.pairsPathViolation(),
      );
    });

    test('the same tile cannot be used in two melds', () {
      expect(
        errorOf(
          GameEngine.apply(
            openingState(),
            GameAction.open(
              melds: [
                proposals101[0],
                MeldProposal(
                  kind: MeldKind.set,
                  tileIds: [red(13).id, yellow(9).id, blue(9).id],
                ),
              ],
            ),
          ),
        ),
        GameError.duplicateTileInProposal(tileId: red(13).id),
      );
    });

    test('the faithful-simulation penalty is charged instead of rejecting', () {
      final rules = RulePresets.standard.copyWith(
        enforceIllegalOpenPenalty: true,
      );
      final state = buildState(
        indicator: indicator,
        hands: hands(open100),
        rules: rules,
      );
      final next = stateOf(
        GameEngine.apply(state, GameAction.open(melds: proposals100)),
      );
      expect(next.players[0].score, 101);
      expect(next.players[0].hasOpened, isFalse);
      // Still their turn, still owing a discard.
      expect(next.phase, TurnPhase.awaitingDiscard);
      expect(next.players[0].hand.length, 22);
    });
  });

  group('adding to melds (islemek)', () {
    Meld blueRun(int id, int owner) => Meld(
          id: id,
          kind: MeldKind.run,
          ownerSeat: owner,
          tiles: [blue(4), blue(5), blue(6)],
          jokerAssignments: const [null, null, null],
        );

    test('adding before opening is rejected', () {
      final state = buildState(
        indicator: indicator,
        hands: hands([blue(7)], reserved: [blue(4), blue(5), blue(6)]),
        table: [blueRun(1, 1)],
      );
      expect(
        errorOf(
          GameEngine.apply(
            state,
            GameAction.addToMeld(meldId: 1, tileId: blue(7).id),
          ),
        ),
        const GameError.cannotAddBeforeOpening(),
      );
    });

    test("an opened player may work onto anyone else's meld", () {
      final state = buildState(
        indicator: indicator,
        hands: hands([blue(7)], reserved: [blue(4), blue(5), blue(6)]),
        table: [blueRun(1, 1)],
        opened: const [true, true, false, false],
      );
      final next = stateOf(
        GameEngine.apply(
          state,
          GameAction.addToMeld(meldId: 1, tileId: blue(7).id),
        ),
      );
      expect(next.table.single.tiles.length, 4);
      expect(next.players[0].hand.length, 21);
      expect(StateInvariants.violation(next), isNull);
    });

    test('a tile that does not fit is rejected and never throws', () {
      final state = buildState(
        indicator: indicator,
        hands: hands([blue(11)], reserved: [blue(4), blue(5), blue(6)]),
        table: [blueRun(1, 1)],
        opened: const [true, true, false, false],
      );
      expect(
        errorOf(
          GameEngine.apply(
            state,
            GameAction.addToMeld(meldId: 1, tileId: blue(11).id),
          ),
        ),
        GameError.tileDoesNotExtendMeld(meldId: 1, tileId: blue(11).id),
      );
    });

    test('a missing meld id is rejected', () {
      final state = buildState(
        indicator: indicator,
        hands: hands([blue(7)]),
        opened: const [true, false, false, false],
      );
      expect(
        errorOf(
          GameEngine.apply(
            state,
            GameAction.addToMeld(meldId: 999, tileId: blue(7).id),
          ),
        ),
        const GameError.meldNotFound(meldId: 999),
      );
    });

    test('taking a table okey puts it in hand without forcing its use', () {
      final table = [
        Meld(
          id: 1,
          kind: MeldKind.run,
          ownerSeat: 2,
          tiles: [blue(4), black(2), blue(6)],
          jokerAssignments: const [
            null,
            TileIdentity(color: TileColor.blue, number: 5),
            null,
          ],
        ),
      ];
      final state = buildState(
        indicator: indicator,
        hands: hands([blue(5)], reserved: [blue(4), black(2), blue(6)]),
        table: table,
        opened: const [true, false, true, false],
      );
      final next = stateOf(
        GameEngine.apply(
          state,
          GameAction.replaceJoker(meldId: 1, index: 1, tileId: blue(5).id),
        ),
      );
      expect(next.table.single.tiles[1], blue(5));
      expect(next.table.single.jokerAssignments[1], isNull);
      expect(next.players[0].hand.any((t) => t.id == black(2).id), isTrue);
      expect(next.players[0].hand.length, 22);
      expect(StateInvariants.violation(next), isNull);
    });
  });

  group('finish types', () {
    GameState aboutToFinish({
      required Tile lastTile,
      bool openedThisTurn = false,
    }) =>
        buildState(
          indicator: indicator,
          hands: buildHands(
            indicator: indicator,
            okey: okeyIdentity,
            cores: [
              [lastTile],
              const <Tile>[],
              const <Tile>[],
              const <Tile>[],
            ],
            sizes: const [1, 21, 21, 21],
          ),
          opened: const [true, true, false, false],
          openedThisTurn: openedThisTurn,
        );

    test('normal: opened earlier, discards the last tile', () {
      final next = stateOf(
        GameEngine.apply(
          aboutToFinish(lastTile: blue(3)),
          GameAction.discard(tileId: blue(3).id),
        ),
      );
      expect(next.phase, TurnPhase.handOver);
      expect(next.handResult!.finishType, FinishType.normal);
      expect(next.handResult!.winnerSeat, 0);
      expect(StateInvariants.violation(next), isNull);
    });

    test('withOkey: the final discard is the okey', () {
      final next = stateOf(
        GameEngine.apply(
          aboutToFinish(lastTile: black(2)),
          GameAction.discard(tileId: black(2).id),
        ),
      );
      expect(next.handResult!.finishType, FinishType.withOkey);
    });

    test('head: opened and finished in the same turn', () {
      final next = stateOf(
        GameEngine.apply(
          aboutToFinish(lastTile: blue(3), openedThisTurn: true),
          GameAction.discard(tileId: blue(3).id),
        ),
      );
      expect(next.handResult!.finishType, FinishType.head);
    });

    test('okeyHead: a head finish whose last discard is the okey', () {
      final next = stateOf(
        GameEngine.apply(
          aboutToFinish(lastTile: black(2), openedThisTurn: true),
          GameAction.discard(tileId: black(2).id),
        ),
      );
      expect(next.handResult!.finishType, FinishType.okeyHead);
    });

    test('the 101 threshold applies to a head finish too', () {
      // A 22-tile hand of low runs is worth under 101, so it cannot be opened,
      // and therefore cannot become a kafa either.
      final lowRuns = <Tile>[
        red(1), red(2), red(3), //
        yellow(1), yellow(2), yellow(3), //
        blue(1), blue(2), blue(3),
      ];
      final state =
          buildState(indicator: indicator, hands: hands(lowRuns));
      expect(
        errorOf(
          GameEngine.apply(
            state,
            GameAction.open(
              melds: [
                MeldProposal(
                  kind: MeldKind.run,
                  tileIds: [red(1).id, red(2).id, red(3).id],
                ),
                MeldProposal(
                  kind: MeldKind.run,
                  tileIds: [yellow(1).id, yellow(2).id, yellow(3).id],
                ),
                MeldProposal(
                  kind: MeldKind.run,
                  tileIds: [blue(1).id, blue(2).id, blue(3).id],
                ),
              ],
            ),
          ),
        ),
        const GameError.openThresholdNotMet(
          requiredPoints: 101,
          actualPoints: 18,
        ),
      );
    });
  });

  group('pairs path (cift acma)', () {
    // 11 distinct colour/number combinations, none of them the okey.
    List<Tile> pairTiles(int count) => <Tile>[
          for (var i = 0; i < count; i++) ...[
            tile(TileColor.values[i % 4], (i ~/ 4) + 3),
            tile(TileColor.values[i % 4], (i ~/ 4) + 3, 1),
          ],
        ];

    List<MeldProposal> pairProposals(List<Tile> tiles) => <MeldProposal>[
          for (var i = 0; i < tiles.length; i += 2)
            MeldProposal(
              kind: MeldKind.pair,
              tileIds: [tiles[i].id, tiles[i + 1].id],
            ),
        ];

    test('four pairs is not enough to open', () {
      final core = pairTiles(4);
      final state = buildState(indicator: indicator, hands: hands(core));
      expect(
        errorOf(
          GameEngine.apply(
            state,
            GameAction.layPairs(pairs: pairProposals(core)),
          ),
        ),
        const GameError.notEnoughPairs(requiredPairs: 5, actualPairs: 4),
      );
    });

    test('five pairs opens on the pairs path', () {
      final core = pairTiles(5);
      final state = buildState(indicator: indicator, hands: hands(core));
      final next = stateOf(
        GameEngine.apply(
          state,
          GameAction.layPairs(pairs: pairProposals(core)),
        ),
      );
      expect(next.players[0].hasOpened, isTrue);
      expect(next.players[0].openedWithPairs, isTrue);
      expect(next.table.length, 5);
      expect(next.table.every((m) => m.kind == MeldKind.pair), isTrue);
      expect(StateInvariants.violation(next), isNull);
    });

    test('a pairs player may not lay runs or sets', () {
      final core = pairTiles(5);
      final state = buildState(
        indicator: indicator,
        hands: hands([...core, red(4), red(5), red(6)]),
        opened: const [true, false, false, false],
        openedWithPairs: const [true, false, false, false],
      );
      expect(
        errorOf(
          GameEngine.apply(
            state,
            GameAction.layMeld(
              meld: MeldProposal(
                kind: MeldKind.run,
                tileIds: [red(4).id, red(5).id, red(6).id],
              ),
            ),
          ),
        ),
        const GameError.pairsPathViolation(),
      );
    });

    test('a pairs player may not add to melds on the table', () {
      final core = pairTiles(5);
      final table = [
        Meld(
          id: 1,
          kind: MeldKind.run,
          ownerSeat: 1,
          tiles: [blue(4), blue(5), blue(6)],
          jokerAssignments: const [null, null, null],
        ),
      ];
      final state = buildState(
        indicator: indicator,
        hands: hands(
          [...core, blue(7)],
          reserved: [blue(4), blue(5), blue(6)],
        ),
        table: table,
        opened: const [true, false, false, false],
        openedWithPairs: const [true, false, false, false],
      );
      expect(
        errorOf(
          GameEngine.apply(
            state,
            GameAction.addToMeld(meldId: 1, tileId: blue(7).id),
          ),
        ),
        const GameError.pairsPathViolation(),
      );
    });

    test('eleven pairs finishes without a discard', () {
      final core = pairTiles(11);
      expect(core.length, 22);
      final state = buildState(
        indicator: indicator,
        hands: buildHands(
          indicator: indicator,
          okey: okeyIdentity,
          cores: [core, const <Tile>[], const <Tile>[], const <Tile>[]],
          sizes: const [22, 21, 21, 21],
        ),
      );
      final next = stateOf(
        GameEngine.apply(
          state,
          GameAction.layPairs(pairs: pairProposals(core)),
        ),
      );
      expect(next.phase, TurnPhase.handOver);
      expect(next.handResult!.finishType, FinishType.pairs);
      expect(next.handResult!.winnerSeat, 0);
      expect(next.players[0].hand, isEmpty);
      expect(StateInvariants.violation(next), isNull);
    });

    test('the okey completing the last pair gives pairsWithOkey', () {
      final core = pairTiles(10);
      final hand = <Tile>[...core, red(12), black(2)];
      expect(hand.length, 22);
      final state = buildState(
        indicator: indicator,
        hands: buildHands(
          indicator: indicator,
          okey: okeyIdentity,
          cores: [hand, const <Tile>[], const <Tile>[], const <Tile>[]],
          sizes: const [22, 21, 21, 21],
        ),
      );
      final next = stateOf(
        GameEngine.apply(
          state,
          GameAction.layPairs(
            pairs: [
              ...pairProposals(core),
              MeldProposal(
                kind: MeldKind.pair,
                tileIds: [red(12).id, black(2).id],
              ),
            ],
          ),
        ),
      );
      expect(next.handResult!.finishType, FinishType.pairsWithOkey);
    });

    test('two false jokers pair with each other on the pairs path', () {
      final core = pairTiles(10);
      final hand = <Tile>[...core, falseJoker0, falseJoker1];
      final state = buildState(
        indicator: indicator,
        hands: buildHands(
          indicator: indicator,
          okey: okeyIdentity,
          cores: [hand, const <Tile>[], const <Tile>[], const <Tile>[]],
          sizes: const [22, 21, 21, 21],
        ),
      );
      final next = stateOf(
        GameEngine.apply(
          state,
          GameAction.layPairs(
            pairs: [
              ...pairProposals(core),
              MeldProposal(
                kind: MeldKind.pair,
                tileIds: [falseJoker0.id, falseJoker1.id],
              ),
            ],
          ),
        ),
      );
      expect(next.phase, TurnPhase.handOver);
      // Neither false joker is wild, so this is a plain pairs finish.
      expect(next.handResult!.finishType, FinishType.pairs);
    });
  });

  group('deck exhaustion', () {
    test('the hand ends when the draw pile runs out, with no winner', () {
      final state = buildState(
        indicator: indicator,
        hands: hands(const []),
        drawPileSize: 0,
        opened: const [true, false, false, false],
      );
      final next = stateOf(
        GameEngine.apply(
          state,
          GameAction.discard(tileId: state.players[0].hand.first.id),
        ),
      );
      expect(next.phase, anyOf(TurnPhase.handOver, TurnPhase.matchOver));
      final result = next.handResult!;
      expect(result.winnerSeat, isNull);
      expect(result.finishType, isNull);
      expect(result.rowKey, ScoreRowKey.exhausted);
      // No flat never-opened penalty: everybody just writes their deadwood.
      for (final line in result.players) {
        expect(line.delta, line.deadwood);
      }
    });
  });

  group('illegal actions', () {
    test('never throw and always return a typed error', () {
      final state = buildState(
        indicator: indicator,
        hands: hands(const [], size0: 21),
        phase: TurnPhase.awaitingDraw,
      );
      const actions = <GameAction>[
        GameAction.discard(tileId: 999),
        GameAction.open(melds: []),
        GameAction.layPairs(pairs: []),
        GameAction.layMeld(
          meld: MeldProposal(kind: MeldKind.run, tileIds: [0, 1, 2]),
        ),
        GameAction.addToMeld(meldId: 42, tileId: 0),
        GameAction.replaceJoker(meldId: 42, index: 0, tileId: 0),
        GameAction.startNextHand(),
      ];
      for (final action in actions) {
        final result = GameEngine.apply(state, action);
        expect(result, isA<EngineErr>(), reason: '$action should be rejected');
        expect(result.errorOrNull, isNotNull);
        expect(result.stateOrNull, isNull);
      }
    });

    test('nothing is legal once the match is over', () {
      final state = buildState(
        indicator: indicator,
        hands: hands(const [], size0: 21),
        phase: TurnPhase.matchOver,
      );
      expect(
        errorOf(GameEngine.apply(state, const GameAction.drawFromPile())),
        const GameError.matchAlreadyOver(),
      );
    });
  });
}
