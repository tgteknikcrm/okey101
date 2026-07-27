import 'package:okey101/domain/models/game_error.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/tile.dart';

/// The rack has two rows of thirteen slots, like the physical istaka.
const int kRackRows = 2;
const int kRackColumns = 13;
const int kRackSlots = kRackRows * kRackColumns;

/// Everything the game screen needs: the engine state plus the presentation
/// state that sits on top of it.
///
/// Rack order, selection and the pending lay-down are all UI concerns. They are
/// saved with the game so a restored hand looks the way it was left, but they
/// are not part of the replay log.
class GameSession {
  const GameSession({
    required this.state,
    required this.rackSlots,
    this.selection = const <int>{},
    this.pendingMelds = const <MeldProposal>[],
    this.turnStartState,
    this.turnStartRack,
    this.lastError,
    this.botThinking = false,
    this.humanSeat = 0,
  });

  final GameState state;

  /// [kRackSlots] entries, each a tile id or null.
  final List<int?> rackSlots;
  final Set<int> selection;

  /// Melds staged for a single opening lay-down. Empty once opened.
  final List<MeldProposal> pendingMelds;

  /// Snapshot taken when the human's turn began, so table placements made this
  /// turn can be undone before the discard commits them.
  final GameState? turnStartState;
  final List<int?>? turnStartRack;

  final GameError? lastError;
  final bool botThinking;
  final int humanSeat;

  PlayerState get human => state.players[humanSeat];

  bool get isHumanTurn =>
      state.currentSeat == humanSeat && !state.isHandOver && !botThinking;

  bool get canUndo =>
      turnStartState != null &&
      isHumanTurn &&
      (state.table.length != turnStartState!.table.length ||
          human.hand.length != turnStartState!.players[humanSeat].hand.length ||
          pendingMelds.isNotEmpty);

  /// Tiles in rack order, skipping empty slots.
  List<Tile> get orderedHand {
    final byId = <int, Tile>{for (final tile in human.hand) tile.id: tile};
    return <Tile>[
      for (final id in rackSlots)
        if (id != null && byId.containsKey(id)) byId[id]!,
    ];
  }

  Tile? tileAtSlot(int slot) {
    if (slot < 0 || slot >= rackSlots.length) return null;
    final id = rackSlots[slot];
    if (id == null) return null;
    for (final tile in human.hand) {
      if (tile.id == id) return tile;
    }
    return null;
  }

  GameSession copyWith({
    GameState? state,
    List<int?>? rackSlots,
    Set<int>? selection,
    List<MeldProposal>? pendingMelds,
    GameState? turnStartState,
    List<int?>? turnStartRack,
    GameError? lastError,
    bool clearLastError = false,
    bool? botThinking,
    int? humanSeat,
  }) =>
      GameSession(
        state: state ?? this.state,
        rackSlots: rackSlots ?? this.rackSlots,
        selection: selection ?? this.selection,
        pendingMelds: pendingMelds ?? this.pendingMelds,
        turnStartState: turnStartState ?? this.turnStartState,
        turnStartRack: turnStartRack ?? this.turnStartRack,
        lastError: clearLastError ? null : (lastError ?? this.lastError),
        botThinking: botThinking ?? this.botThinking,
        humanSeat: humanSeat ?? this.humanSeat,
      );
}

/// Pure helpers for the rack layout. No engine state is touched here - the
/// engine keeps the hand in canonical id order and never learns about slots.
abstract final class RackLayout {
  static List<int?> empty() => List<int?>.filled(kRackSlots, null);

  /// Places [tiles] left to right from slot zero.
  static List<int?> fromTiles(List<Tile> tiles) {
    final slots = empty();
    for (var i = 0; i < tiles.length && i < kRackSlots; i++) {
      slots[i] = tiles[i].id;
    }
    return slots;
  }

  /// Keeps the player's arrangement while reconciling it with the real hand:
  /// tiles that left the hand free their slot, tiles that arrived take the
  /// first free one.
  static List<int?> reconcile(List<int?> slots, List<Tile> hand) {
    final handIds = hand.map((t) => t.id).toSet();
    final next = <int?>[
      for (final id in slots)
        if (id != null && handIds.contains(id)) id else null,
    ];
    while (next.length < kRackSlots) {
      next.add(null);
    }

    final placed = next.whereType<int>().toSet();
    for (final tile in hand) {
      if (placed.contains(tile.id)) continue;
      final free = next.indexOf(null);
      if (free < 0) break;
      next[free] = tile.id;
      placed.add(tile.id);
    }
    return next;
  }

  /// Moves the tile in [from] to [to], sliding the tiles in between along.
  ///
  /// Dropping onto an empty slot just relocates the tile; dropping onto an
  /// occupied one inserts before it, which is what makes reordering feel right.
  static List<int?> move(List<int?> slots, int from, int to) {
    if (from == to || from < 0 || to < 0) return slots;
    if (from >= slots.length || to >= slots.length) return slots;
    final next = List<int?>.of(slots);
    final moving = next[from];
    if (moving == null) return slots;

    if (next[to] == null) {
      next[from] = null;
      next[to] = moving;
      return next;
    }

    next[from] = null;
    if (to > from) {
      // Shift left into the hole, then drop in at the target.
      for (var i = from; i < to; i++) {
        next[i] = next[i + 1];
      }
      next[to] = moving;
    } else {
      for (var i = from; i > to; i--) {
        next[i] = next[i - 1];
      }
      next[to] = moving;
    }
    return next;
  }

  /// "Sirala" mode one: colour, then number. Groups a hand into runs.
  static List<int?> sortForRuns(List<Tile> hand, TileIdentity indicator) {
    final sorted = List<Tile>.of(hand)
      ..sort((a, b) {
        final ai = a.printedIdentity ?? indicator;
        final bi = b.printedIdentity ?? indicator;
        final byColor = ai.color.index.compareTo(bi.color.index);
        if (byColor != 0) return byColor;
        final byNumber = ai.number.compareTo(bi.number);
        if (byNumber != 0) return byNumber;
        return a.id.compareTo(b.id);
      });
    return _packWithBreaks(
      sorted,
      indicator,
      (previous, current) => previous.color != current.color,
    );
  }

  /// "Sirala" mode two: number, then colour. Groups a hand into sets.
  static List<int?> sortForSets(List<Tile> hand, TileIdentity indicator) {
    final sorted = List<Tile>.of(hand)
      ..sort((a, b) {
        final ai = a.printedIdentity ?? indicator;
        final bi = b.printedIdentity ?? indicator;
        final byNumber = ai.number.compareTo(bi.number);
        if (byNumber != 0) return byNumber;
        final byColor = ai.color.index.compareTo(bi.color.index);
        if (byColor != 0) return byColor;
        return a.id.compareTo(b.id);
      });
    return _packWithBreaks(
      sorted,
      indicator,
      (previous, current) => previous.number != current.number,
    );
  }

  /// Lays tiles out leaving a one-slot gap between groups where the rack has
  /// room for it, which is exactly what a player does by hand.
  static List<int?> _packWithBreaks(
    List<Tile> sorted,
    TileIdentity indicator,
    bool Function(TileIdentity previous, TileIdentity current) isBreak,
  ) {
    final spare = kRackSlots - sorted.length;
    var gapsLeft = spare;
    final slots = empty();
    var cursor = 0;
    TileIdentity? previous;

    for (final tile in sorted) {
      final identity = tile.printedIdentity ?? indicator;
      if (previous != null && isBreak(previous, identity) && gapsLeft > 0) {
        // Never let a gap push the group past the end of the rack.
        if (cursor + 1 < kRackSlots) {
          cursor++;
          gapsLeft--;
        }
      }
      if (cursor >= kRackSlots) break;
      slots[cursor] = tile.id;
      cursor++;
      previous = identity;
    }
    return slots;
  }
}
