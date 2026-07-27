// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettings {

/// 'tr' or 'en'. Turkish is the default.
 String get languageCode;/// Adds a colour glyph to every tile. The whole game is colour coded, so
/// this is not optional for a lot of people.
 bool get colorblind;/// Bots play without their think delay.
 bool get fastMode; bool get animations; bool get keepScreenAwake; BotDifficulty get difficulty; RuleSet get ruleSet;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.colorblind, colorblind) || other.colorblind == colorblind)&&(identical(other.fastMode, fastMode) || other.fastMode == fastMode)&&(identical(other.animations, animations) || other.animations == animations)&&(identical(other.keepScreenAwake, keepScreenAwake) || other.keepScreenAwake == keepScreenAwake)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.ruleSet, ruleSet) || other.ruleSet == ruleSet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,languageCode,colorblind,fastMode,animations,keepScreenAwake,difficulty,ruleSet);

@override
String toString() {
  return 'AppSettings(languageCode: $languageCode, colorblind: $colorblind, fastMode: $fastMode, animations: $animations, keepScreenAwake: $keepScreenAwake, difficulty: $difficulty, ruleSet: $ruleSet)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 String languageCode, bool colorblind, bool fastMode, bool animations, bool keepScreenAwake, BotDifficulty difficulty, RuleSet ruleSet
});


$RuleSetCopyWith<$Res> get ruleSet;

}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? languageCode = null,Object? colorblind = null,Object? fastMode = null,Object? animations = null,Object? keepScreenAwake = null,Object? difficulty = null,Object? ruleSet = null,}) {
  return _then(_self.copyWith(
languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,colorblind: null == colorblind ? _self.colorblind : colorblind // ignore: cast_nullable_to_non_nullable
as bool,fastMode: null == fastMode ? _self.fastMode : fastMode // ignore: cast_nullable_to_non_nullable
as bool,animations: null == animations ? _self.animations : animations // ignore: cast_nullable_to_non_nullable
as bool,keepScreenAwake: null == keepScreenAwake ? _self.keepScreenAwake : keepScreenAwake // ignore: cast_nullable_to_non_nullable
as bool,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as BotDifficulty,ruleSet: null == ruleSet ? _self.ruleSet : ruleSet // ignore: cast_nullable_to_non_nullable
as RuleSet,
  ));
}
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RuleSetCopyWith<$Res> get ruleSet {
  
  return $RuleSetCopyWith<$Res>(_self.ruleSet, (value) {
    return _then(_self.copyWith(ruleSet: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String languageCode,  bool colorblind,  bool fastMode,  bool animations,  bool keepScreenAwake,  BotDifficulty difficulty,  RuleSet ruleSet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.languageCode,_that.colorblind,_that.fastMode,_that.animations,_that.keepScreenAwake,_that.difficulty,_that.ruleSet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String languageCode,  bool colorblind,  bool fastMode,  bool animations,  bool keepScreenAwake,  BotDifficulty difficulty,  RuleSet ruleSet)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.languageCode,_that.colorblind,_that.fastMode,_that.animations,_that.keepScreenAwake,_that.difficulty,_that.ruleSet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String languageCode,  bool colorblind,  bool fastMode,  bool animations,  bool keepScreenAwake,  BotDifficulty difficulty,  RuleSet ruleSet)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.languageCode,_that.colorblind,_that.fastMode,_that.animations,_that.keepScreenAwake,_that.difficulty,_that.ruleSet);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSettings extends AppSettings {
  const _AppSettings({this.languageCode = 'tr', this.colorblind = false, this.fastMode = false, this.animations = true, this.keepScreenAwake = true, this.difficulty = BotDifficulty.medium, this.ruleSet = const RuleSet()}): super._();
  factory _AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

/// 'tr' or 'en'. Turkish is the default.
@override@JsonKey() final  String languageCode;
/// Adds a colour glyph to every tile. The whole game is colour coded, so
/// this is not optional for a lot of people.
@override@JsonKey() final  bool colorblind;
/// Bots play without their think delay.
@override@JsonKey() final  bool fastMode;
@override@JsonKey() final  bool animations;
@override@JsonKey() final  bool keepScreenAwake;
@override@JsonKey() final  BotDifficulty difficulty;
@override@JsonKey() final  RuleSet ruleSet;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.colorblind, colorblind) || other.colorblind == colorblind)&&(identical(other.fastMode, fastMode) || other.fastMode == fastMode)&&(identical(other.animations, animations) || other.animations == animations)&&(identical(other.keepScreenAwake, keepScreenAwake) || other.keepScreenAwake == keepScreenAwake)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.ruleSet, ruleSet) || other.ruleSet == ruleSet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,languageCode,colorblind,fastMode,animations,keepScreenAwake,difficulty,ruleSet);

@override
String toString() {
  return 'AppSettings(languageCode: $languageCode, colorblind: $colorblind, fastMode: $fastMode, animations: $animations, keepScreenAwake: $keepScreenAwake, difficulty: $difficulty, ruleSet: $ruleSet)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 String languageCode, bool colorblind, bool fastMode, bool animations, bool keepScreenAwake, BotDifficulty difficulty, RuleSet ruleSet
});


@override $RuleSetCopyWith<$Res> get ruleSet;

}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? languageCode = null,Object? colorblind = null,Object? fastMode = null,Object? animations = null,Object? keepScreenAwake = null,Object? difficulty = null,Object? ruleSet = null,}) {
  return _then(_AppSettings(
languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,colorblind: null == colorblind ? _self.colorblind : colorblind // ignore: cast_nullable_to_non_nullable
as bool,fastMode: null == fastMode ? _self.fastMode : fastMode // ignore: cast_nullable_to_non_nullable
as bool,animations: null == animations ? _self.animations : animations // ignore: cast_nullable_to_non_nullable
as bool,keepScreenAwake: null == keepScreenAwake ? _self.keepScreenAwake : keepScreenAwake // ignore: cast_nullable_to_non_nullable
as bool,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as BotDifficulty,ruleSet: null == ruleSet ? _self.ruleSet : ruleSet // ignore: cast_nullable_to_non_nullable
as RuleSet,
  ));
}

/// Create a copy of AppSettings
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
