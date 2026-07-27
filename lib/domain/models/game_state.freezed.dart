// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerState {

 int get seat; String get name; bool get isHuman;/// Canonical order: sorted by tile id. Rack presentation order is UI state
/// and is deliberately kept out of the engine.
 List<Tile> get hand;/// Last element is the top of the pile.
 List<Tile> get discards; bool get hasOpened; bool get openedWithPairs;/// Zero-based order in which this player opened during the current hand,
/// or -1 if they have not opened. Drives the escalating-threshold variant.
 int get openOrder;/// Cumulative match score. Lowest wins.
 int get score;
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStateCopyWith<PlayerState> get copyWith => _$PlayerStateCopyWithImpl<PlayerState>(this as PlayerState, _$identity);

  /// Serializes this PlayerState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerState&&(identical(other.seat, seat) || other.seat == seat)&&(identical(other.name, name) || other.name == name)&&(identical(other.isHuman, isHuman) || other.isHuman == isHuman)&&const DeepCollectionEquality().equals(other.hand, hand)&&const DeepCollectionEquality().equals(other.discards, discards)&&(identical(other.hasOpened, hasOpened) || other.hasOpened == hasOpened)&&(identical(other.openedWithPairs, openedWithPairs) || other.openedWithPairs == openedWithPairs)&&(identical(other.openOrder, openOrder) || other.openOrder == openOrder)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seat,name,isHuman,const DeepCollectionEquality().hash(hand),const DeepCollectionEquality().hash(discards),hasOpened,openedWithPairs,openOrder,score);

@override
String toString() {
  return 'PlayerState(seat: $seat, name: $name, isHuman: $isHuman, hand: $hand, discards: $discards, hasOpened: $hasOpened, openedWithPairs: $openedWithPairs, openOrder: $openOrder, score: $score)';
}


}

/// @nodoc
abstract mixin class $PlayerStateCopyWith<$Res>  {
  factory $PlayerStateCopyWith(PlayerState value, $Res Function(PlayerState) _then) = _$PlayerStateCopyWithImpl;
@useResult
$Res call({
 int seat, String name, bool isHuman, List<Tile> hand, List<Tile> discards, bool hasOpened, bool openedWithPairs, int openOrder, int score
});




}
/// @nodoc
class _$PlayerStateCopyWithImpl<$Res>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._self, this._then);

  final PlayerState _self;
  final $Res Function(PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seat = null,Object? name = null,Object? isHuman = null,Object? hand = null,Object? discards = null,Object? hasOpened = null,Object? openedWithPairs = null,Object? openOrder = null,Object? score = null,}) {
  return _then(_self.copyWith(
seat: null == seat ? _self.seat : seat // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isHuman: null == isHuman ? _self.isHuman : isHuman // ignore: cast_nullable_to_non_nullable
as bool,hand: null == hand ? _self.hand : hand // ignore: cast_nullable_to_non_nullable
as List<Tile>,discards: null == discards ? _self.discards : discards // ignore: cast_nullable_to_non_nullable
as List<Tile>,hasOpened: null == hasOpened ? _self.hasOpened : hasOpened // ignore: cast_nullable_to_non_nullable
as bool,openedWithPairs: null == openedWithPairs ? _self.openedWithPairs : openedWithPairs // ignore: cast_nullable_to_non_nullable
as bool,openOrder: null == openOrder ? _self.openOrder : openOrder // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerState].
extension PlayerStatePatterns on PlayerState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerState value)  $default,){
final _that = this;
switch (_that) {
case _PlayerState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seat,  String name,  bool isHuman,  List<Tile> hand,  List<Tile> discards,  bool hasOpened,  bool openedWithPairs,  int openOrder,  int score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.seat,_that.name,_that.isHuman,_that.hand,_that.discards,_that.hasOpened,_that.openedWithPairs,_that.openOrder,_that.score);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seat,  String name,  bool isHuman,  List<Tile> hand,  List<Tile> discards,  bool hasOpened,  bool openedWithPairs,  int openOrder,  int score)  $default,) {final _that = this;
switch (_that) {
case _PlayerState():
return $default(_that.seat,_that.name,_that.isHuman,_that.hand,_that.discards,_that.hasOpened,_that.openedWithPairs,_that.openOrder,_that.score);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seat,  String name,  bool isHuman,  List<Tile> hand,  List<Tile> discards,  bool hasOpened,  bool openedWithPairs,  int openOrder,  int score)?  $default,) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.seat,_that.name,_that.isHuman,_that.hand,_that.discards,_that.hasOpened,_that.openedWithPairs,_that.openOrder,_that.score);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerState extends PlayerState {
  const _PlayerState({required this.seat, required this.name, required this.isHuman, required final  List<Tile> hand, required final  List<Tile> discards, this.hasOpened = false, this.openedWithPairs = false, this.openOrder = -1, this.score = 0}): _hand = hand,_discards = discards,super._();
  factory _PlayerState.fromJson(Map<String, dynamic> json) => _$PlayerStateFromJson(json);

@override final  int seat;
@override final  String name;
@override final  bool isHuman;
/// Canonical order: sorted by tile id. Rack presentation order is UI state
/// and is deliberately kept out of the engine.
 final  List<Tile> _hand;
/// Canonical order: sorted by tile id. Rack presentation order is UI state
/// and is deliberately kept out of the engine.
@override List<Tile> get hand {
  if (_hand is EqualUnmodifiableListView) return _hand;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hand);
}

/// Last element is the top of the pile.
 final  List<Tile> _discards;
/// Last element is the top of the pile.
@override List<Tile> get discards {
  if (_discards is EqualUnmodifiableListView) return _discards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_discards);
}

@override@JsonKey() final  bool hasOpened;
@override@JsonKey() final  bool openedWithPairs;
/// Zero-based order in which this player opened during the current hand,
/// or -1 if they have not opened. Drives the escalating-threshold variant.
@override@JsonKey() final  int openOrder;
/// Cumulative match score. Lowest wins.
@override@JsonKey() final  int score;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStateCopyWith<_PlayerState> get copyWith => __$PlayerStateCopyWithImpl<_PlayerState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerState&&(identical(other.seat, seat) || other.seat == seat)&&(identical(other.name, name) || other.name == name)&&(identical(other.isHuman, isHuman) || other.isHuman == isHuman)&&const DeepCollectionEquality().equals(other._hand, _hand)&&const DeepCollectionEquality().equals(other._discards, _discards)&&(identical(other.hasOpened, hasOpened) || other.hasOpened == hasOpened)&&(identical(other.openedWithPairs, openedWithPairs) || other.openedWithPairs == openedWithPairs)&&(identical(other.openOrder, openOrder) || other.openOrder == openOrder)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seat,name,isHuman,const DeepCollectionEquality().hash(_hand),const DeepCollectionEquality().hash(_discards),hasOpened,openedWithPairs,openOrder,score);

@override
String toString() {
  return 'PlayerState(seat: $seat, name: $name, isHuman: $isHuman, hand: $hand, discards: $discards, hasOpened: $hasOpened, openedWithPairs: $openedWithPairs, openOrder: $openOrder, score: $score)';
}


}

/// @nodoc
abstract mixin class _$PlayerStateCopyWith<$Res> implements $PlayerStateCopyWith<$Res> {
  factory _$PlayerStateCopyWith(_PlayerState value, $Res Function(_PlayerState) _then) = __$PlayerStateCopyWithImpl;
@override @useResult
$Res call({
 int seat, String name, bool isHuman, List<Tile> hand, List<Tile> discards, bool hasOpened, bool openedWithPairs, int openOrder, int score
});




}
/// @nodoc
class __$PlayerStateCopyWithImpl<$Res>
    implements _$PlayerStateCopyWith<$Res> {
  __$PlayerStateCopyWithImpl(this._self, this._then);

  final _PlayerState _self;
  final $Res Function(_PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seat = null,Object? name = null,Object? isHuman = null,Object? hand = null,Object? discards = null,Object? hasOpened = null,Object? openedWithPairs = null,Object? openOrder = null,Object? score = null,}) {
  return _then(_PlayerState(
seat: null == seat ? _self.seat : seat // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isHuman: null == isHuman ? _self.isHuman : isHuman // ignore: cast_nullable_to_non_nullable
as bool,hand: null == hand ? _self._hand : hand // ignore: cast_nullable_to_non_nullable
as List<Tile>,discards: null == discards ? _self._discards : discards // ignore: cast_nullable_to_non_nullable
as List<Tile>,hasOpened: null == hasOpened ? _self.hasOpened : hasOpened // ignore: cast_nullable_to_non_nullable
as bool,openedWithPairs: null == openedWithPairs ? _self.openedWithPairs : openedWithPairs // ignore: cast_nullable_to_non_nullable
as bool,openOrder: null == openOrder ? _self.openOrder : openOrder // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$GameState {

 RuleSet get ruleSet;/// Match seed. `(seed, canonicalActions)` reproduces the whole match.
 int get seed;/// Live xorshift32 state, carried in the state so the engine stays a pure
/// function with no ambient randomness.
 int get randomState;/// 1-based.
 int get handNumber; int get startingSeat; Tile get indicator;/// The wild tile's identity: indicator + 1, same colour, wrapping 13 -> 1.
 TileIdentity get okey;/// Face-down pile; last element is the top. Exactly 20 tiles after the deal.
 List<Tile> get drawPile; List<PlayerState> get players; List<Meld> get table; int get currentSeat; TurnPhase get phase;/// Set when the current player drew from a discard pile this turn. That
/// tile may not be discarded back on the same turn.
 int? get takenFromDiscardTileId;/// True when the current player opened during THIS turn. Needed to tell a
/// "kafa" finish from a normal one.
 bool get openedThisTurn;/// Monotonic id source for melds laid on the table.
 int get nextMeldId;/// How many players have opened so far in this hand. Resets every hand and
/// drives the escalating threshold.
 int get openedCount;/// Set when [phase] is [TurnPhase.handOver] or [TurnPhase.matchOver].
 HandResult? get handResult; List<HandResult> get history;
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateCopyWith<GameState> get copyWith => _$GameStateCopyWithImpl<GameState>(this as GameState, _$identity);

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&(identical(other.ruleSet, ruleSet) || other.ruleSet == ruleSet)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.randomState, randomState) || other.randomState == randomState)&&(identical(other.handNumber, handNumber) || other.handNumber == handNumber)&&(identical(other.startingSeat, startingSeat) || other.startingSeat == startingSeat)&&(identical(other.indicator, indicator) || other.indicator == indicator)&&(identical(other.okey, okey) || other.okey == okey)&&const DeepCollectionEquality().equals(other.drawPile, drawPile)&&const DeepCollectionEquality().equals(other.players, players)&&const DeepCollectionEquality().equals(other.table, table)&&(identical(other.currentSeat, currentSeat) || other.currentSeat == currentSeat)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.takenFromDiscardTileId, takenFromDiscardTileId) || other.takenFromDiscardTileId == takenFromDiscardTileId)&&(identical(other.openedThisTurn, openedThisTurn) || other.openedThisTurn == openedThisTurn)&&(identical(other.nextMeldId, nextMeldId) || other.nextMeldId == nextMeldId)&&(identical(other.openedCount, openedCount) || other.openedCount == openedCount)&&(identical(other.handResult, handResult) || other.handResult == handResult)&&const DeepCollectionEquality().equals(other.history, history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ruleSet,seed,randomState,handNumber,startingSeat,indicator,okey,const DeepCollectionEquality().hash(drawPile),const DeepCollectionEquality().hash(players),const DeepCollectionEquality().hash(table),currentSeat,phase,takenFromDiscardTileId,openedThisTurn,nextMeldId,openedCount,handResult,const DeepCollectionEquality().hash(history));

@override
String toString() {
  return 'GameState(ruleSet: $ruleSet, seed: $seed, randomState: $randomState, handNumber: $handNumber, startingSeat: $startingSeat, indicator: $indicator, okey: $okey, drawPile: $drawPile, players: $players, table: $table, currentSeat: $currentSeat, phase: $phase, takenFromDiscardTileId: $takenFromDiscardTileId, openedThisTurn: $openedThisTurn, nextMeldId: $nextMeldId, openedCount: $openedCount, handResult: $handResult, history: $history)';
}


}

/// @nodoc
abstract mixin class $GameStateCopyWith<$Res>  {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) _then) = _$GameStateCopyWithImpl;
@useResult
$Res call({
 RuleSet ruleSet, int seed, int randomState, int handNumber, int startingSeat, Tile indicator, TileIdentity okey, List<Tile> drawPile, List<PlayerState> players, List<Meld> table, int currentSeat, TurnPhase phase, int? takenFromDiscardTileId, bool openedThisTurn, int nextMeldId, int openedCount, HandResult? handResult, List<HandResult> history
});


$RuleSetCopyWith<$Res> get ruleSet;$TileCopyWith<$Res> get indicator;$TileIdentityCopyWith<$Res> get okey;$HandResultCopyWith<$Res>? get handResult;

}
/// @nodoc
class _$GameStateCopyWithImpl<$Res>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._self, this._then);

  final GameState _self;
  final $Res Function(GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ruleSet = null,Object? seed = null,Object? randomState = null,Object? handNumber = null,Object? startingSeat = null,Object? indicator = null,Object? okey = null,Object? drawPile = null,Object? players = null,Object? table = null,Object? currentSeat = null,Object? phase = null,Object? takenFromDiscardTileId = freezed,Object? openedThisTurn = null,Object? nextMeldId = null,Object? openedCount = null,Object? handResult = freezed,Object? history = null,}) {
  return _then(_self.copyWith(
ruleSet: null == ruleSet ? _self.ruleSet : ruleSet // ignore: cast_nullable_to_non_nullable
as RuleSet,seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,randomState: null == randomState ? _self.randomState : randomState // ignore: cast_nullable_to_non_nullable
as int,handNumber: null == handNumber ? _self.handNumber : handNumber // ignore: cast_nullable_to_non_nullable
as int,startingSeat: null == startingSeat ? _self.startingSeat : startingSeat // ignore: cast_nullable_to_non_nullable
as int,indicator: null == indicator ? _self.indicator : indicator // ignore: cast_nullable_to_non_nullable
as Tile,okey: null == okey ? _self.okey : okey // ignore: cast_nullable_to_non_nullable
as TileIdentity,drawPile: null == drawPile ? _self.drawPile : drawPile // ignore: cast_nullable_to_non_nullable
as List<Tile>,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<PlayerState>,table: null == table ? _self.table : table // ignore: cast_nullable_to_non_nullable
as List<Meld>,currentSeat: null == currentSeat ? _self.currentSeat : currentSeat // ignore: cast_nullable_to_non_nullable
as int,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as TurnPhase,takenFromDiscardTileId: freezed == takenFromDiscardTileId ? _self.takenFromDiscardTileId : takenFromDiscardTileId // ignore: cast_nullable_to_non_nullable
as int?,openedThisTurn: null == openedThisTurn ? _self.openedThisTurn : openedThisTurn // ignore: cast_nullable_to_non_nullable
as bool,nextMeldId: null == nextMeldId ? _self.nextMeldId : nextMeldId // ignore: cast_nullable_to_non_nullable
as int,openedCount: null == openedCount ? _self.openedCount : openedCount // ignore: cast_nullable_to_non_nullable
as int,handResult: freezed == handResult ? _self.handResult : handResult // ignore: cast_nullable_to_non_nullable
as HandResult?,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<HandResult>,
  ));
}
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RuleSetCopyWith<$Res> get ruleSet {
  
  return $RuleSetCopyWith<$Res>(_self.ruleSet, (value) {
    return _then(_self.copyWith(ruleSet: value));
  });
}/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TileCopyWith<$Res> get indicator {
  
  return $TileCopyWith<$Res>(_self.indicator, (value) {
    return _then(_self.copyWith(indicator: value));
  });
}/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TileIdentityCopyWith<$Res> get okey {
  
  return $TileIdentityCopyWith<$Res>(_self.okey, (value) {
    return _then(_self.copyWith(okey: value));
  });
}/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HandResultCopyWith<$Res>? get handResult {
    if (_self.handResult == null) {
    return null;
  }

  return $HandResultCopyWith<$Res>(_self.handResult!, (value) {
    return _then(_self.copyWith(handResult: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameState].
extension GameStatePatterns on GameState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameState value)  $default,){
final _that = this;
switch (_that) {
case _GameState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameState value)?  $default,){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RuleSet ruleSet,  int seed,  int randomState,  int handNumber,  int startingSeat,  Tile indicator,  TileIdentity okey,  List<Tile> drawPile,  List<PlayerState> players,  List<Meld> table,  int currentSeat,  TurnPhase phase,  int? takenFromDiscardTileId,  bool openedThisTurn,  int nextMeldId,  int openedCount,  HandResult? handResult,  List<HandResult> history)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.ruleSet,_that.seed,_that.randomState,_that.handNumber,_that.startingSeat,_that.indicator,_that.okey,_that.drawPile,_that.players,_that.table,_that.currentSeat,_that.phase,_that.takenFromDiscardTileId,_that.openedThisTurn,_that.nextMeldId,_that.openedCount,_that.handResult,_that.history);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RuleSet ruleSet,  int seed,  int randomState,  int handNumber,  int startingSeat,  Tile indicator,  TileIdentity okey,  List<Tile> drawPile,  List<PlayerState> players,  List<Meld> table,  int currentSeat,  TurnPhase phase,  int? takenFromDiscardTileId,  bool openedThisTurn,  int nextMeldId,  int openedCount,  HandResult? handResult,  List<HandResult> history)  $default,) {final _that = this;
switch (_that) {
case _GameState():
return $default(_that.ruleSet,_that.seed,_that.randomState,_that.handNumber,_that.startingSeat,_that.indicator,_that.okey,_that.drawPile,_that.players,_that.table,_that.currentSeat,_that.phase,_that.takenFromDiscardTileId,_that.openedThisTurn,_that.nextMeldId,_that.openedCount,_that.handResult,_that.history);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RuleSet ruleSet,  int seed,  int randomState,  int handNumber,  int startingSeat,  Tile indicator,  TileIdentity okey,  List<Tile> drawPile,  List<PlayerState> players,  List<Meld> table,  int currentSeat,  TurnPhase phase,  int? takenFromDiscardTileId,  bool openedThisTurn,  int nextMeldId,  int openedCount,  HandResult? handResult,  List<HandResult> history)?  $default,) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.ruleSet,_that.seed,_that.randomState,_that.handNumber,_that.startingSeat,_that.indicator,_that.okey,_that.drawPile,_that.players,_that.table,_that.currentSeat,_that.phase,_that.takenFromDiscardTileId,_that.openedThisTurn,_that.nextMeldId,_that.openedCount,_that.handResult,_that.history);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameState extends GameState {
  const _GameState({required this.ruleSet, required this.seed, required this.randomState, required this.handNumber, required this.startingSeat, required this.indicator, required this.okey, required final  List<Tile> drawPile, required final  List<PlayerState> players, required final  List<Meld> table, required this.currentSeat, required this.phase, this.takenFromDiscardTileId, this.openedThisTurn = false, this.nextMeldId = 0, this.openedCount = 0, this.handResult, final  List<HandResult> history = const <HandResult>[]}): _drawPile = drawPile,_players = players,_table = table,_history = history,super._();
  factory _GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);

@override final  RuleSet ruleSet;
/// Match seed. `(seed, canonicalActions)` reproduces the whole match.
@override final  int seed;
/// Live xorshift32 state, carried in the state so the engine stays a pure
/// function with no ambient randomness.
@override final  int randomState;
/// 1-based.
@override final  int handNumber;
@override final  int startingSeat;
@override final  Tile indicator;
/// The wild tile's identity: indicator + 1, same colour, wrapping 13 -> 1.
@override final  TileIdentity okey;
/// Face-down pile; last element is the top. Exactly 20 tiles after the deal.
 final  List<Tile> _drawPile;
/// Face-down pile; last element is the top. Exactly 20 tiles after the deal.
@override List<Tile> get drawPile {
  if (_drawPile is EqualUnmodifiableListView) return _drawPile;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_drawPile);
}

 final  List<PlayerState> _players;
@override List<PlayerState> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

 final  List<Meld> _table;
@override List<Meld> get table {
  if (_table is EqualUnmodifiableListView) return _table;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_table);
}

@override final  int currentSeat;
@override final  TurnPhase phase;
/// Set when the current player drew from a discard pile this turn. That
/// tile may not be discarded back on the same turn.
@override final  int? takenFromDiscardTileId;
/// True when the current player opened during THIS turn. Needed to tell a
/// "kafa" finish from a normal one.
@override@JsonKey() final  bool openedThisTurn;
/// Monotonic id source for melds laid on the table.
@override@JsonKey() final  int nextMeldId;
/// How many players have opened so far in this hand. Resets every hand and
/// drives the escalating threshold.
@override@JsonKey() final  int openedCount;
/// Set when [phase] is [TurnPhase.handOver] or [TurnPhase.matchOver].
@override final  HandResult? handResult;
 final  List<HandResult> _history;
@override@JsonKey() List<HandResult> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStateCopyWith<_GameState> get copyWith => __$GameStateCopyWithImpl<_GameState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameState&&(identical(other.ruleSet, ruleSet) || other.ruleSet == ruleSet)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.randomState, randomState) || other.randomState == randomState)&&(identical(other.handNumber, handNumber) || other.handNumber == handNumber)&&(identical(other.startingSeat, startingSeat) || other.startingSeat == startingSeat)&&(identical(other.indicator, indicator) || other.indicator == indicator)&&(identical(other.okey, okey) || other.okey == okey)&&const DeepCollectionEquality().equals(other._drawPile, _drawPile)&&const DeepCollectionEquality().equals(other._players, _players)&&const DeepCollectionEquality().equals(other._table, _table)&&(identical(other.currentSeat, currentSeat) || other.currentSeat == currentSeat)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.takenFromDiscardTileId, takenFromDiscardTileId) || other.takenFromDiscardTileId == takenFromDiscardTileId)&&(identical(other.openedThisTurn, openedThisTurn) || other.openedThisTurn == openedThisTurn)&&(identical(other.nextMeldId, nextMeldId) || other.nextMeldId == nextMeldId)&&(identical(other.openedCount, openedCount) || other.openedCount == openedCount)&&(identical(other.handResult, handResult) || other.handResult == handResult)&&const DeepCollectionEquality().equals(other._history, _history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ruleSet,seed,randomState,handNumber,startingSeat,indicator,okey,const DeepCollectionEquality().hash(_drawPile),const DeepCollectionEquality().hash(_players),const DeepCollectionEquality().hash(_table),currentSeat,phase,takenFromDiscardTileId,openedThisTurn,nextMeldId,openedCount,handResult,const DeepCollectionEquality().hash(_history));

@override
String toString() {
  return 'GameState(ruleSet: $ruleSet, seed: $seed, randomState: $randomState, handNumber: $handNumber, startingSeat: $startingSeat, indicator: $indicator, okey: $okey, drawPile: $drawPile, players: $players, table: $table, currentSeat: $currentSeat, phase: $phase, takenFromDiscardTileId: $takenFromDiscardTileId, openedThisTurn: $openedThisTurn, nextMeldId: $nextMeldId, openedCount: $openedCount, handResult: $handResult, history: $history)';
}


}

/// @nodoc
abstract mixin class _$GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$GameStateCopyWith(_GameState value, $Res Function(_GameState) _then) = __$GameStateCopyWithImpl;
@override @useResult
$Res call({
 RuleSet ruleSet, int seed, int randomState, int handNumber, int startingSeat, Tile indicator, TileIdentity okey, List<Tile> drawPile, List<PlayerState> players, List<Meld> table, int currentSeat, TurnPhase phase, int? takenFromDiscardTileId, bool openedThisTurn, int nextMeldId, int openedCount, HandResult? handResult, List<HandResult> history
});


@override $RuleSetCopyWith<$Res> get ruleSet;@override $TileCopyWith<$Res> get indicator;@override $TileIdentityCopyWith<$Res> get okey;@override $HandResultCopyWith<$Res>? get handResult;

}
/// @nodoc
class __$GameStateCopyWithImpl<$Res>
    implements _$GameStateCopyWith<$Res> {
  __$GameStateCopyWithImpl(this._self, this._then);

  final _GameState _self;
  final $Res Function(_GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ruleSet = null,Object? seed = null,Object? randomState = null,Object? handNumber = null,Object? startingSeat = null,Object? indicator = null,Object? okey = null,Object? drawPile = null,Object? players = null,Object? table = null,Object? currentSeat = null,Object? phase = null,Object? takenFromDiscardTileId = freezed,Object? openedThisTurn = null,Object? nextMeldId = null,Object? openedCount = null,Object? handResult = freezed,Object? history = null,}) {
  return _then(_GameState(
ruleSet: null == ruleSet ? _self.ruleSet : ruleSet // ignore: cast_nullable_to_non_nullable
as RuleSet,seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,randomState: null == randomState ? _self.randomState : randomState // ignore: cast_nullable_to_non_nullable
as int,handNumber: null == handNumber ? _self.handNumber : handNumber // ignore: cast_nullable_to_non_nullable
as int,startingSeat: null == startingSeat ? _self.startingSeat : startingSeat // ignore: cast_nullable_to_non_nullable
as int,indicator: null == indicator ? _self.indicator : indicator // ignore: cast_nullable_to_non_nullable
as Tile,okey: null == okey ? _self.okey : okey // ignore: cast_nullable_to_non_nullable
as TileIdentity,drawPile: null == drawPile ? _self._drawPile : drawPile // ignore: cast_nullable_to_non_nullable
as List<Tile>,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<PlayerState>,table: null == table ? _self._table : table // ignore: cast_nullable_to_non_nullable
as List<Meld>,currentSeat: null == currentSeat ? _self.currentSeat : currentSeat // ignore: cast_nullable_to_non_nullable
as int,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as TurnPhase,takenFromDiscardTileId: freezed == takenFromDiscardTileId ? _self.takenFromDiscardTileId : takenFromDiscardTileId // ignore: cast_nullable_to_non_nullable
as int?,openedThisTurn: null == openedThisTurn ? _self.openedThisTurn : openedThisTurn // ignore: cast_nullable_to_non_nullable
as bool,nextMeldId: null == nextMeldId ? _self.nextMeldId : nextMeldId // ignore: cast_nullable_to_non_nullable
as int,openedCount: null == openedCount ? _self.openedCount : openedCount // ignore: cast_nullable_to_non_nullable
as int,handResult: freezed == handResult ? _self.handResult : handResult // ignore: cast_nullable_to_non_nullable
as HandResult?,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<HandResult>,
  ));
}

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RuleSetCopyWith<$Res> get ruleSet {
  
  return $RuleSetCopyWith<$Res>(_self.ruleSet, (value) {
    return _then(_self.copyWith(ruleSet: value));
  });
}/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TileCopyWith<$Res> get indicator {
  
  return $TileCopyWith<$Res>(_self.indicator, (value) {
    return _then(_self.copyWith(indicator: value));
  });
}/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TileIdentityCopyWith<$Res> get okey {
  
  return $TileIdentityCopyWith<$Res>(_self.okey, (value) {
    return _then(_self.copyWith(okey: value));
  });
}/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HandResultCopyWith<$Res>? get handResult {
    if (_self.handResult == null) {
    return null;
  }

  return $HandResultCopyWith<$Res>(_self.handResult!, (value) {
    return _then(_self.copyWith(handResult: value));
  });
}
}

// dart format on
