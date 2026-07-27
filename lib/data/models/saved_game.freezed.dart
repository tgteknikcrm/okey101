// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavedGame {

 GameState get state;/// 26 entries, each a tile id or null for an empty slot.
 List<int?> get rackSlots;/// Milliseconds since epoch, supplied by the caller.
 int get savedAtMs;/// Bumped whenever the shape of this record changes so a stale save can be
/// discarded instead of crashing the app.
 int get version;
/// Create a copy of SavedGame
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedGameCopyWith<SavedGame> get copyWith => _$SavedGameCopyWithImpl<SavedGame>(this as SavedGame, _$identity);

  /// Serializes this SavedGame to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedGame&&(identical(other.state, state) || other.state == state)&&const DeepCollectionEquality().equals(other.rackSlots, rackSlots)&&(identical(other.savedAtMs, savedAtMs) || other.savedAtMs == savedAtMs)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,state,const DeepCollectionEquality().hash(rackSlots),savedAtMs,version);

@override
String toString() {
  return 'SavedGame(state: $state, rackSlots: $rackSlots, savedAtMs: $savedAtMs, version: $version)';
}


}

/// @nodoc
abstract mixin class $SavedGameCopyWith<$Res>  {
  factory $SavedGameCopyWith(SavedGame value, $Res Function(SavedGame) _then) = _$SavedGameCopyWithImpl;
@useResult
$Res call({
 GameState state, List<int?> rackSlots, int savedAtMs, int version
});


$GameStateCopyWith<$Res> get state;

}
/// @nodoc
class _$SavedGameCopyWithImpl<$Res>
    implements $SavedGameCopyWith<$Res> {
  _$SavedGameCopyWithImpl(this._self, this._then);

  final SavedGame _self;
  final $Res Function(SavedGame) _then;

/// Create a copy of SavedGame
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? state = null,Object? rackSlots = null,Object? savedAtMs = null,Object? version = null,}) {
  return _then(_self.copyWith(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as GameState,rackSlots: null == rackSlots ? _self.rackSlots : rackSlots // ignore: cast_nullable_to_non_nullable
as List<int?>,savedAtMs: null == savedAtMs ? _self.savedAtMs : savedAtMs // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of SavedGame
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameStateCopyWith<$Res> get state {
  
  return $GameStateCopyWith<$Res>(_self.state, (value) {
    return _then(_self.copyWith(state: value));
  });
}
}


/// Adds pattern-matching-related methods to [SavedGame].
extension SavedGamePatterns on SavedGame {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedGame value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedGame() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedGame value)  $default,){
final _that = this;
switch (_that) {
case _SavedGame():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedGame value)?  $default,){
final _that = this;
switch (_that) {
case _SavedGame() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GameState state,  List<int?> rackSlots,  int savedAtMs,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedGame() when $default != null:
return $default(_that.state,_that.rackSlots,_that.savedAtMs,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GameState state,  List<int?> rackSlots,  int savedAtMs,  int version)  $default,) {final _that = this;
switch (_that) {
case _SavedGame():
return $default(_that.state,_that.rackSlots,_that.savedAtMs,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GameState state,  List<int?> rackSlots,  int savedAtMs,  int version)?  $default,) {final _that = this;
switch (_that) {
case _SavedGame() when $default != null:
return $default(_that.state,_that.rackSlots,_that.savedAtMs,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavedGame extends SavedGame {
  const _SavedGame({required this.state, required final  List<int?> rackSlots, required this.savedAtMs, this.version = SavedGame.currentVersion}): _rackSlots = rackSlots,super._();
  factory _SavedGame.fromJson(Map<String, dynamic> json) => _$SavedGameFromJson(json);

@override final  GameState state;
/// 26 entries, each a tile id or null for an empty slot.
 final  List<int?> _rackSlots;
/// 26 entries, each a tile id or null for an empty slot.
@override List<int?> get rackSlots {
  if (_rackSlots is EqualUnmodifiableListView) return _rackSlots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rackSlots);
}

/// Milliseconds since epoch, supplied by the caller.
@override final  int savedAtMs;
/// Bumped whenever the shape of this record changes so a stale save can be
/// discarded instead of crashing the app.
@override@JsonKey() final  int version;

/// Create a copy of SavedGame
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedGameCopyWith<_SavedGame> get copyWith => __$SavedGameCopyWithImpl<_SavedGame>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavedGameToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedGame&&(identical(other.state, state) || other.state == state)&&const DeepCollectionEquality().equals(other._rackSlots, _rackSlots)&&(identical(other.savedAtMs, savedAtMs) || other.savedAtMs == savedAtMs)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,state,const DeepCollectionEquality().hash(_rackSlots),savedAtMs,version);

@override
String toString() {
  return 'SavedGame(state: $state, rackSlots: $rackSlots, savedAtMs: $savedAtMs, version: $version)';
}


}

/// @nodoc
abstract mixin class _$SavedGameCopyWith<$Res> implements $SavedGameCopyWith<$Res> {
  factory _$SavedGameCopyWith(_SavedGame value, $Res Function(_SavedGame) _then) = __$SavedGameCopyWithImpl;
@override @useResult
$Res call({
 GameState state, List<int?> rackSlots, int savedAtMs, int version
});


@override $GameStateCopyWith<$Res> get state;

}
/// @nodoc
class __$SavedGameCopyWithImpl<$Res>
    implements _$SavedGameCopyWith<$Res> {
  __$SavedGameCopyWithImpl(this._self, this._then);

  final _SavedGame _self;
  final $Res Function(_SavedGame) _then;

/// Create a copy of SavedGame
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? state = null,Object? rackSlots = null,Object? savedAtMs = null,Object? version = null,}) {
  return _then(_SavedGame(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as GameState,rackSlots: null == rackSlots ? _self._rackSlots : rackSlots // ignore: cast_nullable_to_non_nullable
as List<int?>,savedAtMs: null == savedAtMs ? _self.savedAtMs : savedAtMs // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of SavedGame
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameStateCopyWith<$Res> get state {
  
  return $GameStateCopyWith<$Res>(_self.state, (value) {
    return _then(_self.copyWith(state: value));
  });
}
}

// dart format on
