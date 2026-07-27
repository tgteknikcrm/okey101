import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/tile.dart';

part 'player_view.freezed.dart';
part 'player_view.g.dart';

/// What one player can see of another: never their rack.
@freezed
abstract class OpponentView with _$OpponentView {
  const OpponentView._();

  const factory OpponentView({
    required int seat,
    required String name,

    /// How many tiles they hold - not which ones.
    required int tileCount,
    required bool hasOpened,
    required bool openedWithPairs,
    required int score,

    /// Face-up and therefore public. Last element is the top of the pile.
    required List<Tile> discards,
  }) = _OpponentView;

  factory OpponentView.fromJson(Map<String, dynamic> json) =>
      _$OpponentViewFromJson(json);

  Tile? get topDiscard => discards.isEmpty ? null : discards.last;
}

/// Everything a player at the table can legitimately see, and nothing else.
///
/// Bots receive one of these and never the full engine state. There is
/// deliberately no field anywhere in this type that can reach another player's
/// rack or the contents of the draw pile - only its count.
/// `test/domain/player_view_test.dart` proves that at the type level, which is
/// also why the name of the full state type appears nowhere in this file.
@freezed
abstract class PlayerView with _$PlayerView {
  const PlayerView._();

  const factory PlayerView({
    required RuleSet ruleSet,
    required int seat,
    required String name,

    /// The viewer's own rack, in canonical order.
    required List<Tile> hand,

    /// Face up on the stack, public.
    required Tile indicator,
    required TileIdentity okey,

    /// Count only. The tiles themselves are hidden.
    required int drawPileCount,
    required List<Meld> table,

    /// The three other seats, in turn order starting from the viewer's right.
    required List<OpponentView> opponents,

    /// The viewer's own discard pile. Last element is the top.
    required List<Tile> ownDiscards,
    required TurnPhase phase,
    required bool hasOpened,
    required bool openedWithPairs,

    /// How many players have already opened this hand; drives the escalating
    /// threshold variant.
    required int openedCount,
    required int handNumber,
    required int score,

    /// Set when this player took a tile from a discard pile this turn: it may
    /// not be discarded back on the same turn.
    int? takenFromDiscardTileId,
  }) = _PlayerView;

  factory PlayerView.fromJson(Map<String, dynamic> json) =>
      _$PlayerViewFromJson(json);

  /// The neighbour whose discard pile this player may draw from.
  OpponentView get leftNeighbour =>
      opponents.firstWhere((o) => o.seat == seatToLeftOf(seat));

  /// The neighbour who receives this player's discards.
  OpponentView get rightNeighbour =>
      opponents.firstWhere((o) => o.seat == seatToRightOf(seat));

  OpponentView opponentAt(int seat) =>
      opponents.firstWhere((o) => o.seat == seat);
}
