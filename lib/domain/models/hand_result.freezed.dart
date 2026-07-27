// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hand_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerHandResult {

 int get seat;/// Face value of the tiles left on the rack. Zero for the winner.
 int get deadwood; bool get hasOpened;/// Points written for this hand. Negative for the winner.
 int get delta;/// Cumulative score after this hand.
 int get total;
/// Create a copy of PlayerHandResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerHandResultCopyWith<PlayerHandResult> get copyWith => _$PlayerHandResultCopyWithImpl<PlayerHandResult>(this as PlayerHandResult, _$identity);

  /// Serializes this PlayerHandResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerHandResult&&(identical(other.seat, seat) || other.seat == seat)&&(identical(other.deadwood, deadwood) || other.deadwood == deadwood)&&(identical(other.hasOpened, hasOpened) || other.hasOpened == hasOpened)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seat,deadwood,hasOpened,delta,total);

@override
String toString() {
  return 'PlayerHandResult(seat: $seat, deadwood: $deadwood, hasOpened: $hasOpened, delta: $delta, total: $total)';
}


}

/// @nodoc
abstract mixin class $PlayerHandResultCopyWith<$Res>  {
  factory $PlayerHandResultCopyWith(PlayerHandResult value, $Res Function(PlayerHandResult) _then) = _$PlayerHandResultCopyWithImpl;
@useResult
$Res call({
 int seat, int deadwood, bool hasOpened, int delta, int total
});




}
/// @nodoc
class _$PlayerHandResultCopyWithImpl<$Res>
    implements $PlayerHandResultCopyWith<$Res> {
  _$PlayerHandResultCopyWithImpl(this._self, this._then);

  final PlayerHandResult _self;
  final $Res Function(PlayerHandResult) _then;

/// Create a copy of PlayerHandResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seat = null,Object? deadwood = null,Object? hasOpened = null,Object? delta = null,Object? total = null,}) {
  return _then(_self.copyWith(
seat: null == seat ? _self.seat : seat // ignore: cast_nullable_to_non_nullable
as int,deadwood: null == deadwood ? _self.deadwood : deadwood // ignore: cast_nullable_to_non_nullable
as int,hasOpened: null == hasOpened ? _self.hasOpened : hasOpened // ignore: cast_nullable_to_non_nullable
as bool,delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerHandResult].
extension PlayerHandResultPatterns on PlayerHandResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerHandResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerHandResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerHandResult value)  $default,){
final _that = this;
switch (_that) {
case _PlayerHandResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerHandResult value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerHandResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seat,  int deadwood,  bool hasOpened,  int delta,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerHandResult() when $default != null:
return $default(_that.seat,_that.deadwood,_that.hasOpened,_that.delta,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seat,  int deadwood,  bool hasOpened,  int delta,  int total)  $default,) {final _that = this;
switch (_that) {
case _PlayerHandResult():
return $default(_that.seat,_that.deadwood,_that.hasOpened,_that.delta,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seat,  int deadwood,  bool hasOpened,  int delta,  int total)?  $default,) {final _that = this;
switch (_that) {
case _PlayerHandResult() when $default != null:
return $default(_that.seat,_that.deadwood,_that.hasOpened,_that.delta,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerHandResult extends PlayerHandResult {
  const _PlayerHandResult({required this.seat, required this.deadwood, required this.hasOpened, required this.delta, required this.total}): super._();
  factory _PlayerHandResult.fromJson(Map<String, dynamic> json) => _$PlayerHandResultFromJson(json);

@override final  int seat;
/// Face value of the tiles left on the rack. Zero for the winner.
@override final  int deadwood;
@override final  bool hasOpened;
/// Points written for this hand. Negative for the winner.
@override final  int delta;
/// Cumulative score after this hand.
@override final  int total;

/// Create a copy of PlayerHandResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerHandResultCopyWith<_PlayerHandResult> get copyWith => __$PlayerHandResultCopyWithImpl<_PlayerHandResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerHandResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerHandResult&&(identical(other.seat, seat) || other.seat == seat)&&(identical(other.deadwood, deadwood) || other.deadwood == deadwood)&&(identical(other.hasOpened, hasOpened) || other.hasOpened == hasOpened)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seat,deadwood,hasOpened,delta,total);

@override
String toString() {
  return 'PlayerHandResult(seat: $seat, deadwood: $deadwood, hasOpened: $hasOpened, delta: $delta, total: $total)';
}


}

/// @nodoc
abstract mixin class _$PlayerHandResultCopyWith<$Res> implements $PlayerHandResultCopyWith<$Res> {
  factory _$PlayerHandResultCopyWith(_PlayerHandResult value, $Res Function(_PlayerHandResult) _then) = __$PlayerHandResultCopyWithImpl;
@override @useResult
$Res call({
 int seat, int deadwood, bool hasOpened, int delta, int total
});




}
/// @nodoc
class __$PlayerHandResultCopyWithImpl<$Res>
    implements _$PlayerHandResultCopyWith<$Res> {
  __$PlayerHandResultCopyWithImpl(this._self, this._then);

  final _PlayerHandResult _self;
  final $Res Function(_PlayerHandResult) _then;

/// Create a copy of PlayerHandResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seat = null,Object? deadwood = null,Object? hasOpened = null,Object? delta = null,Object? total = null,}) {
  return _then(_PlayerHandResult(
seat: null == seat ? _self.seat : seat // ignore: cast_nullable_to_non_nullable
as int,deadwood: null == deadwood ? _self.deadwood : deadwood // ignore: cast_nullable_to_non_nullable
as int,hasOpened: null == hasOpened ? _self.hasOpened : hasOpened // ignore: cast_nullable_to_non_nullable
as bool,delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$HandResult {

 int get handNumber;/// Null when the draw pile ran out with nobody going out.
 int? get winnerSeat; FinishType? get finishType; ScoreRowKey get rowKey; List<PlayerHandResult> get players;
/// Create a copy of HandResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HandResultCopyWith<HandResult> get copyWith => _$HandResultCopyWithImpl<HandResult>(this as HandResult, _$identity);

  /// Serializes this HandResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HandResult&&(identical(other.handNumber, handNumber) || other.handNumber == handNumber)&&(identical(other.winnerSeat, winnerSeat) || other.winnerSeat == winnerSeat)&&(identical(other.finishType, finishType) || other.finishType == finishType)&&(identical(other.rowKey, rowKey) || other.rowKey == rowKey)&&const DeepCollectionEquality().equals(other.players, players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,handNumber,winnerSeat,finishType,rowKey,const DeepCollectionEquality().hash(players));

@override
String toString() {
  return 'HandResult(handNumber: $handNumber, winnerSeat: $winnerSeat, finishType: $finishType, rowKey: $rowKey, players: $players)';
}


}

/// @nodoc
abstract mixin class $HandResultCopyWith<$Res>  {
  factory $HandResultCopyWith(HandResult value, $Res Function(HandResult) _then) = _$HandResultCopyWithImpl;
@useResult
$Res call({
 int handNumber, int? winnerSeat, FinishType? finishType, ScoreRowKey rowKey, List<PlayerHandResult> players
});




}
/// @nodoc
class _$HandResultCopyWithImpl<$Res>
    implements $HandResultCopyWith<$Res> {
  _$HandResultCopyWithImpl(this._self, this._then);

  final HandResult _self;
  final $Res Function(HandResult) _then;

/// Create a copy of HandResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? handNumber = null,Object? winnerSeat = freezed,Object? finishType = freezed,Object? rowKey = null,Object? players = null,}) {
  return _then(_self.copyWith(
handNumber: null == handNumber ? _self.handNumber : handNumber // ignore: cast_nullable_to_non_nullable
as int,winnerSeat: freezed == winnerSeat ? _self.winnerSeat : winnerSeat // ignore: cast_nullable_to_non_nullable
as int?,finishType: freezed == finishType ? _self.finishType : finishType // ignore: cast_nullable_to_non_nullable
as FinishType?,rowKey: null == rowKey ? _self.rowKey : rowKey // ignore: cast_nullable_to_non_nullable
as ScoreRowKey,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<PlayerHandResult>,
  ));
}

}


/// Adds pattern-matching-related methods to [HandResult].
extension HandResultPatterns on HandResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HandResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HandResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HandResult value)  $default,){
final _that = this;
switch (_that) {
case _HandResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HandResult value)?  $default,){
final _that = this;
switch (_that) {
case _HandResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int handNumber,  int? winnerSeat,  FinishType? finishType,  ScoreRowKey rowKey,  List<PlayerHandResult> players)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HandResult() when $default != null:
return $default(_that.handNumber,_that.winnerSeat,_that.finishType,_that.rowKey,_that.players);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int handNumber,  int? winnerSeat,  FinishType? finishType,  ScoreRowKey rowKey,  List<PlayerHandResult> players)  $default,) {final _that = this;
switch (_that) {
case _HandResult():
return $default(_that.handNumber,_that.winnerSeat,_that.finishType,_that.rowKey,_that.players);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int handNumber,  int? winnerSeat,  FinishType? finishType,  ScoreRowKey rowKey,  List<PlayerHandResult> players)?  $default,) {final _that = this;
switch (_that) {
case _HandResult() when $default != null:
return $default(_that.handNumber,_that.winnerSeat,_that.finishType,_that.rowKey,_that.players);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HandResult extends HandResult {
  const _HandResult({required this.handNumber, required this.winnerSeat, required this.finishType, required this.rowKey, required final  List<PlayerHandResult> players}): _players = players,super._();
  factory _HandResult.fromJson(Map<String, dynamic> json) => _$HandResultFromJson(json);

@override final  int handNumber;
/// Null when the draw pile ran out with nobody going out.
@override final  int? winnerSeat;
@override final  FinishType? finishType;
@override final  ScoreRowKey rowKey;
 final  List<PlayerHandResult> _players;
@override List<PlayerHandResult> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}


/// Create a copy of HandResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HandResultCopyWith<_HandResult> get copyWith => __$HandResultCopyWithImpl<_HandResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HandResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HandResult&&(identical(other.handNumber, handNumber) || other.handNumber == handNumber)&&(identical(other.winnerSeat, winnerSeat) || other.winnerSeat == winnerSeat)&&(identical(other.finishType, finishType) || other.finishType == finishType)&&(identical(other.rowKey, rowKey) || other.rowKey == rowKey)&&const DeepCollectionEquality().equals(other._players, _players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,handNumber,winnerSeat,finishType,rowKey,const DeepCollectionEquality().hash(_players));

@override
String toString() {
  return 'HandResult(handNumber: $handNumber, winnerSeat: $winnerSeat, finishType: $finishType, rowKey: $rowKey, players: $players)';
}


}

/// @nodoc
abstract mixin class _$HandResultCopyWith<$Res> implements $HandResultCopyWith<$Res> {
  factory _$HandResultCopyWith(_HandResult value, $Res Function(_HandResult) _then) = __$HandResultCopyWithImpl;
@override @useResult
$Res call({
 int handNumber, int? winnerSeat, FinishType? finishType, ScoreRowKey rowKey, List<PlayerHandResult> players
});




}
/// @nodoc
class __$HandResultCopyWithImpl<$Res>
    implements _$HandResultCopyWith<$Res> {
  __$HandResultCopyWithImpl(this._self, this._then);

  final _HandResult _self;
  final $Res Function(_HandResult) _then;

/// Create a copy of HandResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? handNumber = null,Object? winnerSeat = freezed,Object? finishType = freezed,Object? rowKey = null,Object? players = null,}) {
  return _then(_HandResult(
handNumber: null == handNumber ? _self.handNumber : handNumber // ignore: cast_nullable_to_non_nullable
as int,winnerSeat: freezed == winnerSeat ? _self.winnerSeat : winnerSeat // ignore: cast_nullable_to_non_nullable
as int?,finishType: freezed == finishType ? _self.finishType : finishType // ignore: cast_nullable_to_non_nullable
as FinishType?,rowKey: null == rowKey ? _self.rowKey : rowKey // ignore: cast_nullable_to_non_nullable
as ScoreRowKey,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<PlayerHandResult>,
  ));
}


}


/// @nodoc
mixin _$MatchRecord {

 String get id;/// Milliseconds since epoch. Supplied by the caller - the domain never
/// reads the clock itself.
 int get timestampMs; List<String> get playerNames; List<int> get finalScores; int get winnerSeat; int get handsPlayed; RulePreset get preset;
/// Create a copy of MatchRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchRecordCopyWith<MatchRecord> get copyWith => _$MatchRecordCopyWithImpl<MatchRecord>(this as MatchRecord, _$identity);

  /// Serializes this MatchRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.timestampMs, timestampMs) || other.timestampMs == timestampMs)&&const DeepCollectionEquality().equals(other.playerNames, playerNames)&&const DeepCollectionEquality().equals(other.finalScores, finalScores)&&(identical(other.winnerSeat, winnerSeat) || other.winnerSeat == winnerSeat)&&(identical(other.handsPlayed, handsPlayed) || other.handsPlayed == handsPlayed)&&(identical(other.preset, preset) || other.preset == preset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timestampMs,const DeepCollectionEquality().hash(playerNames),const DeepCollectionEquality().hash(finalScores),winnerSeat,handsPlayed,preset);

@override
String toString() {
  return 'MatchRecord(id: $id, timestampMs: $timestampMs, playerNames: $playerNames, finalScores: $finalScores, winnerSeat: $winnerSeat, handsPlayed: $handsPlayed, preset: $preset)';
}


}

/// @nodoc
abstract mixin class $MatchRecordCopyWith<$Res>  {
  factory $MatchRecordCopyWith(MatchRecord value, $Res Function(MatchRecord) _then) = _$MatchRecordCopyWithImpl;
@useResult
$Res call({
 String id, int timestampMs, List<String> playerNames, List<int> finalScores, int winnerSeat, int handsPlayed, RulePreset preset
});




}
/// @nodoc
class _$MatchRecordCopyWithImpl<$Res>
    implements $MatchRecordCopyWith<$Res> {
  _$MatchRecordCopyWithImpl(this._self, this._then);

  final MatchRecord _self;
  final $Res Function(MatchRecord) _then;

/// Create a copy of MatchRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? timestampMs = null,Object? playerNames = null,Object? finalScores = null,Object? winnerSeat = null,Object? handsPlayed = null,Object? preset = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,timestampMs: null == timestampMs ? _self.timestampMs : timestampMs // ignore: cast_nullable_to_non_nullable
as int,playerNames: null == playerNames ? _self.playerNames : playerNames // ignore: cast_nullable_to_non_nullable
as List<String>,finalScores: null == finalScores ? _self.finalScores : finalScores // ignore: cast_nullable_to_non_nullable
as List<int>,winnerSeat: null == winnerSeat ? _self.winnerSeat : winnerSeat // ignore: cast_nullable_to_non_nullable
as int,handsPlayed: null == handsPlayed ? _self.handsPlayed : handsPlayed // ignore: cast_nullable_to_non_nullable
as int,preset: null == preset ? _self.preset : preset // ignore: cast_nullable_to_non_nullable
as RulePreset,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchRecord].
extension MatchRecordPatterns on MatchRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchRecord value)  $default,){
final _that = this;
switch (_that) {
case _MatchRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchRecord value)?  $default,){
final _that = this;
switch (_that) {
case _MatchRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int timestampMs,  List<String> playerNames,  List<int> finalScores,  int winnerSeat,  int handsPlayed,  RulePreset preset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchRecord() when $default != null:
return $default(_that.id,_that.timestampMs,_that.playerNames,_that.finalScores,_that.winnerSeat,_that.handsPlayed,_that.preset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int timestampMs,  List<String> playerNames,  List<int> finalScores,  int winnerSeat,  int handsPlayed,  RulePreset preset)  $default,) {final _that = this;
switch (_that) {
case _MatchRecord():
return $default(_that.id,_that.timestampMs,_that.playerNames,_that.finalScores,_that.winnerSeat,_that.handsPlayed,_that.preset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int timestampMs,  List<String> playerNames,  List<int> finalScores,  int winnerSeat,  int handsPlayed,  RulePreset preset)?  $default,) {final _that = this;
switch (_that) {
case _MatchRecord() when $default != null:
return $default(_that.id,_that.timestampMs,_that.playerNames,_that.finalScores,_that.winnerSeat,_that.handsPlayed,_that.preset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchRecord extends MatchRecord {
  const _MatchRecord({required this.id, required this.timestampMs, required final  List<String> playerNames, required final  List<int> finalScores, required this.winnerSeat, required this.handsPlayed, required this.preset}): _playerNames = playerNames,_finalScores = finalScores,super._();
  factory _MatchRecord.fromJson(Map<String, dynamic> json) => _$MatchRecordFromJson(json);

@override final  String id;
/// Milliseconds since epoch. Supplied by the caller - the domain never
/// reads the clock itself.
@override final  int timestampMs;
 final  List<String> _playerNames;
@override List<String> get playerNames {
  if (_playerNames is EqualUnmodifiableListView) return _playerNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerNames);
}

 final  List<int> _finalScores;
@override List<int> get finalScores {
  if (_finalScores is EqualUnmodifiableListView) return _finalScores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_finalScores);
}

@override final  int winnerSeat;
@override final  int handsPlayed;
@override final  RulePreset preset;

/// Create a copy of MatchRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchRecordCopyWith<_MatchRecord> get copyWith => __$MatchRecordCopyWithImpl<_MatchRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.timestampMs, timestampMs) || other.timestampMs == timestampMs)&&const DeepCollectionEquality().equals(other._playerNames, _playerNames)&&const DeepCollectionEquality().equals(other._finalScores, _finalScores)&&(identical(other.winnerSeat, winnerSeat) || other.winnerSeat == winnerSeat)&&(identical(other.handsPlayed, handsPlayed) || other.handsPlayed == handsPlayed)&&(identical(other.preset, preset) || other.preset == preset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timestampMs,const DeepCollectionEquality().hash(_playerNames),const DeepCollectionEquality().hash(_finalScores),winnerSeat,handsPlayed,preset);

@override
String toString() {
  return 'MatchRecord(id: $id, timestampMs: $timestampMs, playerNames: $playerNames, finalScores: $finalScores, winnerSeat: $winnerSeat, handsPlayed: $handsPlayed, preset: $preset)';
}


}

/// @nodoc
abstract mixin class _$MatchRecordCopyWith<$Res> implements $MatchRecordCopyWith<$Res> {
  factory _$MatchRecordCopyWith(_MatchRecord value, $Res Function(_MatchRecord) _then) = __$MatchRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, int timestampMs, List<String> playerNames, List<int> finalScores, int winnerSeat, int handsPlayed, RulePreset preset
});




}
/// @nodoc
class __$MatchRecordCopyWithImpl<$Res>
    implements _$MatchRecordCopyWith<$Res> {
  __$MatchRecordCopyWithImpl(this._self, this._then);

  final _MatchRecord _self;
  final $Res Function(_MatchRecord) _then;

/// Create a copy of MatchRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? timestampMs = null,Object? playerNames = null,Object? finalScores = null,Object? winnerSeat = null,Object? handsPlayed = null,Object? preset = null,}) {
  return _then(_MatchRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,timestampMs: null == timestampMs ? _self.timestampMs : timestampMs // ignore: cast_nullable_to_non_nullable
as int,playerNames: null == playerNames ? _self._playerNames : playerNames // ignore: cast_nullable_to_non_nullable
as List<String>,finalScores: null == finalScores ? _self._finalScores : finalScores // ignore: cast_nullable_to_non_nullable
as List<int>,winnerSeat: null == winnerSeat ? _self.winnerSeat : winnerSeat // ignore: cast_nullable_to_non_nullable
as int,handsPlayed: null == handsPlayed ? _self.handsPlayed : handsPlayed // ignore: cast_nullable_to_non_nullable
as int,preset: null == preset ? _self.preset : preset // ignore: cast_nullable_to_non_nullable
as RulePreset,
  ));
}


}

// dart format on
