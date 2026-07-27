// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OpponentView {

 int get seat; String get name;/// How many tiles they hold - not which ones.
 int get tileCount; bool get hasOpened; bool get openedWithPairs; int get score;/// Face-up and therefore public. Last element is the top of the pile.
 List<Tile> get discards;
/// Create a copy of OpponentView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpponentViewCopyWith<OpponentView> get copyWith => _$OpponentViewCopyWithImpl<OpponentView>(this as OpponentView, _$identity);

  /// Serializes this OpponentView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpponentView&&(identical(other.seat, seat) || other.seat == seat)&&(identical(other.name, name) || other.name == name)&&(identical(other.tileCount, tileCount) || other.tileCount == tileCount)&&(identical(other.hasOpened, hasOpened) || other.hasOpened == hasOpened)&&(identical(other.openedWithPairs, openedWithPairs) || other.openedWithPairs == openedWithPairs)&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other.discards, discards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seat,name,tileCount,hasOpened,openedWithPairs,score,const DeepCollectionEquality().hash(discards));

@override
String toString() {
  return 'OpponentView(seat: $seat, name: $name, tileCount: $tileCount, hasOpened: $hasOpened, openedWithPairs: $openedWithPairs, score: $score, discards: $discards)';
}


}

/// @nodoc
abstract mixin class $OpponentViewCopyWith<$Res>  {
  factory $OpponentViewCopyWith(OpponentView value, $Res Function(OpponentView) _then) = _$OpponentViewCopyWithImpl;
@useResult
$Res call({
 int seat, String name, int tileCount, bool hasOpened, bool openedWithPairs, int score, List<Tile> discards
});




}
/// @nodoc
class _$OpponentViewCopyWithImpl<$Res>
    implements $OpponentViewCopyWith<$Res> {
  _$OpponentViewCopyWithImpl(this._self, this._then);

  final OpponentView _self;
  final $Res Function(OpponentView) _then;

/// Create a copy of OpponentView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seat = null,Object? name = null,Object? tileCount = null,Object? hasOpened = null,Object? openedWithPairs = null,Object? score = null,Object? discards = null,}) {
  return _then(_self.copyWith(
seat: null == seat ? _self.seat : seat // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tileCount: null == tileCount ? _self.tileCount : tileCount // ignore: cast_nullable_to_non_nullable
as int,hasOpened: null == hasOpened ? _self.hasOpened : hasOpened // ignore: cast_nullable_to_non_nullable
as bool,openedWithPairs: null == openedWithPairs ? _self.openedWithPairs : openedWithPairs // ignore: cast_nullable_to_non_nullable
as bool,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,discards: null == discards ? _self.discards : discards // ignore: cast_nullable_to_non_nullable
as List<Tile>,
  ));
}

}


/// Adds pattern-matching-related methods to [OpponentView].
extension OpponentViewPatterns on OpponentView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpponentView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpponentView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpponentView value)  $default,){
final _that = this;
switch (_that) {
case _OpponentView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpponentView value)?  $default,){
final _that = this;
switch (_that) {
case _OpponentView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seat,  String name,  int tileCount,  bool hasOpened,  bool openedWithPairs,  int score,  List<Tile> discards)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpponentView() when $default != null:
return $default(_that.seat,_that.name,_that.tileCount,_that.hasOpened,_that.openedWithPairs,_that.score,_that.discards);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seat,  String name,  int tileCount,  bool hasOpened,  bool openedWithPairs,  int score,  List<Tile> discards)  $default,) {final _that = this;
switch (_that) {
case _OpponentView():
return $default(_that.seat,_that.name,_that.tileCount,_that.hasOpened,_that.openedWithPairs,_that.score,_that.discards);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seat,  String name,  int tileCount,  bool hasOpened,  bool openedWithPairs,  int score,  List<Tile> discards)?  $default,) {final _that = this;
switch (_that) {
case _OpponentView() when $default != null:
return $default(_that.seat,_that.name,_that.tileCount,_that.hasOpened,_that.openedWithPairs,_that.score,_that.discards);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpponentView extends OpponentView {
  const _OpponentView({required this.seat, required this.name, required this.tileCount, required this.hasOpened, required this.openedWithPairs, required this.score, required final  List<Tile> discards}): _discards = discards,super._();
  factory _OpponentView.fromJson(Map<String, dynamic> json) => _$OpponentViewFromJson(json);

@override final  int seat;
@override final  String name;
/// How many tiles they hold - not which ones.
@override final  int tileCount;
@override final  bool hasOpened;
@override final  bool openedWithPairs;
@override final  int score;
/// Face-up and therefore public. Last element is the top of the pile.
 final  List<Tile> _discards;
/// Face-up and therefore public. Last element is the top of the pile.
@override List<Tile> get discards {
  if (_discards is EqualUnmodifiableListView) return _discards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_discards);
}


/// Create a copy of OpponentView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpponentViewCopyWith<_OpponentView> get copyWith => __$OpponentViewCopyWithImpl<_OpponentView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpponentViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpponentView&&(identical(other.seat, seat) || other.seat == seat)&&(identical(other.name, name) || other.name == name)&&(identical(other.tileCount, tileCount) || other.tileCount == tileCount)&&(identical(other.hasOpened, hasOpened) || other.hasOpened == hasOpened)&&(identical(other.openedWithPairs, openedWithPairs) || other.openedWithPairs == openedWithPairs)&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other._discards, _discards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seat,name,tileCount,hasOpened,openedWithPairs,score,const DeepCollectionEquality().hash(_discards));

@override
String toString() {
  return 'OpponentView(seat: $seat, name: $name, tileCount: $tileCount, hasOpened: $hasOpened, openedWithPairs: $openedWithPairs, score: $score, discards: $discards)';
}


}

/// @nodoc
abstract mixin class _$OpponentViewCopyWith<$Res> implements $OpponentViewCopyWith<$Res> {
  factory _$OpponentViewCopyWith(_OpponentView value, $Res Function(_OpponentView) _then) = __$OpponentViewCopyWithImpl;
@override @useResult
$Res call({
 int seat, String name, int tileCount, bool hasOpened, bool openedWithPairs, int score, List<Tile> discards
});




}
/// @nodoc
class __$OpponentViewCopyWithImpl<$Res>
    implements _$OpponentViewCopyWith<$Res> {
  __$OpponentViewCopyWithImpl(this._self, this._then);

  final _OpponentView _self;
  final $Res Function(_OpponentView) _then;

/// Create a copy of OpponentView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seat = null,Object? name = null,Object? tileCount = null,Object? hasOpened = null,Object? openedWithPairs = null,Object? score = null,Object? discards = null,}) {
  return _then(_OpponentView(
seat: null == seat ? _self.seat : seat // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tileCount: null == tileCount ? _self.tileCount : tileCount // ignore: cast_nullable_to_non_nullable
as int,hasOpened: null == hasOpened ? _self.hasOpened : hasOpened // ignore: cast_nullable_to_non_nullable
as bool,openedWithPairs: null == openedWithPairs ? _self.openedWithPairs : openedWithPairs // ignore: cast_nullable_to_non_nullable
as bool,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,discards: null == discards ? _self._discards : discards // ignore: cast_nullable_to_non_nullable
as List<Tile>,
  ));
}


}


/// @nodoc
mixin _$PlayerView {

 RuleSet get ruleSet; int get seat; String get name;/// The viewer's own rack, in canonical order.
 List<Tile> get hand;/// Face up on the stack, public.
 Tile get indicator; TileIdentity get okey;/// Count only. The tiles themselves are hidden.
 int get drawPileCount; List<Meld> get table;/// The three other seats, in turn order starting from the viewer's right.
 List<OpponentView> get opponents;/// The viewer's own discard pile. Last element is the top.
 List<Tile> get ownDiscards; TurnPhase get phase; bool get hasOpened; bool get openedWithPairs;/// How many players have already opened this hand; drives the escalating
/// threshold variant.
 int get openedCount; int get handNumber; int get score;/// Set when this player took a tile from a discard pile this turn: it may
/// not be discarded back on the same turn.
 int? get takenFromDiscardTileId;
/// Create a copy of PlayerView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerViewCopyWith<PlayerView> get copyWith => _$PlayerViewCopyWithImpl<PlayerView>(this as PlayerView, _$identity);

  /// Serializes this PlayerView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerView&&(identical(other.ruleSet, ruleSet) || other.ruleSet == ruleSet)&&(identical(other.seat, seat) || other.seat == seat)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.hand, hand)&&(identical(other.indicator, indicator) || other.indicator == indicator)&&(identical(other.okey, okey) || other.okey == okey)&&(identical(other.drawPileCount, drawPileCount) || other.drawPileCount == drawPileCount)&&const DeepCollectionEquality().equals(other.table, table)&&const DeepCollectionEquality().equals(other.opponents, opponents)&&const DeepCollectionEquality().equals(other.ownDiscards, ownDiscards)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.hasOpened, hasOpened) || other.hasOpened == hasOpened)&&(identical(other.openedWithPairs, openedWithPairs) || other.openedWithPairs == openedWithPairs)&&(identical(other.openedCount, openedCount) || other.openedCount == openedCount)&&(identical(other.handNumber, handNumber) || other.handNumber == handNumber)&&(identical(other.score, score) || other.score == score)&&(identical(other.takenFromDiscardTileId, takenFromDiscardTileId) || other.takenFromDiscardTileId == takenFromDiscardTileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ruleSet,seat,name,const DeepCollectionEquality().hash(hand),indicator,okey,drawPileCount,const DeepCollectionEquality().hash(table),const DeepCollectionEquality().hash(opponents),const DeepCollectionEquality().hash(ownDiscards),phase,hasOpened,openedWithPairs,openedCount,handNumber,score,takenFromDiscardTileId);

@override
String toString() {
  return 'PlayerView(ruleSet: $ruleSet, seat: $seat, name: $name, hand: $hand, indicator: $indicator, okey: $okey, drawPileCount: $drawPileCount, table: $table, opponents: $opponents, ownDiscards: $ownDiscards, phase: $phase, hasOpened: $hasOpened, openedWithPairs: $openedWithPairs, openedCount: $openedCount, handNumber: $handNumber, score: $score, takenFromDiscardTileId: $takenFromDiscardTileId)';
}


}

/// @nodoc
abstract mixin class $PlayerViewCopyWith<$Res>  {
  factory $PlayerViewCopyWith(PlayerView value, $Res Function(PlayerView) _then) = _$PlayerViewCopyWithImpl;
@useResult
$Res call({
 RuleSet ruleSet, int seat, String name, List<Tile> hand, Tile indicator, TileIdentity okey, int drawPileCount, List<Meld> table, List<OpponentView> opponents, List<Tile> ownDiscards, TurnPhase phase, bool hasOpened, bool openedWithPairs, int openedCount, int handNumber, int score, int? takenFromDiscardTileId
});


$RuleSetCopyWith<$Res> get ruleSet;$TileCopyWith<$Res> get indicator;$TileIdentityCopyWith<$Res> get okey;

}
/// @nodoc
class _$PlayerViewCopyWithImpl<$Res>
    implements $PlayerViewCopyWith<$Res> {
  _$PlayerViewCopyWithImpl(this._self, this._then);

  final PlayerView _self;
  final $Res Function(PlayerView) _then;

/// Create a copy of PlayerView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ruleSet = null,Object? seat = null,Object? name = null,Object? hand = null,Object? indicator = null,Object? okey = null,Object? drawPileCount = null,Object? table = null,Object? opponents = null,Object? ownDiscards = null,Object? phase = null,Object? hasOpened = null,Object? openedWithPairs = null,Object? openedCount = null,Object? handNumber = null,Object? score = null,Object? takenFromDiscardTileId = freezed,}) {
  return _then(_self.copyWith(
ruleSet: null == ruleSet ? _self.ruleSet : ruleSet // ignore: cast_nullable_to_non_nullable
as RuleSet,seat: null == seat ? _self.seat : seat // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hand: null == hand ? _self.hand : hand // ignore: cast_nullable_to_non_nullable
as List<Tile>,indicator: null == indicator ? _self.indicator : indicator // ignore: cast_nullable_to_non_nullable
as Tile,okey: null == okey ? _self.okey : okey // ignore: cast_nullable_to_non_nullable
as TileIdentity,drawPileCount: null == drawPileCount ? _self.drawPileCount : drawPileCount // ignore: cast_nullable_to_non_nullable
as int,table: null == table ? _self.table : table // ignore: cast_nullable_to_non_nullable
as List<Meld>,opponents: null == opponents ? _self.opponents : opponents // ignore: cast_nullable_to_non_nullable
as List<OpponentView>,ownDiscards: null == ownDiscards ? _self.ownDiscards : ownDiscards // ignore: cast_nullable_to_non_nullable
as List<Tile>,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as TurnPhase,hasOpened: null == hasOpened ? _self.hasOpened : hasOpened // ignore: cast_nullable_to_non_nullable
as bool,openedWithPairs: null == openedWithPairs ? _self.openedWithPairs : openedWithPairs // ignore: cast_nullable_to_non_nullable
as bool,openedCount: null == openedCount ? _self.openedCount : openedCount // ignore: cast_nullable_to_non_nullable
as int,handNumber: null == handNumber ? _self.handNumber : handNumber // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,takenFromDiscardTileId: freezed == takenFromDiscardTileId ? _self.takenFromDiscardTileId : takenFromDiscardTileId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of PlayerView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RuleSetCopyWith<$Res> get ruleSet {
  
  return $RuleSetCopyWith<$Res>(_self.ruleSet, (value) {
    return _then(_self.copyWith(ruleSet: value));
  });
}/// Create a copy of PlayerView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TileCopyWith<$Res> get indicator {
  
  return $TileCopyWith<$Res>(_self.indicator, (value) {
    return _then(_self.copyWith(indicator: value));
  });
}/// Create a copy of PlayerView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TileIdentityCopyWith<$Res> get okey {
  
  return $TileIdentityCopyWith<$Res>(_self.okey, (value) {
    return _then(_self.copyWith(okey: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlayerView].
extension PlayerViewPatterns on PlayerView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerView value)  $default,){
final _that = this;
switch (_that) {
case _PlayerView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerView value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RuleSet ruleSet,  int seat,  String name,  List<Tile> hand,  Tile indicator,  TileIdentity okey,  int drawPileCount,  List<Meld> table,  List<OpponentView> opponents,  List<Tile> ownDiscards,  TurnPhase phase,  bool hasOpened,  bool openedWithPairs,  int openedCount,  int handNumber,  int score,  int? takenFromDiscardTileId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerView() when $default != null:
return $default(_that.ruleSet,_that.seat,_that.name,_that.hand,_that.indicator,_that.okey,_that.drawPileCount,_that.table,_that.opponents,_that.ownDiscards,_that.phase,_that.hasOpened,_that.openedWithPairs,_that.openedCount,_that.handNumber,_that.score,_that.takenFromDiscardTileId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RuleSet ruleSet,  int seat,  String name,  List<Tile> hand,  Tile indicator,  TileIdentity okey,  int drawPileCount,  List<Meld> table,  List<OpponentView> opponents,  List<Tile> ownDiscards,  TurnPhase phase,  bool hasOpened,  bool openedWithPairs,  int openedCount,  int handNumber,  int score,  int? takenFromDiscardTileId)  $default,) {final _that = this;
switch (_that) {
case _PlayerView():
return $default(_that.ruleSet,_that.seat,_that.name,_that.hand,_that.indicator,_that.okey,_that.drawPileCount,_that.table,_that.opponents,_that.ownDiscards,_that.phase,_that.hasOpened,_that.openedWithPairs,_that.openedCount,_that.handNumber,_that.score,_that.takenFromDiscardTileId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RuleSet ruleSet,  int seat,  String name,  List<Tile> hand,  Tile indicator,  TileIdentity okey,  int drawPileCount,  List<Meld> table,  List<OpponentView> opponents,  List<Tile> ownDiscards,  TurnPhase phase,  bool hasOpened,  bool openedWithPairs,  int openedCount,  int handNumber,  int score,  int? takenFromDiscardTileId)?  $default,) {final _that = this;
switch (_that) {
case _PlayerView() when $default != null:
return $default(_that.ruleSet,_that.seat,_that.name,_that.hand,_that.indicator,_that.okey,_that.drawPileCount,_that.table,_that.opponents,_that.ownDiscards,_that.phase,_that.hasOpened,_that.openedWithPairs,_that.openedCount,_that.handNumber,_that.score,_that.takenFromDiscardTileId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerView extends PlayerView {
  const _PlayerView({required this.ruleSet, required this.seat, required this.name, required final  List<Tile> hand, required this.indicator, required this.okey, required this.drawPileCount, required final  List<Meld> table, required final  List<OpponentView> opponents, required final  List<Tile> ownDiscards, required this.phase, required this.hasOpened, required this.openedWithPairs, required this.openedCount, required this.handNumber, required this.score, this.takenFromDiscardTileId}): _hand = hand,_table = table,_opponents = opponents,_ownDiscards = ownDiscards,super._();
  factory _PlayerView.fromJson(Map<String, dynamic> json) => _$PlayerViewFromJson(json);

@override final  RuleSet ruleSet;
@override final  int seat;
@override final  String name;
/// The viewer's own rack, in canonical order.
 final  List<Tile> _hand;
/// The viewer's own rack, in canonical order.
@override List<Tile> get hand {
  if (_hand is EqualUnmodifiableListView) return _hand;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hand);
}

/// Face up on the stack, public.
@override final  Tile indicator;
@override final  TileIdentity okey;
/// Count only. The tiles themselves are hidden.
@override final  int drawPileCount;
 final  List<Meld> _table;
@override List<Meld> get table {
  if (_table is EqualUnmodifiableListView) return _table;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_table);
}

/// The three other seats, in turn order starting from the viewer's right.
 final  List<OpponentView> _opponents;
/// The three other seats, in turn order starting from the viewer's right.
@override List<OpponentView> get opponents {
  if (_opponents is EqualUnmodifiableListView) return _opponents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_opponents);
}

/// The viewer's own discard pile. Last element is the top.
 final  List<Tile> _ownDiscards;
/// The viewer's own discard pile. Last element is the top.
@override List<Tile> get ownDiscards {
  if (_ownDiscards is EqualUnmodifiableListView) return _ownDiscards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ownDiscards);
}

@override final  TurnPhase phase;
@override final  bool hasOpened;
@override final  bool openedWithPairs;
/// How many players have already opened this hand; drives the escalating
/// threshold variant.
@override final  int openedCount;
@override final  int handNumber;
@override final  int score;
/// Set when this player took a tile from a discard pile this turn: it may
/// not be discarded back on the same turn.
@override final  int? takenFromDiscardTileId;

/// Create a copy of PlayerView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerViewCopyWith<_PlayerView> get copyWith => __$PlayerViewCopyWithImpl<_PlayerView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerView&&(identical(other.ruleSet, ruleSet) || other.ruleSet == ruleSet)&&(identical(other.seat, seat) || other.seat == seat)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._hand, _hand)&&(identical(other.indicator, indicator) || other.indicator == indicator)&&(identical(other.okey, okey) || other.okey == okey)&&(identical(other.drawPileCount, drawPileCount) || other.drawPileCount == drawPileCount)&&const DeepCollectionEquality().equals(other._table, _table)&&const DeepCollectionEquality().equals(other._opponents, _opponents)&&const DeepCollectionEquality().equals(other._ownDiscards, _ownDiscards)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.hasOpened, hasOpened) || other.hasOpened == hasOpened)&&(identical(other.openedWithPairs, openedWithPairs) || other.openedWithPairs == openedWithPairs)&&(identical(other.openedCount, openedCount) || other.openedCount == openedCount)&&(identical(other.handNumber, handNumber) || other.handNumber == handNumber)&&(identical(other.score, score) || other.score == score)&&(identical(other.takenFromDiscardTileId, takenFromDiscardTileId) || other.takenFromDiscardTileId == takenFromDiscardTileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ruleSet,seat,name,const DeepCollectionEquality().hash(_hand),indicator,okey,drawPileCount,const DeepCollectionEquality().hash(_table),const DeepCollectionEquality().hash(_opponents),const DeepCollectionEquality().hash(_ownDiscards),phase,hasOpened,openedWithPairs,openedCount,handNumber,score,takenFromDiscardTileId);

@override
String toString() {
  return 'PlayerView(ruleSet: $ruleSet, seat: $seat, name: $name, hand: $hand, indicator: $indicator, okey: $okey, drawPileCount: $drawPileCount, table: $table, opponents: $opponents, ownDiscards: $ownDiscards, phase: $phase, hasOpened: $hasOpened, openedWithPairs: $openedWithPairs, openedCount: $openedCount, handNumber: $handNumber, score: $score, takenFromDiscardTileId: $takenFromDiscardTileId)';
}


}

/// @nodoc
abstract mixin class _$PlayerViewCopyWith<$Res> implements $PlayerViewCopyWith<$Res> {
  factory _$PlayerViewCopyWith(_PlayerView value, $Res Function(_PlayerView) _then) = __$PlayerViewCopyWithImpl;
@override @useResult
$Res call({
 RuleSet ruleSet, int seat, String name, List<Tile> hand, Tile indicator, TileIdentity okey, int drawPileCount, List<Meld> table, List<OpponentView> opponents, List<Tile> ownDiscards, TurnPhase phase, bool hasOpened, bool openedWithPairs, int openedCount, int handNumber, int score, int? takenFromDiscardTileId
});


@override $RuleSetCopyWith<$Res> get ruleSet;@override $TileCopyWith<$Res> get indicator;@override $TileIdentityCopyWith<$Res> get okey;

}
/// @nodoc
class __$PlayerViewCopyWithImpl<$Res>
    implements _$PlayerViewCopyWith<$Res> {
  __$PlayerViewCopyWithImpl(this._self, this._then);

  final _PlayerView _self;
  final $Res Function(_PlayerView) _then;

/// Create a copy of PlayerView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ruleSet = null,Object? seat = null,Object? name = null,Object? hand = null,Object? indicator = null,Object? okey = null,Object? drawPileCount = null,Object? table = null,Object? opponents = null,Object? ownDiscards = null,Object? phase = null,Object? hasOpened = null,Object? openedWithPairs = null,Object? openedCount = null,Object? handNumber = null,Object? score = null,Object? takenFromDiscardTileId = freezed,}) {
  return _then(_PlayerView(
ruleSet: null == ruleSet ? _self.ruleSet : ruleSet // ignore: cast_nullable_to_non_nullable
as RuleSet,seat: null == seat ? _self.seat : seat // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hand: null == hand ? _self._hand : hand // ignore: cast_nullable_to_non_nullable
as List<Tile>,indicator: null == indicator ? _self.indicator : indicator // ignore: cast_nullable_to_non_nullable
as Tile,okey: null == okey ? _self.okey : okey // ignore: cast_nullable_to_non_nullable
as TileIdentity,drawPileCount: null == drawPileCount ? _self.drawPileCount : drawPileCount // ignore: cast_nullable_to_non_nullable
as int,table: null == table ? _self._table : table // ignore: cast_nullable_to_non_nullable
as List<Meld>,opponents: null == opponents ? _self._opponents : opponents // ignore: cast_nullable_to_non_nullable
as List<OpponentView>,ownDiscards: null == ownDiscards ? _self._ownDiscards : ownDiscards // ignore: cast_nullable_to_non_nullable
as List<Tile>,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as TurnPhase,hasOpened: null == hasOpened ? _self.hasOpened : hasOpened // ignore: cast_nullable_to_non_nullable
as bool,openedWithPairs: null == openedWithPairs ? _self.openedWithPairs : openedWithPairs // ignore: cast_nullable_to_non_nullable
as bool,openedCount: null == openedCount ? _self.openedCount : openedCount // ignore: cast_nullable_to_non_nullable
as int,handNumber: null == handNumber ? _self.handNumber : handNumber // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,takenFromDiscardTileId: freezed == takenFromDiscardTileId ? _self.takenFromDiscardTileId : takenFromDiscardTileId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of PlayerView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RuleSetCopyWith<$Res> get ruleSet {
  
  return $RuleSetCopyWith<$Res>(_self.ruleSet, (value) {
    return _then(_self.copyWith(ruleSet: value));
  });
}/// Create a copy of PlayerView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TileCopyWith<$Res> get indicator {
  
  return $TileCopyWith<$Res>(_self.indicator, (value) {
    return _then(_self.copyWith(indicator: value));
  });
}/// Create a copy of PlayerView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TileIdentityCopyWith<$Res> get okey {
  
  return $TileIdentityCopyWith<$Res>(_self.okey, (value) {
    return _then(_self.copyWith(okey: value));
  });
}
}

// dart format on
