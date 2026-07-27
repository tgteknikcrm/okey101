// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scoring.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
OpponentPenalty _$OpponentPenaltyFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'deadwood_multiple':
          return DeadwoodMultiple.fromJson(
            json
          );
                case 'flat':
          return FlatPenalty.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'OpponentPenalty',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$OpponentPenalty {



  /// Serializes this OpponentPenalty to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpponentPenalty);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OpponentPenalty()';
}


}

/// @nodoc
class $OpponentPenaltyCopyWith<$Res>  {
$OpponentPenaltyCopyWith(OpponentPenalty _, $Res Function(OpponentPenalty) __);
}


/// Adds pattern-matching-related methods to [OpponentPenalty].
extension OpponentPenaltyPatterns on OpponentPenalty {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DeadwoodMultiple value)?  deadwoodMultiple,TResult Function( FlatPenalty value)?  flat,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DeadwoodMultiple() when deadwoodMultiple != null:
return deadwoodMultiple(_that);case FlatPenalty() when flat != null:
return flat(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DeadwoodMultiple value)  deadwoodMultiple,required TResult Function( FlatPenalty value)  flat,}){
final _that = this;
switch (_that) {
case DeadwoodMultiple():
return deadwoodMultiple(_that);case FlatPenalty():
return flat(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DeadwoodMultiple value)?  deadwoodMultiple,TResult? Function( FlatPenalty value)?  flat,}){
final _that = this;
switch (_that) {
case DeadwoodMultiple() when deadwoodMultiple != null:
return deadwoodMultiple(_that);case FlatPenalty() when flat != null:
return flat(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int multiplier)?  deadwoodMultiple,TResult Function( int points)?  flat,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DeadwoodMultiple() when deadwoodMultiple != null:
return deadwoodMultiple(_that.multiplier);case FlatPenalty() when flat != null:
return flat(_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int multiplier)  deadwoodMultiple,required TResult Function( int points)  flat,}) {final _that = this;
switch (_that) {
case DeadwoodMultiple():
return deadwoodMultiple(_that.multiplier);case FlatPenalty():
return flat(_that.points);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int multiplier)?  deadwoodMultiple,TResult? Function( int points)?  flat,}) {final _that = this;
switch (_that) {
case DeadwoodMultiple() when deadwoodMultiple != null:
return deadwoodMultiple(_that.multiplier);case FlatPenalty() when flat != null:
return flat(_that.points);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class DeadwoodMultiple extends OpponentPenalty {
  const DeadwoodMultiple({required this.multiplier, final  String? $type}): $type = $type ?? 'deadwood_multiple',super._();
  factory DeadwoodMultiple.fromJson(Map<String, dynamic> json) => _$DeadwoodMultipleFromJson(json);

 final  int multiplier;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of OpponentPenalty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeadwoodMultipleCopyWith<DeadwoodMultiple> get copyWith => _$DeadwoodMultipleCopyWithImpl<DeadwoodMultiple>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeadwoodMultipleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeadwoodMultiple&&(identical(other.multiplier, multiplier) || other.multiplier == multiplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,multiplier);

@override
String toString() {
  return 'OpponentPenalty.deadwoodMultiple(multiplier: $multiplier)';
}


}

/// @nodoc
abstract mixin class $DeadwoodMultipleCopyWith<$Res> implements $OpponentPenaltyCopyWith<$Res> {
  factory $DeadwoodMultipleCopyWith(DeadwoodMultiple value, $Res Function(DeadwoodMultiple) _then) = _$DeadwoodMultipleCopyWithImpl;
@useResult
$Res call({
 int multiplier
});




}
/// @nodoc
class _$DeadwoodMultipleCopyWithImpl<$Res>
    implements $DeadwoodMultipleCopyWith<$Res> {
  _$DeadwoodMultipleCopyWithImpl(this._self, this._then);

  final DeadwoodMultiple _self;
  final $Res Function(DeadwoodMultiple) _then;

/// Create a copy of OpponentPenalty
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? multiplier = null,}) {
  return _then(DeadwoodMultiple(
multiplier: null == multiplier ? _self.multiplier : multiplier // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class FlatPenalty extends OpponentPenalty {
  const FlatPenalty({required this.points, final  String? $type}): $type = $type ?? 'flat',super._();
  factory FlatPenalty.fromJson(Map<String, dynamic> json) => _$FlatPenaltyFromJson(json);

 final  int points;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of OpponentPenalty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlatPenaltyCopyWith<FlatPenalty> get copyWith => _$FlatPenaltyCopyWithImpl<FlatPenalty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlatPenaltyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlatPenalty&&(identical(other.points, points) || other.points == points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,points);

@override
String toString() {
  return 'OpponentPenalty.flat(points: $points)';
}


}

/// @nodoc
abstract mixin class $FlatPenaltyCopyWith<$Res> implements $OpponentPenaltyCopyWith<$Res> {
  factory $FlatPenaltyCopyWith(FlatPenalty value, $Res Function(FlatPenalty) _then) = _$FlatPenaltyCopyWithImpl;
@useResult
$Res call({
 int points
});




}
/// @nodoc
class _$FlatPenaltyCopyWithImpl<$Res>
    implements $FlatPenaltyCopyWith<$Res> {
  _$FlatPenaltyCopyWithImpl(this._self, this._then);

  final FlatPenalty _self;
  final $Res Function(FlatPenalty) _then;

/// Create a copy of OpponentPenalty
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? points = null,}) {
  return _then(FlatPenalty(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ScoringRow {

 int? get winnerPoints; OpponentPenalty get opened; OpponentPenalty get notOpened;
/// Create a copy of ScoringRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoringRowCopyWith<ScoringRow> get copyWith => _$ScoringRowCopyWithImpl<ScoringRow>(this as ScoringRow, _$identity);

  /// Serializes this ScoringRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoringRow&&(identical(other.winnerPoints, winnerPoints) || other.winnerPoints == winnerPoints)&&(identical(other.opened, opened) || other.opened == opened)&&(identical(other.notOpened, notOpened) || other.notOpened == notOpened));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,winnerPoints,opened,notOpened);

@override
String toString() {
  return 'ScoringRow(winnerPoints: $winnerPoints, opened: $opened, notOpened: $notOpened)';
}


}

/// @nodoc
abstract mixin class $ScoringRowCopyWith<$Res>  {
  factory $ScoringRowCopyWith(ScoringRow value, $Res Function(ScoringRow) _then) = _$ScoringRowCopyWithImpl;
@useResult
$Res call({
 int? winnerPoints, OpponentPenalty opened, OpponentPenalty notOpened
});


$OpponentPenaltyCopyWith<$Res> get opened;$OpponentPenaltyCopyWith<$Res> get notOpened;

}
/// @nodoc
class _$ScoringRowCopyWithImpl<$Res>
    implements $ScoringRowCopyWith<$Res> {
  _$ScoringRowCopyWithImpl(this._self, this._then);

  final ScoringRow _self;
  final $Res Function(ScoringRow) _then;

/// Create a copy of ScoringRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? winnerPoints = freezed,Object? opened = null,Object? notOpened = null,}) {
  return _then(_self.copyWith(
winnerPoints: freezed == winnerPoints ? _self.winnerPoints : winnerPoints // ignore: cast_nullable_to_non_nullable
as int?,opened: null == opened ? _self.opened : opened // ignore: cast_nullable_to_non_nullable
as OpponentPenalty,notOpened: null == notOpened ? _self.notOpened : notOpened // ignore: cast_nullable_to_non_nullable
as OpponentPenalty,
  ));
}
/// Create a copy of ScoringRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpponentPenaltyCopyWith<$Res> get opened {
  
  return $OpponentPenaltyCopyWith<$Res>(_self.opened, (value) {
    return _then(_self.copyWith(opened: value));
  });
}/// Create a copy of ScoringRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpponentPenaltyCopyWith<$Res> get notOpened {
  
  return $OpponentPenaltyCopyWith<$Res>(_self.notOpened, (value) {
    return _then(_self.copyWith(notOpened: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScoringRow].
extension ScoringRowPatterns on ScoringRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScoringRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoringRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScoringRow value)  $default,){
final _that = this;
switch (_that) {
case _ScoringRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScoringRow value)?  $default,){
final _that = this;
switch (_that) {
case _ScoringRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? winnerPoints,  OpponentPenalty opened,  OpponentPenalty notOpened)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoringRow() when $default != null:
return $default(_that.winnerPoints,_that.opened,_that.notOpened);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? winnerPoints,  OpponentPenalty opened,  OpponentPenalty notOpened)  $default,) {final _that = this;
switch (_that) {
case _ScoringRow():
return $default(_that.winnerPoints,_that.opened,_that.notOpened);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? winnerPoints,  OpponentPenalty opened,  OpponentPenalty notOpened)?  $default,) {final _that = this;
switch (_that) {
case _ScoringRow() when $default != null:
return $default(_that.winnerPoints,_that.opened,_that.notOpened);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScoringRow extends ScoringRow {
  const _ScoringRow({required this.winnerPoints, required this.opened, required this.notOpened}): super._();
  factory _ScoringRow.fromJson(Map<String, dynamic> json) => _$ScoringRowFromJson(json);

@override final  int? winnerPoints;
@override final  OpponentPenalty opened;
@override final  OpponentPenalty notOpened;

/// Create a copy of ScoringRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoringRowCopyWith<_ScoringRow> get copyWith => __$ScoringRowCopyWithImpl<_ScoringRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScoringRowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoringRow&&(identical(other.winnerPoints, winnerPoints) || other.winnerPoints == winnerPoints)&&(identical(other.opened, opened) || other.opened == opened)&&(identical(other.notOpened, notOpened) || other.notOpened == notOpened));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,winnerPoints,opened,notOpened);

@override
String toString() {
  return 'ScoringRow(winnerPoints: $winnerPoints, opened: $opened, notOpened: $notOpened)';
}


}

/// @nodoc
abstract mixin class _$ScoringRowCopyWith<$Res> implements $ScoringRowCopyWith<$Res> {
  factory _$ScoringRowCopyWith(_ScoringRow value, $Res Function(_ScoringRow) _then) = __$ScoringRowCopyWithImpl;
@override @useResult
$Res call({
 int? winnerPoints, OpponentPenalty opened, OpponentPenalty notOpened
});


@override $OpponentPenaltyCopyWith<$Res> get opened;@override $OpponentPenaltyCopyWith<$Res> get notOpened;

}
/// @nodoc
class __$ScoringRowCopyWithImpl<$Res>
    implements _$ScoringRowCopyWith<$Res> {
  __$ScoringRowCopyWithImpl(this._self, this._then);

  final _ScoringRow _self;
  final $Res Function(_ScoringRow) _then;

/// Create a copy of ScoringRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? winnerPoints = freezed,Object? opened = null,Object? notOpened = null,}) {
  return _then(_ScoringRow(
winnerPoints: freezed == winnerPoints ? _self.winnerPoints : winnerPoints // ignore: cast_nullable_to_non_nullable
as int?,opened: null == opened ? _self.opened : opened // ignore: cast_nullable_to_non_nullable
as OpponentPenalty,notOpened: null == notOpened ? _self.notOpened : notOpened // ignore: cast_nullable_to_non_nullable
as OpponentPenalty,
  ));
}

/// Create a copy of ScoringRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpponentPenaltyCopyWith<$Res> get opened {
  
  return $OpponentPenaltyCopyWith<$Res>(_self.opened, (value) {
    return _then(_self.copyWith(opened: value));
  });
}/// Create a copy of ScoringRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpponentPenaltyCopyWith<$Res> get notOpened {
  
  return $OpponentPenaltyCopyWith<$Res>(_self.notOpened, (value) {
    return _then(_self.copyWith(notOpened: value));
  });
}
}


/// @nodoc
mixin _$ScoringTable {

 ScoringRow get normal; ScoringRow get head; ScoringRow get pairs; ScoringRow get withOkey; ScoringRow get okeyHead; ScoringRow get pairsWithOkey;/// Draw pile exhausted with nobody going out. There is no winner, so no
/// winner bonus; and because the flat never-opened penalty is the price of
/// failing to open *while someone else won*, with no winner there is nobody
/// to have lost to. Everyone simply writes their deadwood once. Modelling
/// it as a row is what removes the `if` from ScoreCalculator.
 ScoringRow get exhausted;
/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoringTableCopyWith<ScoringTable> get copyWith => _$ScoringTableCopyWithImpl<ScoringTable>(this as ScoringTable, _$identity);

  /// Serializes this ScoringTable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoringTable&&(identical(other.normal, normal) || other.normal == normal)&&(identical(other.head, head) || other.head == head)&&(identical(other.pairs, pairs) || other.pairs == pairs)&&(identical(other.withOkey, withOkey) || other.withOkey == withOkey)&&(identical(other.okeyHead, okeyHead) || other.okeyHead == okeyHead)&&(identical(other.pairsWithOkey, pairsWithOkey) || other.pairsWithOkey == pairsWithOkey)&&(identical(other.exhausted, exhausted) || other.exhausted == exhausted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,normal,head,pairs,withOkey,okeyHead,pairsWithOkey,exhausted);

@override
String toString() {
  return 'ScoringTable(normal: $normal, head: $head, pairs: $pairs, withOkey: $withOkey, okeyHead: $okeyHead, pairsWithOkey: $pairsWithOkey, exhausted: $exhausted)';
}


}

/// @nodoc
abstract mixin class $ScoringTableCopyWith<$Res>  {
  factory $ScoringTableCopyWith(ScoringTable value, $Res Function(ScoringTable) _then) = _$ScoringTableCopyWithImpl;
@useResult
$Res call({
 ScoringRow normal, ScoringRow head, ScoringRow pairs, ScoringRow withOkey, ScoringRow okeyHead, ScoringRow pairsWithOkey, ScoringRow exhausted
});


$ScoringRowCopyWith<$Res> get normal;$ScoringRowCopyWith<$Res> get head;$ScoringRowCopyWith<$Res> get pairs;$ScoringRowCopyWith<$Res> get withOkey;$ScoringRowCopyWith<$Res> get okeyHead;$ScoringRowCopyWith<$Res> get pairsWithOkey;$ScoringRowCopyWith<$Res> get exhausted;

}
/// @nodoc
class _$ScoringTableCopyWithImpl<$Res>
    implements $ScoringTableCopyWith<$Res> {
  _$ScoringTableCopyWithImpl(this._self, this._then);

  final ScoringTable _self;
  final $Res Function(ScoringTable) _then;

/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? normal = null,Object? head = null,Object? pairs = null,Object? withOkey = null,Object? okeyHead = null,Object? pairsWithOkey = null,Object? exhausted = null,}) {
  return _then(_self.copyWith(
normal: null == normal ? _self.normal : normal // ignore: cast_nullable_to_non_nullable
as ScoringRow,head: null == head ? _self.head : head // ignore: cast_nullable_to_non_nullable
as ScoringRow,pairs: null == pairs ? _self.pairs : pairs // ignore: cast_nullable_to_non_nullable
as ScoringRow,withOkey: null == withOkey ? _self.withOkey : withOkey // ignore: cast_nullable_to_non_nullable
as ScoringRow,okeyHead: null == okeyHead ? _self.okeyHead : okeyHead // ignore: cast_nullable_to_non_nullable
as ScoringRow,pairsWithOkey: null == pairsWithOkey ? _self.pairsWithOkey : pairsWithOkey // ignore: cast_nullable_to_non_nullable
as ScoringRow,exhausted: null == exhausted ? _self.exhausted : exhausted // ignore: cast_nullable_to_non_nullable
as ScoringRow,
  ));
}
/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringRowCopyWith<$Res> get normal {
  
  return $ScoringRowCopyWith<$Res>(_self.normal, (value) {
    return _then(_self.copyWith(normal: value));
  });
}/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringRowCopyWith<$Res> get head {
  
  return $ScoringRowCopyWith<$Res>(_self.head, (value) {
    return _then(_self.copyWith(head: value));
  });
}/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringRowCopyWith<$Res> get pairs {
  
  return $ScoringRowCopyWith<$Res>(_self.pairs, (value) {
    return _then(_self.copyWith(pairs: value));
  });
}/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringRowCopyWith<$Res> get withOkey {
  
  return $ScoringRowCopyWith<$Res>(_self.withOkey, (value) {
    return _then(_self.copyWith(withOkey: value));
  });
}/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringRowCopyWith<$Res> get okeyHead {
  
  return $ScoringRowCopyWith<$Res>(_self.okeyHead, (value) {
    return _then(_self.copyWith(okeyHead: value));
  });
}/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringRowCopyWith<$Res> get pairsWithOkey {
  
  return $ScoringRowCopyWith<$Res>(_self.pairsWithOkey, (value) {
    return _then(_self.copyWith(pairsWithOkey: value));
  });
}/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringRowCopyWith<$Res> get exhausted {
  
  return $ScoringRowCopyWith<$Res>(_self.exhausted, (value) {
    return _then(_self.copyWith(exhausted: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScoringTable].
extension ScoringTablePatterns on ScoringTable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScoringTable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoringTable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScoringTable value)  $default,){
final _that = this;
switch (_that) {
case _ScoringTable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScoringTable value)?  $default,){
final _that = this;
switch (_that) {
case _ScoringTable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ScoringRow normal,  ScoringRow head,  ScoringRow pairs,  ScoringRow withOkey,  ScoringRow okeyHead,  ScoringRow pairsWithOkey,  ScoringRow exhausted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoringTable() when $default != null:
return $default(_that.normal,_that.head,_that.pairs,_that.withOkey,_that.okeyHead,_that.pairsWithOkey,_that.exhausted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ScoringRow normal,  ScoringRow head,  ScoringRow pairs,  ScoringRow withOkey,  ScoringRow okeyHead,  ScoringRow pairsWithOkey,  ScoringRow exhausted)  $default,) {final _that = this;
switch (_that) {
case _ScoringTable():
return $default(_that.normal,_that.head,_that.pairs,_that.withOkey,_that.okeyHead,_that.pairsWithOkey,_that.exhausted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ScoringRow normal,  ScoringRow head,  ScoringRow pairs,  ScoringRow withOkey,  ScoringRow okeyHead,  ScoringRow pairsWithOkey,  ScoringRow exhausted)?  $default,) {final _that = this;
switch (_that) {
case _ScoringTable() when $default != null:
return $default(_that.normal,_that.head,_that.pairs,_that.withOkey,_that.okeyHead,_that.pairsWithOkey,_that.exhausted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScoringTable extends ScoringTable {
  const _ScoringTable({this.normal = const ScoringRow(winnerPoints: -101, opened: OpponentPenalty.deadwoodMultiple(multiplier: 1), notOpened: OpponentPenalty.flat(points: 202)), this.head = const ScoringRow(winnerPoints: -202, opened: OpponentPenalty.deadwoodMultiple(multiplier: 1), notOpened: OpponentPenalty.flat(points: 404)), this.pairs = const ScoringRow(winnerPoints: -202, opened: OpponentPenalty.deadwoodMultiple(multiplier: 2), notOpened: OpponentPenalty.flat(points: 404)), this.withOkey = const ScoringRow(winnerPoints: -202, opened: OpponentPenalty.deadwoodMultiple(multiplier: 2), notOpened: OpponentPenalty.flat(points: 404)), this.okeyHead = const ScoringRow(winnerPoints: -404, opened: OpponentPenalty.deadwoodMultiple(multiplier: 2), notOpened: OpponentPenalty.flat(points: 808)), this.pairsWithOkey = const ScoringRow(winnerPoints: -404, opened: OpponentPenalty.deadwoodMultiple(multiplier: 4), notOpened: OpponentPenalty.flat(points: 808)), this.exhausted = const ScoringRow(winnerPoints: null, opened: OpponentPenalty.deadwoodMultiple(multiplier: 1), notOpened: OpponentPenalty.deadwoodMultiple(multiplier: 1))}): super._();
  factory _ScoringTable.fromJson(Map<String, dynamic> json) => _$ScoringTableFromJson(json);

@override@JsonKey() final  ScoringRow normal;
@override@JsonKey() final  ScoringRow head;
@override@JsonKey() final  ScoringRow pairs;
@override@JsonKey() final  ScoringRow withOkey;
@override@JsonKey() final  ScoringRow okeyHead;
@override@JsonKey() final  ScoringRow pairsWithOkey;
/// Draw pile exhausted with nobody going out. There is no winner, so no
/// winner bonus; and because the flat never-opened penalty is the price of
/// failing to open *while someone else won*, with no winner there is nobody
/// to have lost to. Everyone simply writes their deadwood once. Modelling
/// it as a row is what removes the `if` from ScoreCalculator.
@override@JsonKey() final  ScoringRow exhausted;

/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoringTableCopyWith<_ScoringTable> get copyWith => __$ScoringTableCopyWithImpl<_ScoringTable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScoringTableToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoringTable&&(identical(other.normal, normal) || other.normal == normal)&&(identical(other.head, head) || other.head == head)&&(identical(other.pairs, pairs) || other.pairs == pairs)&&(identical(other.withOkey, withOkey) || other.withOkey == withOkey)&&(identical(other.okeyHead, okeyHead) || other.okeyHead == okeyHead)&&(identical(other.pairsWithOkey, pairsWithOkey) || other.pairsWithOkey == pairsWithOkey)&&(identical(other.exhausted, exhausted) || other.exhausted == exhausted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,normal,head,pairs,withOkey,okeyHead,pairsWithOkey,exhausted);

@override
String toString() {
  return 'ScoringTable(normal: $normal, head: $head, pairs: $pairs, withOkey: $withOkey, okeyHead: $okeyHead, pairsWithOkey: $pairsWithOkey, exhausted: $exhausted)';
}


}

/// @nodoc
abstract mixin class _$ScoringTableCopyWith<$Res> implements $ScoringTableCopyWith<$Res> {
  factory _$ScoringTableCopyWith(_ScoringTable value, $Res Function(_ScoringTable) _then) = __$ScoringTableCopyWithImpl;
@override @useResult
$Res call({
 ScoringRow normal, ScoringRow head, ScoringRow pairs, ScoringRow withOkey, ScoringRow okeyHead, ScoringRow pairsWithOkey, ScoringRow exhausted
});


@override $ScoringRowCopyWith<$Res> get normal;@override $ScoringRowCopyWith<$Res> get head;@override $ScoringRowCopyWith<$Res> get pairs;@override $ScoringRowCopyWith<$Res> get withOkey;@override $ScoringRowCopyWith<$Res> get okeyHead;@override $ScoringRowCopyWith<$Res> get pairsWithOkey;@override $ScoringRowCopyWith<$Res> get exhausted;

}
/// @nodoc
class __$ScoringTableCopyWithImpl<$Res>
    implements _$ScoringTableCopyWith<$Res> {
  __$ScoringTableCopyWithImpl(this._self, this._then);

  final _ScoringTable _self;
  final $Res Function(_ScoringTable) _then;

/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? normal = null,Object? head = null,Object? pairs = null,Object? withOkey = null,Object? okeyHead = null,Object? pairsWithOkey = null,Object? exhausted = null,}) {
  return _then(_ScoringTable(
normal: null == normal ? _self.normal : normal // ignore: cast_nullable_to_non_nullable
as ScoringRow,head: null == head ? _self.head : head // ignore: cast_nullable_to_non_nullable
as ScoringRow,pairs: null == pairs ? _self.pairs : pairs // ignore: cast_nullable_to_non_nullable
as ScoringRow,withOkey: null == withOkey ? _self.withOkey : withOkey // ignore: cast_nullable_to_non_nullable
as ScoringRow,okeyHead: null == okeyHead ? _self.okeyHead : okeyHead // ignore: cast_nullable_to_non_nullable
as ScoringRow,pairsWithOkey: null == pairsWithOkey ? _self.pairsWithOkey : pairsWithOkey // ignore: cast_nullable_to_non_nullable
as ScoringRow,exhausted: null == exhausted ? _self.exhausted : exhausted // ignore: cast_nullable_to_non_nullable
as ScoringRow,
  ));
}

/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringRowCopyWith<$Res> get normal {
  
  return $ScoringRowCopyWith<$Res>(_self.normal, (value) {
    return _then(_self.copyWith(normal: value));
  });
}/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringRowCopyWith<$Res> get head {
  
  return $ScoringRowCopyWith<$Res>(_self.head, (value) {
    return _then(_self.copyWith(head: value));
  });
}/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringRowCopyWith<$Res> get pairs {
  
  return $ScoringRowCopyWith<$Res>(_self.pairs, (value) {
    return _then(_self.copyWith(pairs: value));
  });
}/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringRowCopyWith<$Res> get withOkey {
  
  return $ScoringRowCopyWith<$Res>(_self.withOkey, (value) {
    return _then(_self.copyWith(withOkey: value));
  });
}/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringRowCopyWith<$Res> get okeyHead {
  
  return $ScoringRowCopyWith<$Res>(_self.okeyHead, (value) {
    return _then(_self.copyWith(okeyHead: value));
  });
}/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringRowCopyWith<$Res> get pairsWithOkey {
  
  return $ScoringRowCopyWith<$Res>(_self.pairsWithOkey, (value) {
    return _then(_self.copyWith(pairsWithOkey: value));
  });
}/// Create a copy of ScoringTable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringRowCopyWith<$Res> get exhausted {
  
  return $ScoringRowCopyWith<$Res>(_self.exhausted, (value) {
    return _then(_self.copyWith(exhausted: value));
  });
}
}

// dart format on
