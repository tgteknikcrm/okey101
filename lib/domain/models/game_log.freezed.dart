// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameLog {

 int get seed; RuleSet get ruleSet; List<String> get playerNames; List<GameAction> get canonicalActions;
/// Create a copy of GameLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameLogCopyWith<GameLog> get copyWith => _$GameLogCopyWithImpl<GameLog>(this as GameLog, _$identity);

  /// Serializes this GameLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameLog&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.ruleSet, ruleSet) || other.ruleSet == ruleSet)&&const DeepCollectionEquality().equals(other.playerNames, playerNames)&&const DeepCollectionEquality().equals(other.canonicalActions, canonicalActions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seed,ruleSet,const DeepCollectionEquality().hash(playerNames),const DeepCollectionEquality().hash(canonicalActions));

@override
String toString() {
  return 'GameLog(seed: $seed, ruleSet: $ruleSet, playerNames: $playerNames, canonicalActions: $canonicalActions)';
}


}

/// @nodoc
abstract mixin class $GameLogCopyWith<$Res>  {
  factory $GameLogCopyWith(GameLog value, $Res Function(GameLog) _then) = _$GameLogCopyWithImpl;
@useResult
$Res call({
 int seed, RuleSet ruleSet, List<String> playerNames, List<GameAction> canonicalActions
});


$RuleSetCopyWith<$Res> get ruleSet;

}
/// @nodoc
class _$GameLogCopyWithImpl<$Res>
    implements $GameLogCopyWith<$Res> {
  _$GameLogCopyWithImpl(this._self, this._then);

  final GameLog _self;
  final $Res Function(GameLog) _then;

/// Create a copy of GameLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seed = null,Object? ruleSet = null,Object? playerNames = null,Object? canonicalActions = null,}) {
  return _then(_self.copyWith(
seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,ruleSet: null == ruleSet ? _self.ruleSet : ruleSet // ignore: cast_nullable_to_non_nullable
as RuleSet,playerNames: null == playerNames ? _self.playerNames : playerNames // ignore: cast_nullable_to_non_nullable
as List<String>,canonicalActions: null == canonicalActions ? _self.canonicalActions : canonicalActions // ignore: cast_nullable_to_non_nullable
as List<GameAction>,
  ));
}
/// Create a copy of GameLog
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RuleSetCopyWith<$Res> get ruleSet {
  
  return $RuleSetCopyWith<$Res>(_self.ruleSet, (value) {
    return _then(_self.copyWith(ruleSet: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameLog].
extension GameLogPatterns on GameLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameLog value)  $default,){
final _that = this;
switch (_that) {
case _GameLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameLog value)?  $default,){
final _that = this;
switch (_that) {
case _GameLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seed,  RuleSet ruleSet,  List<String> playerNames,  List<GameAction> canonicalActions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameLog() when $default != null:
return $default(_that.seed,_that.ruleSet,_that.playerNames,_that.canonicalActions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seed,  RuleSet ruleSet,  List<String> playerNames,  List<GameAction> canonicalActions)  $default,) {final _that = this;
switch (_that) {
case _GameLog():
return $default(_that.seed,_that.ruleSet,_that.playerNames,_that.canonicalActions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seed,  RuleSet ruleSet,  List<String> playerNames,  List<GameAction> canonicalActions)?  $default,) {final _that = this;
switch (_that) {
case _GameLog() when $default != null:
return $default(_that.seed,_that.ruleSet,_that.playerNames,_that.canonicalActions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameLog extends GameLog {
  const _GameLog({required this.seed, required this.ruleSet, required final  List<String> playerNames, final  List<GameAction> canonicalActions = const <GameAction>[]}): _playerNames = playerNames,_canonicalActions = canonicalActions,super._();
  factory _GameLog.fromJson(Map<String, dynamic> json) => _$GameLogFromJson(json);

@override final  int seed;
@override final  RuleSet ruleSet;
 final  List<String> _playerNames;
@override List<String> get playerNames {
  if (_playerNames is EqualUnmodifiableListView) return _playerNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerNames);
}

 final  List<GameAction> _canonicalActions;
@override@JsonKey() List<GameAction> get canonicalActions {
  if (_canonicalActions is EqualUnmodifiableListView) return _canonicalActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_canonicalActions);
}


/// Create a copy of GameLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameLogCopyWith<_GameLog> get copyWith => __$GameLogCopyWithImpl<_GameLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameLog&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.ruleSet, ruleSet) || other.ruleSet == ruleSet)&&const DeepCollectionEquality().equals(other._playerNames, _playerNames)&&const DeepCollectionEquality().equals(other._canonicalActions, _canonicalActions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seed,ruleSet,const DeepCollectionEquality().hash(_playerNames),const DeepCollectionEquality().hash(_canonicalActions));

@override
String toString() {
  return 'GameLog(seed: $seed, ruleSet: $ruleSet, playerNames: $playerNames, canonicalActions: $canonicalActions)';
}


}

/// @nodoc
abstract mixin class _$GameLogCopyWith<$Res> implements $GameLogCopyWith<$Res> {
  factory _$GameLogCopyWith(_GameLog value, $Res Function(_GameLog) _then) = __$GameLogCopyWithImpl;
@override @useResult
$Res call({
 int seed, RuleSet ruleSet, List<String> playerNames, List<GameAction> canonicalActions
});


@override $RuleSetCopyWith<$Res> get ruleSet;

}
/// @nodoc
class __$GameLogCopyWithImpl<$Res>
    implements _$GameLogCopyWith<$Res> {
  __$GameLogCopyWithImpl(this._self, this._then);

  final _GameLog _self;
  final $Res Function(_GameLog) _then;

/// Create a copy of GameLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seed = null,Object? ruleSet = null,Object? playerNames = null,Object? canonicalActions = null,}) {
  return _then(_GameLog(
seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,ruleSet: null == ruleSet ? _self.ruleSet : ruleSet // ignore: cast_nullable_to_non_nullable
as RuleSet,playerNames: null == playerNames ? _self._playerNames : playerNames // ignore: cast_nullable_to_non_nullable
as List<String>,canonicalActions: null == canonicalActions ? _self._canonicalActions : canonicalActions // ignore: cast_nullable_to_non_nullable
as List<GameAction>,
  ));
}

/// Create a copy of GameLog
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RuleSetCopyWith<$Res> get ruleSet {
  
  return $RuleSetCopyWith<$Res>(_self.ruleSet, (value) {
    return _then(_self.copyWith(ruleSet: value));
  });
}
}

// dart format on
