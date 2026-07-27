import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:okey101/domain/models/hand_result.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/tile.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

/// Number of players at the table. Okey is always four-handed.
const int kSeatCount = 4;

/// Tiles dealt to a non-starting player.
const int kHandSize = 21;

/// Total tiles in a Turkish Okey set: 4 colours x 13 numbers x 2 copies, plus
/// 2 false jokers.
const int kTotalTiles = 106;

/// 106 - (3 x 21 + 22) - 1 indicator. Not approximate.
const int kDrawPileSize = 20;

/// Where the turn is.
enum TurnPhase {
  /// The player must draw exactly one tile.
  awaitingDraw,

  /// The player has drawn (or is the opening dealer) and must discard exactly
  /// one tile. Opening and adding to melds happen in this phase.
  awaitingDiscard,

  /// The hand ended; only `GameAction.startNextHand` is legal.
  handOver,

  /// The match ended; nothing further is legal.
  matchOver,
}

/// Turn order is counter-clockwise. The player *after* you sits on your right
/// and receives your discards.
int seatToRightOf(int seat) => (seat + 1) % kSeatCount;

/// The player *before* you sits on your left. Their discard pile is the one you
/// may draw from.
int seatToLeftOf(int seat) => (seat + kSeatCount - 1) % kSeatCount;

@freezed
abstract class PlayerState with _$PlayerState {
  const PlayerState._();

  const factory PlayerState({
    required int seat,
    required String name,
    required bool isHuman,

    /// Canonical order: sorted by tile id. Rack presentation order is UI state
    /// and is deliberately kept out of the engine.
    required List<Tile> hand,

    /// Last element is the top of the pile.
    required List<Tile> discards,
    @Default(false) bool hasOpened,
    @Default(false) bool openedWithPairs,

    /// Zero-based order in which this player opened during the current hand,
    /// or -1 if they have not opened. Drives the escalating-threshold variant.
    @Default(-1) int openOrder,

    /// Cumulative match score. Lowest wins.
    @Default(0) int score,
  }) = _PlayerState;

  factory PlayerState.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateFromJson(json);

  Tile? get topDiscard => discards.isEmpty ? null : discards.last;
}

@freezed
abstract class GameState with _$GameState {
  const GameState._();

  const factory GameState({
    required RuleSet ruleSet,

    /// Match seed. `(seed, canonicalActions)` reproduces the whole match.
    required int seed,

    /// Live xorshift32 state, carried in the state so the engine stays a pure
    /// function with no ambient randomness.
    required int randomState,

    /// 1-based.
    required int handNumber,
    required int startingSeat,
    required Tile indicator,

    /// The wild tile's identity: indicator + 1, same colour, wrapping 13 -> 1.
    required TileIdentity okey,

    /// Face-down pile; last element is the top. Exactly 20 tiles after the deal.
    required List<Tile> drawPile,
    required List<PlayerState> players,
    required List<Meld> table,
    required int currentSeat,
    required TurnPhase phase,

    /// Set when the current player drew from a discard pile this turn. That
    /// tile may not be discarded back on the same turn.
    int? takenFromDiscardTileId,

    /// True when the current player opened during THIS turn. Needed to tell a
    /// "kafa" finish from a normal one.
    @Default(false) bool openedThisTurn,

    /// Monotonic id source for melds laid on the table.
    @Default(0) int nextMeldId,

    /// How many players have opened so far in this hand. Resets every hand and
    /// drives the escalating threshold.
    @Default(0) int openedCount,

    /// Set when [phase] is [TurnPhase.handOver] or [TurnPhase.matchOver].
    HandResult? handResult,
    @Default(<HandResult>[]) List<HandResult> history,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  PlayerState get currentPlayer => players[currentSeat];

  PlayerState playerAt(int seat) => players[seat];

  /// The indicator's own identity, which is also what a false joker counts as.
  ///
  /// The `!` is safe: both [FalseJokerIndicatorPolicy] options guarantee the
  /// indicator is a numbered tile, so it always has a printed identity.
  TileIdentity get indicatorIdentity => indicator.printedIdentity!;

  bool get isHandOver =>
      phase == TurnPhase.handOver || phase == TurnPhase.matchOver;

  bool get isMatchOver => phase == TurnPhase.matchOver;

  /// Every tile currently accounted for anywhere. Used by the 106-tile
  /// invariant check after every action.
  List<Tile> allTiles() {
    final tiles = <Tile>[indicator, ...drawPile];
    for (final player in players) {
      tiles
        ..addAll(player.hand)
        ..addAll(player.discards);
    }
    for (final meld in table) {
      tiles.addAll(meld.tiles);
    }
    return tiles;
  }
}
