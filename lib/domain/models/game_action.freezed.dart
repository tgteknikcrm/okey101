// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
GameAction _$GameActionFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'draw_from_pile':
          return DrawFromPile.fromJson(
            json
          );
                case 'draw_from_discard':
          return DrawFromDiscard.fromJson(
            json
          );
                case 'discard':
          return DiscardTile.fromJson(
            json
          );
                case 'open':
          return OpenWithMelds.fromJson(
            json
          );
                case 'lay_pairs':
          return LayPairs.fromJson(
            json
          );
                case 'lay_meld':
          return LayNewMeld.fromJson(
            json
          );
                case 'add_to_meld':
          return AddToMeld.fromJson(
            json
          );
                case 'replace_joker':
          return ReplaceJoker.fromJson(
            json
          );
                case 'start_next_hand':
          return StartNextHand.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'GameAction',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$GameAction {



  /// Serializes this GameAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameAction);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameAction()';
}


}

/// @nodoc
class $GameActionCopyWith<$Res>  {
$GameActionCopyWith(GameAction _, $Res Function(GameAction) __);
}


/// Adds pattern-matching-related methods to [GameAction].
extension GameActionPatterns on GameAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DrawFromPile value)?  drawFromPile,TResult Function( DrawFromDiscard value)?  drawFromDiscard,TResult Function( DiscardTile value)?  discard,TResult Function( OpenWithMelds value)?  open,TResult Function( LayPairs value)?  layPairs,TResult Function( LayNewMeld value)?  layMeld,TResult Function( AddToMeld value)?  addToMeld,TResult Function( ReplaceJoker value)?  replaceJoker,TResult Function( StartNextHand value)?  startNextHand,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DrawFromPile() when drawFromPile != null:
return drawFromPile(_that);case DrawFromDiscard() when drawFromDiscard != null:
return drawFromDiscard(_that);case DiscardTile() when discard != null:
return discard(_that);case OpenWithMelds() when open != null:
return open(_that);case LayPairs() when layPairs != null:
return layPairs(_that);case LayNewMeld() when layMeld != null:
return layMeld(_that);case AddToMeld() when addToMeld != null:
return addToMeld(_that);case ReplaceJoker() when replaceJoker != null:
return replaceJoker(_that);case StartNextHand() when startNextHand != null:
return startNextHand(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DrawFromPile value)  drawFromPile,required TResult Function( DrawFromDiscard value)  drawFromDiscard,required TResult Function( DiscardTile value)  discard,required TResult Function( OpenWithMelds value)  open,required TResult Function( LayPairs value)  layPairs,required TResult Function( LayNewMeld value)  layMeld,required TResult Function( AddToMeld value)  addToMeld,required TResult Function( ReplaceJoker value)  replaceJoker,required TResult Function( StartNextHand value)  startNextHand,}){
final _that = this;
switch (_that) {
case DrawFromPile():
return drawFromPile(_that);case DrawFromDiscard():
return drawFromDiscard(_that);case DiscardTile():
return discard(_that);case OpenWithMelds():
return open(_that);case LayPairs():
return layPairs(_that);case LayNewMeld():
return layMeld(_that);case AddToMeld():
return addToMeld(_that);case ReplaceJoker():
return replaceJoker(_that);case StartNextHand():
return startNextHand(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DrawFromPile value)?  drawFromPile,TResult? Function( DrawFromDiscard value)?  drawFromDiscard,TResult? Function( DiscardTile value)?  discard,TResult? Function( OpenWithMelds value)?  open,TResult? Function( LayPairs value)?  layPairs,TResult? Function( LayNewMeld value)?  layMeld,TResult? Function( AddToMeld value)?  addToMeld,TResult? Function( ReplaceJoker value)?  replaceJoker,TResult? Function( StartNextHand value)?  startNextHand,}){
final _that = this;
switch (_that) {
case DrawFromPile() when drawFromPile != null:
return drawFromPile(_that);case DrawFromDiscard() when drawFromDiscard != null:
return drawFromDiscard(_that);case DiscardTile() when discard != null:
return discard(_that);case OpenWithMelds() when open != null:
return open(_that);case LayPairs() when layPairs != null:
return layPairs(_that);case LayNewMeld() when layMeld != null:
return layMeld(_that);case AddToMeld() when addToMeld != null:
return addToMeld(_that);case ReplaceJoker() when replaceJoker != null:
return replaceJoker(_that);case StartNextHand() when startNextHand != null:
return startNextHand(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  drawFromPile,TResult Function()?  drawFromDiscard,TResult Function( int tileId)?  discard,TResult Function( List<MeldProposal> melds)?  open,TResult Function( List<MeldProposal> pairs)?  layPairs,TResult Function( MeldProposal meld)?  layMeld,TResult Function( int meldId,  int tileId,  bool atStart)?  addToMeld,TResult Function( int meldId,  int index,  int tileId)?  replaceJoker,TResult Function()?  startNextHand,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DrawFromPile() when drawFromPile != null:
return drawFromPile();case DrawFromDiscard() when drawFromDiscard != null:
return drawFromDiscard();case DiscardTile() when discard != null:
return discard(_that.tileId);case OpenWithMelds() when open != null:
return open(_that.melds);case LayPairs() when layPairs != null:
return layPairs(_that.pairs);case LayNewMeld() when layMeld != null:
return layMeld(_that.meld);case AddToMeld() when addToMeld != null:
return addToMeld(_that.meldId,_that.tileId,_that.atStart);case ReplaceJoker() when replaceJoker != null:
return replaceJoker(_that.meldId,_that.index,_that.tileId);case StartNextHand() when startNextHand != null:
return startNextHand();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  drawFromPile,required TResult Function()  drawFromDiscard,required TResult Function( int tileId)  discard,required TResult Function( List<MeldProposal> melds)  open,required TResult Function( List<MeldProposal> pairs)  layPairs,required TResult Function( MeldProposal meld)  layMeld,required TResult Function( int meldId,  int tileId,  bool atStart)  addToMeld,required TResult Function( int meldId,  int index,  int tileId)  replaceJoker,required TResult Function()  startNextHand,}) {final _that = this;
switch (_that) {
case DrawFromPile():
return drawFromPile();case DrawFromDiscard():
return drawFromDiscard();case DiscardTile():
return discard(_that.tileId);case OpenWithMelds():
return open(_that.melds);case LayPairs():
return layPairs(_that.pairs);case LayNewMeld():
return layMeld(_that.meld);case AddToMeld():
return addToMeld(_that.meldId,_that.tileId,_that.atStart);case ReplaceJoker():
return replaceJoker(_that.meldId,_that.index,_that.tileId);case StartNextHand():
return startNextHand();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  drawFromPile,TResult? Function()?  drawFromDiscard,TResult? Function( int tileId)?  discard,TResult? Function( List<MeldProposal> melds)?  open,TResult? Function( List<MeldProposal> pairs)?  layPairs,TResult? Function( MeldProposal meld)?  layMeld,TResult? Function( int meldId,  int tileId,  bool atStart)?  addToMeld,TResult? Function( int meldId,  int index,  int tileId)?  replaceJoker,TResult? Function()?  startNextHand,}) {final _that = this;
switch (_that) {
case DrawFromPile() when drawFromPile != null:
return drawFromPile();case DrawFromDiscard() when drawFromDiscard != null:
return drawFromDiscard();case DiscardTile() when discard != null:
return discard(_that.tileId);case OpenWithMelds() when open != null:
return open(_that.melds);case LayPairs() when layPairs != null:
return layPairs(_that.pairs);case LayNewMeld() when layMeld != null:
return layMeld(_that.meld);case AddToMeld() when addToMeld != null:
return addToMeld(_that.meldId,_that.tileId,_that.atStart);case ReplaceJoker() when replaceJoker != null:
return replaceJoker(_that.meldId,_that.index,_that.tileId);case StartNextHand() when startNextHand != null:
return startNextHand();case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class DrawFromPile extends GameAction {
  const DrawFromPile({final  String? $type}): $type = $type ?? 'draw_from_pile',super._();
  factory DrawFromPile.fromJson(Map<String, dynamic> json) => _$DrawFromPileFromJson(json);



@JsonKey(name: 'type')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$DrawFromPileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrawFromPile);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameAction.drawFromPile()';
}


}




/// @nodoc
@JsonSerializable()

class DrawFromDiscard extends GameAction {
  const DrawFromDiscard({final  String? $type}): $type = $type ?? 'draw_from_discard',super._();
  factory DrawFromDiscard.fromJson(Map<String, dynamic> json) => _$DrawFromDiscardFromJson(json);



@JsonKey(name: 'type')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$DrawFromDiscardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrawFromDiscard);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameAction.drawFromDiscard()';
}


}




/// @nodoc
@JsonSerializable()

class DiscardTile extends GameAction {
  const DiscardTile({required this.tileId, final  String? $type}): $type = $type ?? 'discard',super._();
  factory DiscardTile.fromJson(Map<String, dynamic> json) => _$DiscardTileFromJson(json);

 final  int tileId;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscardTileCopyWith<DiscardTile> get copyWith => _$DiscardTileCopyWithImpl<DiscardTile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiscardTileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscardTile&&(identical(other.tileId, tileId) || other.tileId == tileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tileId);

@override
String toString() {
  return 'GameAction.discard(tileId: $tileId)';
}


}

/// @nodoc
abstract mixin class $DiscardTileCopyWith<$Res> implements $GameActionCopyWith<$Res> {
  factory $DiscardTileCopyWith(DiscardTile value, $Res Function(DiscardTile) _then) = _$DiscardTileCopyWithImpl;
@useResult
$Res call({
 int tileId
});




}
/// @nodoc
class _$DiscardTileCopyWithImpl<$Res>
    implements $DiscardTileCopyWith<$Res> {
  _$DiscardTileCopyWithImpl(this._self, this._then);

  final DiscardTile _self;
  final $Res Function(DiscardTile) _then;

/// Create a copy of GameAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tileId = null,}) {
  return _then(DiscardTile(
tileId: null == tileId ? _self.tileId : tileId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class OpenWithMelds extends GameAction {
  const OpenWithMelds({required final  List<MeldProposal> melds, final  String? $type}): _melds = melds,$type = $type ?? 'open',super._();
  factory OpenWithMelds.fromJson(Map<String, dynamic> json) => _$OpenWithMeldsFromJson(json);

 final  List<MeldProposal> _melds;
 List<MeldProposal> get melds {
  if (_melds is EqualUnmodifiableListView) return _melds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_melds);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenWithMeldsCopyWith<OpenWithMelds> get copyWith => _$OpenWithMeldsCopyWithImpl<OpenWithMelds>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpenWithMeldsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenWithMelds&&const DeepCollectionEquality().equals(other._melds, _melds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_melds));

@override
String toString() {
  return 'GameAction.open(melds: $melds)';
}


}

/// @nodoc
abstract mixin class $OpenWithMeldsCopyWith<$Res> implements $GameActionCopyWith<$Res> {
  factory $OpenWithMeldsCopyWith(OpenWithMelds value, $Res Function(OpenWithMelds) _then) = _$OpenWithMeldsCopyWithImpl;
@useResult
$Res call({
 List<MeldProposal> melds
});




}
/// @nodoc
class _$OpenWithMeldsCopyWithImpl<$Res>
    implements $OpenWithMeldsCopyWith<$Res> {
  _$OpenWithMeldsCopyWithImpl(this._self, this._then);

  final OpenWithMelds _self;
  final $Res Function(OpenWithMelds) _then;

/// Create a copy of GameAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? melds = null,}) {
  return _then(OpenWithMelds(
melds: null == melds ? _self._melds : melds // ignore: cast_nullable_to_non_nullable
as List<MeldProposal>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class LayPairs extends GameAction {
  const LayPairs({required final  List<MeldProposal> pairs, final  String? $type}): _pairs = pairs,$type = $type ?? 'lay_pairs',super._();
  factory LayPairs.fromJson(Map<String, dynamic> json) => _$LayPairsFromJson(json);

 final  List<MeldProposal> _pairs;
 List<MeldProposal> get pairs {
  if (_pairs is EqualUnmodifiableListView) return _pairs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pairs);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayPairsCopyWith<LayPairs> get copyWith => _$LayPairsCopyWithImpl<LayPairs>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LayPairsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayPairs&&const DeepCollectionEquality().equals(other._pairs, _pairs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_pairs));

@override
String toString() {
  return 'GameAction.layPairs(pairs: $pairs)';
}


}

/// @nodoc
abstract mixin class $LayPairsCopyWith<$Res> implements $GameActionCopyWith<$Res> {
  factory $LayPairsCopyWith(LayPairs value, $Res Function(LayPairs) _then) = _$LayPairsCopyWithImpl;
@useResult
$Res call({
 List<MeldProposal> pairs
});




}
/// @nodoc
class _$LayPairsCopyWithImpl<$Res>
    implements $LayPairsCopyWith<$Res> {
  _$LayPairsCopyWithImpl(this._self, this._then);

  final LayPairs _self;
  final $Res Function(LayPairs) _then;

/// Create a copy of GameAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pairs = null,}) {
  return _then(LayPairs(
pairs: null == pairs ? _self._pairs : pairs // ignore: cast_nullable_to_non_nullable
as List<MeldProposal>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class LayNewMeld extends GameAction {
  const LayNewMeld({required this.meld, final  String? $type}): $type = $type ?? 'lay_meld',super._();
  factory LayNewMeld.fromJson(Map<String, dynamic> json) => _$LayNewMeldFromJson(json);

 final  MeldProposal meld;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LayNewMeldCopyWith<LayNewMeld> get copyWith => _$LayNewMeldCopyWithImpl<LayNewMeld>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LayNewMeldToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LayNewMeld&&(identical(other.meld, meld) || other.meld == meld));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,meld);

@override
String toString() {
  return 'GameAction.layMeld(meld: $meld)';
}


}

/// @nodoc
abstract mixin class $LayNewMeldCopyWith<$Res> implements $GameActionCopyWith<$Res> {
  factory $LayNewMeldCopyWith(LayNewMeld value, $Res Function(LayNewMeld) _then) = _$LayNewMeldCopyWithImpl;
@useResult
$Res call({
 MeldProposal meld
});


$MeldProposalCopyWith<$Res> get meld;

}
/// @nodoc
class _$LayNewMeldCopyWithImpl<$Res>
    implements $LayNewMeldCopyWith<$Res> {
  _$LayNewMeldCopyWithImpl(this._self, this._then);

  final LayNewMeld _self;
  final $Res Function(LayNewMeld) _then;

/// Create a copy of GameAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? meld = null,}) {
  return _then(LayNewMeld(
meld: null == meld ? _self.meld : meld // ignore: cast_nullable_to_non_nullable
as MeldProposal,
  ));
}

/// Create a copy of GameAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeldProposalCopyWith<$Res> get meld {
  
  return $MeldProposalCopyWith<$Res>(_self.meld, (value) {
    return _then(_self.copyWith(meld: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class AddToMeld extends GameAction {
  const AddToMeld({required this.meldId, required this.tileId, this.atStart = false, final  String? $type}): $type = $type ?? 'add_to_meld',super._();
  factory AddToMeld.fromJson(Map<String, dynamic> json) => _$AddToMeldFromJson(json);

 final  int meldId;
 final  int tileId;
@JsonKey() final  bool atStart;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddToMeldCopyWith<AddToMeld> get copyWith => _$AddToMeldCopyWithImpl<AddToMeld>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddToMeldToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddToMeld&&(identical(other.meldId, meldId) || other.meldId == meldId)&&(identical(other.tileId, tileId) || other.tileId == tileId)&&(identical(other.atStart, atStart) || other.atStart == atStart));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,meldId,tileId,atStart);

@override
String toString() {
  return 'GameAction.addToMeld(meldId: $meldId, tileId: $tileId, atStart: $atStart)';
}


}

/// @nodoc
abstract mixin class $AddToMeldCopyWith<$Res> implements $GameActionCopyWith<$Res> {
  factory $AddToMeldCopyWith(AddToMeld value, $Res Function(AddToMeld) _then) = _$AddToMeldCopyWithImpl;
@useResult
$Res call({
 int meldId, int tileId, bool atStart
});




}
/// @nodoc
class _$AddToMeldCopyWithImpl<$Res>
    implements $AddToMeldCopyWith<$Res> {
  _$AddToMeldCopyWithImpl(this._self, this._then);

  final AddToMeld _self;
  final $Res Function(AddToMeld) _then;

/// Create a copy of GameAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? meldId = null,Object? tileId = null,Object? atStart = null,}) {
  return _then(AddToMeld(
meldId: null == meldId ? _self.meldId : meldId // ignore: cast_nullable_to_non_nullable
as int,tileId: null == tileId ? _self.tileId : tileId // ignore: cast_nullable_to_non_nullable
as int,atStart: null == atStart ? _self.atStart : atStart // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ReplaceJoker extends GameAction {
  const ReplaceJoker({required this.meldId, required this.index, required this.tileId, final  String? $type}): $type = $type ?? 'replace_joker',super._();
  factory ReplaceJoker.fromJson(Map<String, dynamic> json) => _$ReplaceJokerFromJson(json);

 final  int meldId;
 final  int index;
 final  int tileId;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReplaceJokerCopyWith<ReplaceJoker> get copyWith => _$ReplaceJokerCopyWithImpl<ReplaceJoker>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReplaceJokerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReplaceJoker&&(identical(other.meldId, meldId) || other.meldId == meldId)&&(identical(other.index, index) || other.index == index)&&(identical(other.tileId, tileId) || other.tileId == tileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,meldId,index,tileId);

@override
String toString() {
  return 'GameAction.replaceJoker(meldId: $meldId, index: $index, tileId: $tileId)';
}


}

/// @nodoc
abstract mixin class $ReplaceJokerCopyWith<$Res> implements $GameActionCopyWith<$Res> {
  factory $ReplaceJokerCopyWith(ReplaceJoker value, $Res Function(ReplaceJoker) _then) = _$ReplaceJokerCopyWithImpl;
@useResult
$Res call({
 int meldId, int index, int tileId
});




}
/// @nodoc
class _$ReplaceJokerCopyWithImpl<$Res>
    implements $ReplaceJokerCopyWith<$Res> {
  _$ReplaceJokerCopyWithImpl(this._self, this._then);

  final ReplaceJoker _self;
  final $Res Function(ReplaceJoker) _then;

/// Create a copy of GameAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? meldId = null,Object? index = null,Object? tileId = null,}) {
  return _then(ReplaceJoker(
meldId: null == meldId ? _self.meldId : meldId // ignore: cast_nullable_to_non_nullable
as int,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,tileId: null == tileId ? _self.tileId : tileId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class StartNextHand extends GameAction {
  const StartNextHand({final  String? $type}): $type = $type ?? 'start_next_hand',super._();
  factory StartNextHand.fromJson(Map<String, dynamic> json) => _$StartNextHandFromJson(json);



@JsonKey(name: 'type')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$StartNextHandToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartNextHand);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameAction.startNextHand()';
}


}




// dart format on
