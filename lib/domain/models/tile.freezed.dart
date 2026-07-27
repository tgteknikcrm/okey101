// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TileIdentity {

 TileColor get color; int get number;
/// Create a copy of TileIdentity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TileIdentityCopyWith<TileIdentity> get copyWith => _$TileIdentityCopyWithImpl<TileIdentity>(this as TileIdentity, _$identity);

  /// Serializes this TileIdentity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TileIdentity&&(identical(other.color, color) || other.color == color)&&(identical(other.number, number) || other.number == number));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,color,number);

@override
String toString() {
  return 'TileIdentity(color: $color, number: $number)';
}


}

/// @nodoc
abstract mixin class $TileIdentityCopyWith<$Res>  {
  factory $TileIdentityCopyWith(TileIdentity value, $Res Function(TileIdentity) _then) = _$TileIdentityCopyWithImpl;
@useResult
$Res call({
 TileColor color, int number
});




}
/// @nodoc
class _$TileIdentityCopyWithImpl<$Res>
    implements $TileIdentityCopyWith<$Res> {
  _$TileIdentityCopyWithImpl(this._self, this._then);

  final TileIdentity _self;
  final $Res Function(TileIdentity) _then;

/// Create a copy of TileIdentity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? color = null,Object? number = null,}) {
  return _then(_self.copyWith(
color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as TileColor,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TileIdentity].
extension TileIdentityPatterns on TileIdentity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TileIdentity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TileIdentity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TileIdentity value)  $default,){
final _that = this;
switch (_that) {
case _TileIdentity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TileIdentity value)?  $default,){
final _that = this;
switch (_that) {
case _TileIdentity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TileColor color,  int number)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TileIdentity() when $default != null:
return $default(_that.color,_that.number);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TileColor color,  int number)  $default,) {final _that = this;
switch (_that) {
case _TileIdentity():
return $default(_that.color,_that.number);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TileColor color,  int number)?  $default,) {final _that = this;
switch (_that) {
case _TileIdentity() when $default != null:
return $default(_that.color,_that.number);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TileIdentity extends TileIdentity {
  const _TileIdentity({required this.color, required this.number}): super._();
  factory _TileIdentity.fromJson(Map<String, dynamic> json) => _$TileIdentityFromJson(json);

@override final  TileColor color;
@override final  int number;

/// Create a copy of TileIdentity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TileIdentityCopyWith<_TileIdentity> get copyWith => __$TileIdentityCopyWithImpl<_TileIdentity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TileIdentityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TileIdentity&&(identical(other.color, color) || other.color == color)&&(identical(other.number, number) || other.number == number));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,color,number);

@override
String toString() {
  return 'TileIdentity(color: $color, number: $number)';
}


}

/// @nodoc
abstract mixin class _$TileIdentityCopyWith<$Res> implements $TileIdentityCopyWith<$Res> {
  factory _$TileIdentityCopyWith(_TileIdentity value, $Res Function(_TileIdentity) _then) = __$TileIdentityCopyWithImpl;
@override @useResult
$Res call({
 TileColor color, int number
});




}
/// @nodoc
class __$TileIdentityCopyWithImpl<$Res>
    implements _$TileIdentityCopyWith<$Res> {
  __$TileIdentityCopyWithImpl(this._self, this._then);

  final _TileIdentity _self;
  final $Res Function(_TileIdentity) _then;

/// Create a copy of TileIdentity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? color = null,Object? number = null,}) {
  return _then(_TileIdentity(
color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as TileColor,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Tile {

 int get id; int get copyIndex; TileColor? get color; int? get number; bool get isFalseJoker;
/// Create a copy of Tile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TileCopyWith<Tile> get copyWith => _$TileCopyWithImpl<Tile>(this as Tile, _$identity);

  /// Serializes this Tile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tile&&(identical(other.id, id) || other.id == id)&&(identical(other.copyIndex, copyIndex) || other.copyIndex == copyIndex)&&(identical(other.color, color) || other.color == color)&&(identical(other.number, number) || other.number == number)&&(identical(other.isFalseJoker, isFalseJoker) || other.isFalseJoker == isFalseJoker));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,copyIndex,color,number,isFalseJoker);

@override
String toString() {
  return 'Tile(id: $id, copyIndex: $copyIndex, color: $color, number: $number, isFalseJoker: $isFalseJoker)';
}


}

/// @nodoc
abstract mixin class $TileCopyWith<$Res>  {
  factory $TileCopyWith(Tile value, $Res Function(Tile) _then) = _$TileCopyWithImpl;
@useResult
$Res call({
 int id, int copyIndex, TileColor? color, int? number, bool isFalseJoker
});




}
/// @nodoc
class _$TileCopyWithImpl<$Res>
    implements $TileCopyWith<$Res> {
  _$TileCopyWithImpl(this._self, this._then);

  final Tile _self;
  final $Res Function(Tile) _then;

/// Create a copy of Tile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? copyIndex = null,Object? color = freezed,Object? number = freezed,Object? isFalseJoker = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,copyIndex: null == copyIndex ? _self.copyIndex : copyIndex // ignore: cast_nullable_to_non_nullable
as int,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as TileColor?,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,isFalseJoker: null == isFalseJoker ? _self.isFalseJoker : isFalseJoker // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Tile].
extension TilePatterns on Tile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tile value)  $default,){
final _that = this;
switch (_that) {
case _Tile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tile value)?  $default,){
final _that = this;
switch (_that) {
case _Tile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int copyIndex,  TileColor? color,  int? number,  bool isFalseJoker)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tile() when $default != null:
return $default(_that.id,_that.copyIndex,_that.color,_that.number,_that.isFalseJoker);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int copyIndex,  TileColor? color,  int? number,  bool isFalseJoker)  $default,) {final _that = this;
switch (_that) {
case _Tile():
return $default(_that.id,_that.copyIndex,_that.color,_that.number,_that.isFalseJoker);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int copyIndex,  TileColor? color,  int? number,  bool isFalseJoker)?  $default,) {final _that = this;
switch (_that) {
case _Tile() when $default != null:
return $default(_that.id,_that.copyIndex,_that.color,_that.number,_that.isFalseJoker);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Tile extends Tile {
  const _Tile({required this.id, required this.copyIndex, this.color, this.number, this.isFalseJoker = false}): super._();
  factory _Tile.fromJson(Map<String, dynamic> json) => _$TileFromJson(json);

@override final  int id;
@override final  int copyIndex;
@override final  TileColor? color;
@override final  int? number;
@override@JsonKey() final  bool isFalseJoker;

/// Create a copy of Tile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TileCopyWith<_Tile> get copyWith => __$TileCopyWithImpl<_Tile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tile&&(identical(other.id, id) || other.id == id)&&(identical(other.copyIndex, copyIndex) || other.copyIndex == copyIndex)&&(identical(other.color, color) || other.color == color)&&(identical(other.number, number) || other.number == number)&&(identical(other.isFalseJoker, isFalseJoker) || other.isFalseJoker == isFalseJoker));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,copyIndex,color,number,isFalseJoker);

@override
String toString() {
  return 'Tile(id: $id, copyIndex: $copyIndex, color: $color, number: $number, isFalseJoker: $isFalseJoker)';
}


}

/// @nodoc
abstract mixin class _$TileCopyWith<$Res> implements $TileCopyWith<$Res> {
  factory _$TileCopyWith(_Tile value, $Res Function(_Tile) _then) = __$TileCopyWithImpl;
@override @useResult
$Res call({
 int id, int copyIndex, TileColor? color, int? number, bool isFalseJoker
});




}
/// @nodoc
class __$TileCopyWithImpl<$Res>
    implements _$TileCopyWith<$Res> {
  __$TileCopyWithImpl(this._self, this._then);

  final _Tile _self;
  final $Res Function(_Tile) _then;

/// Create a copy of Tile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? copyIndex = null,Object? color = freezed,Object? number = freezed,Object? isFalseJoker = null,}) {
  return _then(_Tile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,copyIndex: null == copyIndex ? _self.copyIndex : copyIndex // ignore: cast_nullable_to_non_nullable
as int,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as TileColor?,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,isFalseJoker: null == isFalseJoker ? _self.isFalseJoker : isFalseJoker // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
