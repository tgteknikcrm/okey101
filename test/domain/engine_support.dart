import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/tile_deck.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

/// Builds a fully specified [GameState] for engine tests.
///
/// Every one of the 106 tiles has to be accounted for or the invariant check
/// fires, so whatever the caller does not place explicitly is parked: first
/// filling the draw pile up to [drawPileSize], then at the BOTTOM of the
/// discard piles, where it cannot affect play because only the top tile of a
/// pile is ever reachable.
GameState buildState({
  required Tile indicator,
  required List<List<Tile>> hands,
  List<List<Tile>> discards = const [<Tile>[], <Tile>[], <Tile>[], <Tile>[]],
  List<Meld> table = const <Meld>[],
  RuleSet rules = RulePresets.standard,
  int currentSeat = 0,
  TurnPhase phase = TurnPhase.awaitingDiscard,
  List<bool> opened = const [false, false, false, false],
  List<bool> openedWithPairs = const [false, false, false, false],
  List<int> scores = const [0, 0, 0, 0],
  List<int> openOrders = const [-1, -1, -1, -1],
  int drawPileSize = 20,
  int handNumber = 1,
  int startingSeat = 0,
  int openedCount = 0,
  bool openedThisTurn = false,
  int? takenFromDiscardTileId,
  int nextMeldId = 100,
  int seed = 1,
}) {
  final used = <int>{indicator.id};
  for (final hand in hands) {
    for (final tile in hand) {
      used.add(tile.id);
    }
  }
  for (final pile in discards) {
    for (final tile in pile) {
      used.add(tile.id);
    }
  }
  for (final meld in table) {
    for (final tile in meld.tiles) {
      used.add(tile.id);
    }
  }

  final spare = TileDeck.standard().where((t) => !used.contains(t.id)).toList();
  final pileCount = drawPileSize.clamp(0, spare.length);
  final drawPile = spare.sublist(0, pileCount);
  final overflow = spare.sublist(pileCount);

  final finalDiscards = <List<Tile>>[
    for (var seat = 0; seat < kSeatCount; seat++) <Tile>[],
  ];
  for (var i = 0; i < overflow.length; i++) {
    finalDiscards[i % kSeatCount].add(overflow[i]);
  }
  for (var seat = 0; seat < kSeatCount; seat++) {
    finalDiscards[seat].addAll(discards[seat]);
  }

  final indicatorIdentity = indicator.printedIdentity!;
  return GameState(
    ruleSet: rules,
    seed: seed,
    randomState: seed,
    handNumber: handNumber,
    startingSeat: startingSeat,
    indicator: indicator,
    okey: TileSemantics.okeyForIndicator(indicatorIdentity),
    drawPile: drawPile,
    players: <PlayerState>[
      for (var seat = 0; seat < kSeatCount; seat++)
        PlayerState(
          seat: seat,
          name: 'P$seat',
          isHuman: seat == 0,
          hand: List<Tile>.of(hands[seat])
            ..sort((a, b) => a.id.compareTo(b.id)),
          discards: finalDiscards[seat],
          hasOpened: opened[seat],
          openedWithPairs: openedWithPairs[seat],
          openOrder: openOrders[seat],
          score: scores[seat],
        ),
    ],
    table: table,
    currentSeat: currentSeat,
    phase: phase,
    takenFromDiscardTileId: takenFromDiscardTileId,
    openedThisTurn: openedThisTurn,
    nextMeldId: nextMeldId,
    openedCount: openedCount,
  );
}

/// Builds four hands, padding each [cores] entry out to its [sizes] entry with
/// filler tiles.
///
/// Fillers are allocated from a single pool, so no tile is ever handed to two
/// seats. [reserved] lists tiles the caller places elsewhere (on the table, in
/// a discard pile) so they are kept out of the pool as well. Filler tiles are
/// never the okey and never a false joker, so they cannot accidentally turn a
/// fixture into a wild-card case.
List<List<Tile>> buildHands({
  required Tile indicator,
  required TileIdentity okey,
  List<List<Tile>> cores = const [<Tile>[], <Tile>[], <Tile>[], <Tile>[]],
  List<int> sizes = const [21, 21, 21, 21],
  List<Tile> reserved = const <Tile>[],
}) {
  final taken = <int>{indicator.id, ...reserved.map((t) => t.id)};
  for (final core in cores) {
    for (final tile in core) {
      taken.add(tile.id);
    }
  }

  final pool = <Tile>[
    for (final tile in TileDeck.standard())
      if (!tile.isFalseJoker &&
          !taken.contains(tile.id) &&
          !(tile.color == okey.color && tile.number == okey.number))
        tile,
  ];

  var cursor = 0;
  return <List<Tile>>[
    for (var seat = 0; seat < kSeatCount; seat++)
      <Tile>[
        ...cores[seat],
        for (var i = cores[seat].length; i < sizes[seat]; i++) pool[cursor++],
      ],
  ];
}
