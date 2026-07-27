// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meld.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Meld {

 int get id; MeldKind get kind; int get ownerSeat; List<Tile> get tiles;/// Index-parallel with [tiles]. Non-null exactly at the positions holding a
/// wild okey, recording what that okey was laid down as. This is what
/// drives scoring and joker replacement.
 List<TileIdentity?> get jokerAssignments;
/// Create a copy of Meld
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeldCopyWith<Meld> get copyWith => _$MeldCopyWithImpl<Meld>(this as Meld, _$identity);

  /// Serializes this Meld to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Meld&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.ownerSeat, ownerSeat) || other.ownerSeat == ownerSeat)&&const DeepCollectionEquality().equals(other.tiles, tiles)&&const DeepCollectionEquality().equals(other.jokerAssignments, jokerAssignments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,ownerSeat,const DeepCollectionEquality().hash(tiles),const DeepCollectionEquality().hash(jokerAssignments));

@override
String toString() {
  return 'Meld(id: $id, kind: $kind, ownerSeat: $ownerSeat, tiles: $tiles, jokerAssignments: $jokerAssignments)';
}


}

/// @nodoc
abstract mixin class $MeldCopyWith<$Res>  {
  factory $MeldCopyWith(Meld value, $Res Function(Meld) _then) = _$MeldCopyWithImpl;
@useResult
$Res call({
 int id, MeldKind kind, int ownerSeat, List<Tile> tiles, List<TileIdentity?> jokerAssignments
});




}
/// @nodoc
class _$MeldCopyWithImpl<$Res>
    implements $MeldCopyWith<$Res> {
  _$MeldCopyWithImpl(this._self, this._then);

  final Meld _self;
  final $Res Function(Meld) _then;

/// Create a copy of Meld
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? ownerSeat = null,Object? tiles = null,Object? jokerAssignments = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MeldKind,ownerSeat: null == ownerSeat ? _self.ownerSeat : ownerSeat // ignore: cast_nullable_to_non_nullable
as int,tiles: null == tiles ? _self.tiles : tiles // ignore: cast_nullable_to_non_nullable
as List<Tile>,jokerAssignments: null == jokerAssignments ? _self.jokerAssignments : jokerAssignments // ignore: cast_nullable_to_non_nullable
as List<TileIdentity?>,
  ));
}

}


/// Adds pattern-matching-related methods to [Meld].
extension MeldPatterns on Meld {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Meld value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Meld() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Meld value)  $default,){
final _that = this;
switch (_that) {
case _Meld():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Meld value)?  $default,){
final _that = this;
switch (_that) {
case _Meld() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  MeldKind kind,  int ownerSeat,  List<Tile> tiles,  List<TileIdentity?> jokerAssignments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Meld() when $default != null:
return $default(_that.id,_that.kind,_that.ownerSeat,_that.tiles,_that.jokerAssignments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  MeldKind kind,  int ownerSeat,  List<Tile> tiles,  List<TileIdentity?> jokerAssignments)  $default,) {final _that = this;
switch (_that) {
case _Meld():
return $default(_that.id,_that.kind,_that.ownerSeat,_that.tiles,_that.jokerAssignments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  MeldKind kind,  int ownerSeat,  List<Tile> tiles,  List<TileIdentity?> jokerAssignments)?  $default,) {final _that = this;
switch (_that) {
case _Meld() when $default != null:
return $default(_that.id,_that.kind,_that.ownerSeat,_that.tiles,_that.jokerAssignments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Meld extends Meld {
  const _Meld({required this.id, required this.kind, required this.ownerSeat, required final  List<Tile> tiles, required final  List<TileIdentity?> jokerAssignments}): _tiles = tiles,_jokerAssignments = jokerAssignments,super._();
  factory _Meld.fromJson(Map<String, dynamic> json) => _$MeldFromJson(json);

@override final  int id;
@override final  MeldKind kind;
@override final  int ownerSeat;
 final  List<Tile> _tiles;
@override List<Tile> get tiles {
  if (_tiles is EqualUnmodifiableListView) return _tiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tiles);
}

/// Index-parallel with [tiles]. Non-null exactly at the positions holding a
/// wild okey, recording what that okey was laid down as. This is what
/// drives scoring and joker replacement.
 final  List<TileIdentity?> _jokerAssignments;
/// Index-parallel with [tiles]. Non-null exactly at the positions holding a
/// wild okey, recording what that okey was laid down as. This is what
/// drives scoring and joker replacement.
@override List<TileIdentity?> get jokerAssignments {
  if (_jokerAssignments is EqualUnmodifiableListView) return _jokerAssignments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_jokerAssignments);
}


/// Create a copy of Meld
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeldCopyWith<_Meld> get copyWith => __$MeldCopyWithImpl<_Meld>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeldToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Meld&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.ownerSeat, ownerSeat) || other.ownerSeat == ownerSeat)&&const DeepCollectionEquality().equals(other._tiles, _tiles)&&const DeepCollectionEquality().equals(other._jokerAssignments, _jokerAssignments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,ownerSeat,const DeepCollectionEquality().hash(_tiles),const DeepCollectionEquality().hash(_jokerAssignments));

@override
String toString() {
  return 'Meld(id: $id, kind: $kind, ownerSeat: $ownerSeat, tiles: $tiles, jokerAssignments: $jokerAssignments)';
}


}

/// @nodoc
abstract mixin class _$MeldCopyWith<$Res> implements $MeldCopyWith<$Res> {
  factory _$MeldCopyWith(_Meld value, $Res Function(_Meld) _then) = __$MeldCopyWithImpl;
@override @useResult
$Res call({
 int id, MeldKind kind, int ownerSeat, List<Tile> tiles, List<TileIdentity?> jokerAssignments
});




}
/// @nodoc
class __$MeldCopyWithImpl<$Res>
    implements _$MeldCopyWith<$Res> {
  __$MeldCopyWithImpl(this._self, this._then);

  final _Meld _self;
  final $Res Function(_Meld) _then;

/// Create a copy of Meld
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? ownerSeat = null,Object? tiles = null,Object? jokerAssignments = null,}) {
  return _then(_Meld(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MeldKind,ownerSeat: null == ownerSeat ? _self.ownerSeat : ownerSeat // ignore: cast_nullable_to_non_nullable
as int,tiles: null == tiles ? _self._tiles : tiles // ignore: cast_nullable_to_non_nullable
as List<Tile>,jokerAssignments: null == jokerAssignments ? _self._jokerAssignments : jokerAssignments // ignore: cast_nullable_to_non_nullable
as List<TileIdentity?>,
  ));
}


}


/// @nodoc
mixin _$MeldProposal {

 MeldKind get kind;/// Ordered tile ids. Order is what disambiguates a wild's identity.
 List<int> get tileIds;
/// Create a copy of MeldProposal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeldProposalCopyWith<MeldProposal> get copyWith => _$MeldProposalCopyWithImpl<MeldProposal>(this as MeldProposal, _$identity);

  /// Serializes this MeldProposal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeldProposal&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other.tileIds, tileIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,const DeepCollectionEquality().hash(tileIds));

@override
String toString() {
  return 'MeldProposal(kind: $kind, tileIds: $tileIds)';
}


}

/// @nodoc
abstract mixin class $MeldProposalCopyWith<$Res>  {
  factory $MeldProposalCopyWith(MeldProposal value, $Res Function(MeldProposal) _then) = _$MeldProposalCopyWithImpl;
@useResult
$Res call({
 MeldKind kind, List<int> tileIds
});




}
/// @nodoc
class _$MeldProposalCopyWithImpl<$Res>
    implements $MeldProposalCopyWith<$Res> {
  _$MeldProposalCopyWithImpl(this._self, this._then);

  final MeldProposal _self;
  final $Res Function(MeldProposal) _then;

/// Create a copy of MeldProposal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? tileIds = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MeldKind,tileIds: null == tileIds ? _self.tileIds : tileIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [MeldProposal].
extension MeldProposalPatterns on MeldProposal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeldProposal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeldProposal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeldProposal value)  $default,){
final _that = this;
switch (_that) {
case _MeldProposal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeldProposal value)?  $default,){
final _that = this;
switch (_that) {
case _MeldProposal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MeldKind kind,  List<int> tileIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeldProposal() when $default != null:
return $default(_that.kind,_that.tileIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MeldKind kind,  List<int> tileIds)  $default,) {final _that = this;
switch (_that) {
case _MeldProposal():
return $default(_that.kind,_that.tileIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MeldKind kind,  List<int> tileIds)?  $default,) {final _that = this;
switch (_that) {
case _MeldProposal() when $default != null:
return $default(_that.kind,_that.tileIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeldProposal extends MeldProposal {
  const _MeldProposal({required this.kind, required final  List<int> tileIds}): _tileIds = tileIds,super._();
  factory _MeldProposal.fromJson(Map<String, dynamic> json) => _$MeldProposalFromJson(json);

@override final  MeldKind kind;
/// Ordered tile ids. Order is what disambiguates a wild's identity.
 final  List<int> _tileIds;
/// Ordered tile ids. Order is what disambiguates a wild's identity.
@override List<int> get tileIds {
  if (_tileIds is EqualUnmodifiableListView) return _tileIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tileIds);
}


/// Create a copy of MeldProposal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeldProposalCopyWith<_MeldProposal> get copyWith => __$MeldProposalCopyWithImpl<_MeldProposal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeldProposalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeldProposal&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other._tileIds, _tileIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,const DeepCollectionEquality().hash(_tileIds));

@override
String toString() {
  return 'MeldProposal(kind: $kind, tileIds: $tileIds)';
}


}

/// @nodoc
abstract mixin class _$MeldProposalCopyWith<$Res> implements $MeldProposalCopyWith<$Res> {
  factory _$MeldProposalCopyWith(_MeldProposal value, $Res Function(_MeldProposal) _then) = __$MeldProposalCopyWithImpl;
@override @useResult
$Res call({
 MeldKind kind, List<int> tileIds
});




}
/// @nodoc
class __$MeldProposalCopyWithImpl<$Res>
    implements _$MeldProposalCopyWith<$Res> {
  __$MeldProposalCopyWithImpl(this._self, this._then);

  final _MeldProposal _self;
  final $Res Function(_MeldProposal) _then;

/// Create a copy of MeldProposal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? tileIds = null,}) {
  return _then(_MeldProposal(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MeldKind,tileIds: null == tileIds ? _self._tileIds : tileIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
