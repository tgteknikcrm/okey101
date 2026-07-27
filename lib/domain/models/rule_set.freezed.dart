// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rule_set.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RuleSet {

 RulePreset get preset;/// Minimum points that must go down in a single turn to open.
 int get openThreshold;/// "Katlamali acma": the n-th player to open in a hand needs
/// `openThreshold - 1 + n`. Resets at the start of every hand.
 bool get escalatingOpenThreshold;/// Only consulted in the faithful-simulation mode below. The normal UI and
/// engine validate before the player commits, so no penalty is ever
/// incurred by accident.
 int get illegalOpenPenalty;/// Faithful-simulation mode: allow an under-threshold open attempt to be
/// committed and punished instead of rejected. Off by default.
 bool get enforceIllegalOpenPenalty;/// 12-13-1 and 13-1-2 are invalid by default. This is the single most
/// commonly mis-implemented Okey 101 rule.
 bool get allowCircularRuns;/// A run laid on the table may not exceed this. The limit applies ONLY at
/// lay-down; a table run may be extended past it via addToMeld.
 int get maxRunLengthOnLayDown; int get maxJokersPerMeld; int get minPairsToOpen; int get pairsToFinish; bool get canLayNewMeldsAfterOpening; bool get canReplaceJokerOnTable; bool get canTakeDiscardBeforeOpening;/// An okey left on the rack scores this much deadwood. A false joker is not
/// wild, so it scores the indicator's number like any ordinary tile.
 int get okeyDeadwoodValue; DeckExhaustedPolicy get onDeckExhausted; ScoringTable get scoringTable; int get handsPerMatch; int get targetScore; MatchEndMode get matchEndMode; StartingPlayerRotation get startingPlayerRotation; FalseJokerIndicatorPolicy get falseJokerAsIndicator;
/// Create a copy of RuleSet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RuleSetCopyWith<RuleSet> get copyWith => _$RuleSetCopyWithImpl<RuleSet>(this as RuleSet, _$identity);

  /// Serializes this RuleSet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RuleSet&&(identical(other.preset, preset) || other.preset == preset)&&(identical(other.openThreshold, openThreshold) || other.openThreshold == openThreshold)&&(identical(other.escalatingOpenThreshold, escalatingOpenThreshold) || other.escalatingOpenThreshold == escalatingOpenThreshold)&&(identical(other.illegalOpenPenalty, illegalOpenPenalty) || other.illegalOpenPenalty == illegalOpenPenalty)&&(identical(other.enforceIllegalOpenPenalty, enforceIllegalOpenPenalty) || other.enforceIllegalOpenPenalty == enforceIllegalOpenPenalty)&&(identical(other.allowCircularRuns, allowCircularRuns) || other.allowCircularRuns == allowCircularRuns)&&(identical(other.maxRunLengthOnLayDown, maxRunLengthOnLayDown) || other.maxRunLengthOnLayDown == maxRunLengthOnLayDown)&&(identical(other.maxJokersPerMeld, maxJokersPerMeld) || other.maxJokersPerMeld == maxJokersPerMeld)&&(identical(other.minPairsToOpen, minPairsToOpen) || other.minPairsToOpen == minPairsToOpen)&&(identical(other.pairsToFinish, pairsToFinish) || other.pairsToFinish == pairsToFinish)&&(identical(other.canLayNewMeldsAfterOpening, canLayNewMeldsAfterOpening) || other.canLayNewMeldsAfterOpening == canLayNewMeldsAfterOpening)&&(identical(other.canReplaceJokerOnTable, canReplaceJokerOnTable) || other.canReplaceJokerOnTable == canReplaceJokerOnTable)&&(identical(other.canTakeDiscardBeforeOpening, canTakeDiscardBeforeOpening) || other.canTakeDiscardBeforeOpening == canTakeDiscardBeforeOpening)&&(identical(other.okeyDeadwoodValue, okeyDeadwoodValue) || other.okeyDeadwoodValue == okeyDeadwoodValue)&&(identical(other.onDeckExhausted, onDeckExhausted) || other.onDeckExhausted == onDeckExhausted)&&(identical(other.scoringTable, scoringTable) || other.scoringTable == scoringTable)&&(identical(other.handsPerMatch, handsPerMatch) || other.handsPerMatch == handsPerMatch)&&(identical(other.targetScore, targetScore) || other.targetScore == targetScore)&&(identical(other.matchEndMode, matchEndMode) || other.matchEndMode == matchEndMode)&&(identical(other.startingPlayerRotation, startingPlayerRotation) || other.startingPlayerRotation == startingPlayerRotation)&&(identical(other.falseJokerAsIndicator, falseJokerAsIndicator) || other.falseJokerAsIndicator == falseJokerAsIndicator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,preset,openThreshold,escalatingOpenThreshold,illegalOpenPenalty,enforceIllegalOpenPenalty,allowCircularRuns,maxRunLengthOnLayDown,maxJokersPerMeld,minPairsToOpen,pairsToFinish,canLayNewMeldsAfterOpening,canReplaceJokerOnTable,canTakeDiscardBeforeOpening,okeyDeadwoodValue,onDeckExhausted,scoringTable,handsPerMatch,targetScore,matchEndMode,startingPlayerRotation,falseJokerAsIndicator]);

@override
String toString() {
  return 'RuleSet(preset: $preset, openThreshold: $openThreshold, escalatingOpenThreshold: $escalatingOpenThreshold, illegalOpenPenalty: $illegalOpenPenalty, enforceIllegalOpenPenalty: $enforceIllegalOpenPenalty, allowCircularRuns: $allowCircularRuns, maxRunLengthOnLayDown: $maxRunLengthOnLayDown, maxJokersPerMeld: $maxJokersPerMeld, minPairsToOpen: $minPairsToOpen, pairsToFinish: $pairsToFinish, canLayNewMeldsAfterOpening: $canLayNewMeldsAfterOpening, canReplaceJokerOnTable: $canReplaceJokerOnTable, canTakeDiscardBeforeOpening: $canTakeDiscardBeforeOpening, okeyDeadwoodValue: $okeyDeadwoodValue, onDeckExhausted: $onDeckExhausted, scoringTable: $scoringTable, handsPerMatch: $handsPerMatch, targetScore: $targetScore, matchEndMode: $matchEndMode, startingPlayerRotation: $startingPlayerRotation, falseJokerAsIndicator: $falseJokerAsIndicator)';
}


}

/// @nodoc
abstract mixin class $RuleSetCopyWith<$Res>  {
  factory $RuleSetCopyWith(RuleSet value, $Res Function(RuleSet) _then) = _$RuleSetCopyWithImpl;
@useResult
$Res call({
 RulePreset preset, int openThreshold, bool escalatingOpenThreshold, int illegalOpenPenalty, bool enforceIllegalOpenPenalty, bool allowCircularRuns, int maxRunLengthOnLayDown, int maxJokersPerMeld, int minPairsToOpen, int pairsToFinish, bool canLayNewMeldsAfterOpening, bool canReplaceJokerOnTable, bool canTakeDiscardBeforeOpening, int okeyDeadwoodValue, DeckExhaustedPolicy onDeckExhausted, ScoringTable scoringTable, int handsPerMatch, int targetScore, MatchEndMode matchEndMode, StartingPlayerRotation startingPlayerRotation, FalseJokerIndicatorPolicy falseJokerAsIndicator
});


$ScoringTableCopyWith<$Res> get scoringTable;

}
/// @nodoc
class _$RuleSetCopyWithImpl<$Res>
    implements $RuleSetCopyWith<$Res> {
  _$RuleSetCopyWithImpl(this._self, this._then);

  final RuleSet _self;
  final $Res Function(RuleSet) _then;

/// Create a copy of RuleSet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? preset = null,Object? openThreshold = null,Object? escalatingOpenThreshold = null,Object? illegalOpenPenalty = null,Object? enforceIllegalOpenPenalty = null,Object? allowCircularRuns = null,Object? maxRunLengthOnLayDown = null,Object? maxJokersPerMeld = null,Object? minPairsToOpen = null,Object? pairsToFinish = null,Object? canLayNewMeldsAfterOpening = null,Object? canReplaceJokerOnTable = null,Object? canTakeDiscardBeforeOpening = null,Object? okeyDeadwoodValue = null,Object? onDeckExhausted = null,Object? scoringTable = null,Object? handsPerMatch = null,Object? targetScore = null,Object? matchEndMode = null,Object? startingPlayerRotation = null,Object? falseJokerAsIndicator = null,}) {
  return _then(_self.copyWith(
preset: null == preset ? _self.preset : preset // ignore: cast_nullable_to_non_nullable
as RulePreset,openThreshold: null == openThreshold ? _self.openThreshold : openThreshold // ignore: cast_nullable_to_non_nullable
as int,escalatingOpenThreshold: null == escalatingOpenThreshold ? _self.escalatingOpenThreshold : escalatingOpenThreshold // ignore: cast_nullable_to_non_nullable
as bool,illegalOpenPenalty: null == illegalOpenPenalty ? _self.illegalOpenPenalty : illegalOpenPenalty // ignore: cast_nullable_to_non_nullable
as int,enforceIllegalOpenPenalty: null == enforceIllegalOpenPenalty ? _self.enforceIllegalOpenPenalty : enforceIllegalOpenPenalty // ignore: cast_nullable_to_non_nullable
as bool,allowCircularRuns: null == allowCircularRuns ? _self.allowCircularRuns : allowCircularRuns // ignore: cast_nullable_to_non_nullable
as bool,maxRunLengthOnLayDown: null == maxRunLengthOnLayDown ? _self.maxRunLengthOnLayDown : maxRunLengthOnLayDown // ignore: cast_nullable_to_non_nullable
as int,maxJokersPerMeld: null == maxJokersPerMeld ? _self.maxJokersPerMeld : maxJokersPerMeld // ignore: cast_nullable_to_non_nullable
as int,minPairsToOpen: null == minPairsToOpen ? _self.minPairsToOpen : minPairsToOpen // ignore: cast_nullable_to_non_nullable
as int,pairsToFinish: null == pairsToFinish ? _self.pairsToFinish : pairsToFinish // ignore: cast_nullable_to_non_nullable
as int,canLayNewMeldsAfterOpening: null == canLayNewMeldsAfterOpening ? _self.canLayNewMeldsAfterOpening : canLayNewMeldsAfterOpening // ignore: cast_nullable_to_non_nullable
as bool,canReplaceJokerOnTable: null == canReplaceJokerOnTable ? _self.canReplaceJokerOnTable : canReplaceJokerOnTable // ignore: cast_nullable_to_non_nullable
as bool,canTakeDiscardBeforeOpening: null == canTakeDiscardBeforeOpening ? _self.canTakeDiscardBeforeOpening : canTakeDiscardBeforeOpening // ignore: cast_nullable_to_non_nullable
as bool,okeyDeadwoodValue: null == okeyDeadwoodValue ? _self.okeyDeadwoodValue : okeyDeadwoodValue // ignore: cast_nullable_to_non_nullable
as int,onDeckExhausted: null == onDeckExhausted ? _self.onDeckExhausted : onDeckExhausted // ignore: cast_nullable_to_non_nullable
as DeckExhaustedPolicy,scoringTable: null == scoringTable ? _self.scoringTable : scoringTable // ignore: cast_nullable_to_non_nullable
as ScoringTable,handsPerMatch: null == handsPerMatch ? _self.handsPerMatch : handsPerMatch // ignore: cast_nullable_to_non_nullable
as int,targetScore: null == targetScore ? _self.targetScore : targetScore // ignore: cast_nullable_to_non_nullable
as int,matchEndMode: null == matchEndMode ? _self.matchEndMode : matchEndMode // ignore: cast_nullable_to_non_nullable
as MatchEndMode,startingPlayerRotation: null == startingPlayerRotation ? _self.startingPlayerRotation : startingPlayerRotation // ignore: cast_nullable_to_non_nullable
as StartingPlayerRotation,falseJokerAsIndicator: null == falseJokerAsIndicator ? _self.falseJokerAsIndicator : falseJokerAsIndicator // ignore: cast_nullable_to_non_nullable
as FalseJokerIndicatorPolicy,
  ));
}
/// Create a copy of RuleSet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringTableCopyWith<$Res> get scoringTable {
  
  return $ScoringTableCopyWith<$Res>(_self.scoringTable, (value) {
    return _then(_self.copyWith(scoringTable: value));
  });
}
}


/// Adds pattern-matching-related methods to [RuleSet].
extension RuleSetPatterns on RuleSet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RuleSet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RuleSet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RuleSet value)  $default,){
final _that = this;
switch (_that) {
case _RuleSet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RuleSet value)?  $default,){
final _that = this;
switch (_that) {
case _RuleSet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RulePreset preset,  int openThreshold,  bool escalatingOpenThreshold,  int illegalOpenPenalty,  bool enforceIllegalOpenPenalty,  bool allowCircularRuns,  int maxRunLengthOnLayDown,  int maxJokersPerMeld,  int minPairsToOpen,  int pairsToFinish,  bool canLayNewMeldsAfterOpening,  bool canReplaceJokerOnTable,  bool canTakeDiscardBeforeOpening,  int okeyDeadwoodValue,  DeckExhaustedPolicy onDeckExhausted,  ScoringTable scoringTable,  int handsPerMatch,  int targetScore,  MatchEndMode matchEndMode,  StartingPlayerRotation startingPlayerRotation,  FalseJokerIndicatorPolicy falseJokerAsIndicator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RuleSet() when $default != null:
return $default(_that.preset,_that.openThreshold,_that.escalatingOpenThreshold,_that.illegalOpenPenalty,_that.enforceIllegalOpenPenalty,_that.allowCircularRuns,_that.maxRunLengthOnLayDown,_that.maxJokersPerMeld,_that.minPairsToOpen,_that.pairsToFinish,_that.canLayNewMeldsAfterOpening,_that.canReplaceJokerOnTable,_that.canTakeDiscardBeforeOpening,_that.okeyDeadwoodValue,_that.onDeckExhausted,_that.scoringTable,_that.handsPerMatch,_that.targetScore,_that.matchEndMode,_that.startingPlayerRotation,_that.falseJokerAsIndicator);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RulePreset preset,  int openThreshold,  bool escalatingOpenThreshold,  int illegalOpenPenalty,  bool enforceIllegalOpenPenalty,  bool allowCircularRuns,  int maxRunLengthOnLayDown,  int maxJokersPerMeld,  int minPairsToOpen,  int pairsToFinish,  bool canLayNewMeldsAfterOpening,  bool canReplaceJokerOnTable,  bool canTakeDiscardBeforeOpening,  int okeyDeadwoodValue,  DeckExhaustedPolicy onDeckExhausted,  ScoringTable scoringTable,  int handsPerMatch,  int targetScore,  MatchEndMode matchEndMode,  StartingPlayerRotation startingPlayerRotation,  FalseJokerIndicatorPolicy falseJokerAsIndicator)  $default,) {final _that = this;
switch (_that) {
case _RuleSet():
return $default(_that.preset,_that.openThreshold,_that.escalatingOpenThreshold,_that.illegalOpenPenalty,_that.enforceIllegalOpenPenalty,_that.allowCircularRuns,_that.maxRunLengthOnLayDown,_that.maxJokersPerMeld,_that.minPairsToOpen,_that.pairsToFinish,_that.canLayNewMeldsAfterOpening,_that.canReplaceJokerOnTable,_that.canTakeDiscardBeforeOpening,_that.okeyDeadwoodValue,_that.onDeckExhausted,_that.scoringTable,_that.handsPerMatch,_that.targetScore,_that.matchEndMode,_that.startingPlayerRotation,_that.falseJokerAsIndicator);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RulePreset preset,  int openThreshold,  bool escalatingOpenThreshold,  int illegalOpenPenalty,  bool enforceIllegalOpenPenalty,  bool allowCircularRuns,  int maxRunLengthOnLayDown,  int maxJokersPerMeld,  int minPairsToOpen,  int pairsToFinish,  bool canLayNewMeldsAfterOpening,  bool canReplaceJokerOnTable,  bool canTakeDiscardBeforeOpening,  int okeyDeadwoodValue,  DeckExhaustedPolicy onDeckExhausted,  ScoringTable scoringTable,  int handsPerMatch,  int targetScore,  MatchEndMode matchEndMode,  StartingPlayerRotation startingPlayerRotation,  FalseJokerIndicatorPolicy falseJokerAsIndicator)?  $default,) {final _that = this;
switch (_that) {
case _RuleSet() when $default != null:
return $default(_that.preset,_that.openThreshold,_that.escalatingOpenThreshold,_that.illegalOpenPenalty,_that.enforceIllegalOpenPenalty,_that.allowCircularRuns,_that.maxRunLengthOnLayDown,_that.maxJokersPerMeld,_that.minPairsToOpen,_that.pairsToFinish,_that.canLayNewMeldsAfterOpening,_that.canReplaceJokerOnTable,_that.canTakeDiscardBeforeOpening,_that.okeyDeadwoodValue,_that.onDeckExhausted,_that.scoringTable,_that.handsPerMatch,_that.targetScore,_that.matchEndMode,_that.startingPlayerRotation,_that.falseJokerAsIndicator);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RuleSet extends RuleSet {
  const _RuleSet({this.preset = RulePreset.standard, this.openThreshold = 101, this.escalatingOpenThreshold = false, this.illegalOpenPenalty = 101, this.enforceIllegalOpenPenalty = false, this.allowCircularRuns = false, this.maxRunLengthOnLayDown = 5, this.maxJokersPerMeld = 1, this.minPairsToOpen = 5, this.pairsToFinish = 11, this.canLayNewMeldsAfterOpening = true, this.canReplaceJokerOnTable = true, this.canTakeDiscardBeforeOpening = true, this.okeyDeadwoodValue = 25, this.onDeckExhausted = DeckExhaustedPolicy.scoreDeadwood, this.scoringTable = const ScoringTable(), this.handsPerMatch = 11, this.targetScore = -500, this.matchEndMode = MatchEndMode.both, this.startingPlayerRotation = StartingPlayerRotation.rotate, this.falseJokerAsIndicator = FalseJokerIndicatorPolicy.reshuffle}): super._();
  factory _RuleSet.fromJson(Map<String, dynamic> json) => _$RuleSetFromJson(json);

@override@JsonKey() final  RulePreset preset;
/// Minimum points that must go down in a single turn to open.
@override@JsonKey() final  int openThreshold;
/// "Katlamali acma": the n-th player to open in a hand needs
/// `openThreshold - 1 + n`. Resets at the start of every hand.
@override@JsonKey() final  bool escalatingOpenThreshold;
/// Only consulted in the faithful-simulation mode below. The normal UI and
/// engine validate before the player commits, so no penalty is ever
/// incurred by accident.
@override@JsonKey() final  int illegalOpenPenalty;
/// Faithful-simulation mode: allow an under-threshold open attempt to be
/// committed and punished instead of rejected. Off by default.
@override@JsonKey() final  bool enforceIllegalOpenPenalty;
/// 12-13-1 and 13-1-2 are invalid by default. This is the single most
/// commonly mis-implemented Okey 101 rule.
@override@JsonKey() final  bool allowCircularRuns;
/// A run laid on the table may not exceed this. The limit applies ONLY at
/// lay-down; a table run may be extended past it via addToMeld.
@override@JsonKey() final  int maxRunLengthOnLayDown;
@override@JsonKey() final  int maxJokersPerMeld;
@override@JsonKey() final  int minPairsToOpen;
@override@JsonKey() final  int pairsToFinish;
@override@JsonKey() final  bool canLayNewMeldsAfterOpening;
@override@JsonKey() final  bool canReplaceJokerOnTable;
@override@JsonKey() final  bool canTakeDiscardBeforeOpening;
/// An okey left on the rack scores this much deadwood. A false joker is not
/// wild, so it scores the indicator's number like any ordinary tile.
@override@JsonKey() final  int okeyDeadwoodValue;
@override@JsonKey() final  DeckExhaustedPolicy onDeckExhausted;
@override@JsonKey() final  ScoringTable scoringTable;
@override@JsonKey() final  int handsPerMatch;
@override@JsonKey() final  int targetScore;
@override@JsonKey() final  MatchEndMode matchEndMode;
@override@JsonKey() final  StartingPlayerRotation startingPlayerRotation;
@override@JsonKey() final  FalseJokerIndicatorPolicy falseJokerAsIndicator;

/// Create a copy of RuleSet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RuleSetCopyWith<_RuleSet> get copyWith => __$RuleSetCopyWithImpl<_RuleSet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RuleSetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RuleSet&&(identical(other.preset, preset) || other.preset == preset)&&(identical(other.openThreshold, openThreshold) || other.openThreshold == openThreshold)&&(identical(other.escalatingOpenThreshold, escalatingOpenThreshold) || other.escalatingOpenThreshold == escalatingOpenThreshold)&&(identical(other.illegalOpenPenalty, illegalOpenPenalty) || other.illegalOpenPenalty == illegalOpenPenalty)&&(identical(other.enforceIllegalOpenPenalty, enforceIllegalOpenPenalty) || other.enforceIllegalOpenPenalty == enforceIllegalOpenPenalty)&&(identical(other.allowCircularRuns, allowCircularRuns) || other.allowCircularRuns == allowCircularRuns)&&(identical(other.maxRunLengthOnLayDown, maxRunLengthOnLayDown) || other.maxRunLengthOnLayDown == maxRunLengthOnLayDown)&&(identical(other.maxJokersPerMeld, maxJokersPerMeld) || other.maxJokersPerMeld == maxJokersPerMeld)&&(identical(other.minPairsToOpen, minPairsToOpen) || other.minPairsToOpen == minPairsToOpen)&&(identical(other.pairsToFinish, pairsToFinish) || other.pairsToFinish == pairsToFinish)&&(identical(other.canLayNewMeldsAfterOpening, canLayNewMeldsAfterOpening) || other.canLayNewMeldsAfterOpening == canLayNewMeldsAfterOpening)&&(identical(other.canReplaceJokerOnTable, canReplaceJokerOnTable) || other.canReplaceJokerOnTable == canReplaceJokerOnTable)&&(identical(other.canTakeDiscardBeforeOpening, canTakeDiscardBeforeOpening) || other.canTakeDiscardBeforeOpening == canTakeDiscardBeforeOpening)&&(identical(other.okeyDeadwoodValue, okeyDeadwoodValue) || other.okeyDeadwoodValue == okeyDeadwoodValue)&&(identical(other.onDeckExhausted, onDeckExhausted) || other.onDeckExhausted == onDeckExhausted)&&(identical(other.scoringTable, scoringTable) || other.scoringTable == scoringTable)&&(identical(other.handsPerMatch, handsPerMatch) || other.handsPerMatch == handsPerMatch)&&(identical(other.targetScore, targetScore) || other.targetScore == targetScore)&&(identical(other.matchEndMode, matchEndMode) || other.matchEndMode == matchEndMode)&&(identical(other.startingPlayerRotation, startingPlayerRotation) || other.startingPlayerRotation == startingPlayerRotation)&&(identical(other.falseJokerAsIndicator, falseJokerAsIndicator) || other.falseJokerAsIndicator == falseJokerAsIndicator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,preset,openThreshold,escalatingOpenThreshold,illegalOpenPenalty,enforceIllegalOpenPenalty,allowCircularRuns,maxRunLengthOnLayDown,maxJokersPerMeld,minPairsToOpen,pairsToFinish,canLayNewMeldsAfterOpening,canReplaceJokerOnTable,canTakeDiscardBeforeOpening,okeyDeadwoodValue,onDeckExhausted,scoringTable,handsPerMatch,targetScore,matchEndMode,startingPlayerRotation,falseJokerAsIndicator]);

@override
String toString() {
  return 'RuleSet(preset: $preset, openThreshold: $openThreshold, escalatingOpenThreshold: $escalatingOpenThreshold, illegalOpenPenalty: $illegalOpenPenalty, enforceIllegalOpenPenalty: $enforceIllegalOpenPenalty, allowCircularRuns: $allowCircularRuns, maxRunLengthOnLayDown: $maxRunLengthOnLayDown, maxJokersPerMeld: $maxJokersPerMeld, minPairsToOpen: $minPairsToOpen, pairsToFinish: $pairsToFinish, canLayNewMeldsAfterOpening: $canLayNewMeldsAfterOpening, canReplaceJokerOnTable: $canReplaceJokerOnTable, canTakeDiscardBeforeOpening: $canTakeDiscardBeforeOpening, okeyDeadwoodValue: $okeyDeadwoodValue, onDeckExhausted: $onDeckExhausted, scoringTable: $scoringTable, handsPerMatch: $handsPerMatch, targetScore: $targetScore, matchEndMode: $matchEndMode, startingPlayerRotation: $startingPlayerRotation, falseJokerAsIndicator: $falseJokerAsIndicator)';
}


}

/// @nodoc
abstract mixin class _$RuleSetCopyWith<$Res> implements $RuleSetCopyWith<$Res> {
  factory _$RuleSetCopyWith(_RuleSet value, $Res Function(_RuleSet) _then) = __$RuleSetCopyWithImpl;
@override @useResult
$Res call({
 RulePreset preset, int openThreshold, bool escalatingOpenThreshold, int illegalOpenPenalty, bool enforceIllegalOpenPenalty, bool allowCircularRuns, int maxRunLengthOnLayDown, int maxJokersPerMeld, int minPairsToOpen, int pairsToFinish, bool canLayNewMeldsAfterOpening, bool canReplaceJokerOnTable, bool canTakeDiscardBeforeOpening, int okeyDeadwoodValue, DeckExhaustedPolicy onDeckExhausted, ScoringTable scoringTable, int handsPerMatch, int targetScore, MatchEndMode matchEndMode, StartingPlayerRotation startingPlayerRotation, FalseJokerIndicatorPolicy falseJokerAsIndicator
});


@override $ScoringTableCopyWith<$Res> get scoringTable;

}
/// @nodoc
class __$RuleSetCopyWithImpl<$Res>
    implements _$RuleSetCopyWith<$Res> {
  __$RuleSetCopyWithImpl(this._self, this._then);

  final _RuleSet _self;
  final $Res Function(_RuleSet) _then;

/// Create a copy of RuleSet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preset = null,Object? openThreshold = null,Object? escalatingOpenThreshold = null,Object? illegalOpenPenalty = null,Object? enforceIllegalOpenPenalty = null,Object? allowCircularRuns = null,Object? maxRunLengthOnLayDown = null,Object? maxJokersPerMeld = null,Object? minPairsToOpen = null,Object? pairsToFinish = null,Object? canLayNewMeldsAfterOpening = null,Object? canReplaceJokerOnTable = null,Object? canTakeDiscardBeforeOpening = null,Object? okeyDeadwoodValue = null,Object? onDeckExhausted = null,Object? scoringTable = null,Object? handsPerMatch = null,Object? targetScore = null,Object? matchEndMode = null,Object? startingPlayerRotation = null,Object? falseJokerAsIndicator = null,}) {
  return _then(_RuleSet(
preset: null == preset ? _self.preset : preset // ignore: cast_nullable_to_non_nullable
as RulePreset,openThreshold: null == openThreshold ? _self.openThreshold : openThreshold // ignore: cast_nullable_to_non_nullable
as int,escalatingOpenThreshold: null == escalatingOpenThreshold ? _self.escalatingOpenThreshold : escalatingOpenThreshold // ignore: cast_nullable_to_non_nullable
as bool,illegalOpenPenalty: null == illegalOpenPenalty ? _self.illegalOpenPenalty : illegalOpenPenalty // ignore: cast_nullable_to_non_nullable
as int,enforceIllegalOpenPenalty: null == enforceIllegalOpenPenalty ? _self.enforceIllegalOpenPenalty : enforceIllegalOpenPenalty // ignore: cast_nullable_to_non_nullable
as bool,allowCircularRuns: null == allowCircularRuns ? _self.allowCircularRuns : allowCircularRuns // ignore: cast_nullable_to_non_nullable
as bool,maxRunLengthOnLayDown: null == maxRunLengthOnLayDown ? _self.maxRunLengthOnLayDown : maxRunLengthOnLayDown // ignore: cast_nullable_to_non_nullable
as int,maxJokersPerMeld: null == maxJokersPerMeld ? _self.maxJokersPerMeld : maxJokersPerMeld // ignore: cast_nullable_to_non_nullable
as int,minPairsToOpen: null == minPairsToOpen ? _self.minPairsToOpen : minPairsToOpen // ignore: cast_nullable_to_non_nullable
as int,pairsToFinish: null == pairsToFinish ? _self.pairsToFinish : pairsToFinish // ignore: cast_nullable_to_non_nullable
as int,canLayNewMeldsAfterOpening: null == canLayNewMeldsAfterOpening ? _self.canLayNewMeldsAfterOpening : canLayNewMeldsAfterOpening // ignore: cast_nullable_to_non_nullable
as bool,canReplaceJokerOnTable: null == canReplaceJokerOnTable ? _self.canReplaceJokerOnTable : canReplaceJokerOnTable // ignore: cast_nullable_to_non_nullable
as bool,canTakeDiscardBeforeOpening: null == canTakeDiscardBeforeOpening ? _self.canTakeDiscardBeforeOpening : canTakeDiscardBeforeOpening // ignore: cast_nullable_to_non_nullable
as bool,okeyDeadwoodValue: null == okeyDeadwoodValue ? _self.okeyDeadwoodValue : okeyDeadwoodValue // ignore: cast_nullable_to_non_nullable
as int,onDeckExhausted: null == onDeckExhausted ? _self.onDeckExhausted : onDeckExhausted // ignore: cast_nullable_to_non_nullable
as DeckExhaustedPolicy,scoringTable: null == scoringTable ? _self.scoringTable : scoringTable // ignore: cast_nullable_to_non_nullable
as ScoringTable,handsPerMatch: null == handsPerMatch ? _self.handsPerMatch : handsPerMatch // ignore: cast_nullable_to_non_nullable
as int,targetScore: null == targetScore ? _self.targetScore : targetScore // ignore: cast_nullable_to_non_nullable
as int,matchEndMode: null == matchEndMode ? _self.matchEndMode : matchEndMode // ignore: cast_nullable_to_non_nullable
as MatchEndMode,startingPlayerRotation: null == startingPlayerRotation ? _self.startingPlayerRotation : startingPlayerRotation // ignore: cast_nullable_to_non_nullable
as StartingPlayerRotation,falseJokerAsIndicator: null == falseJokerAsIndicator ? _self.falseJokerAsIndicator : falseJokerAsIndicator // ignore: cast_nullable_to_non_nullable
as FalseJokerIndicatorPolicy,
  ));
}

/// Create a copy of RuleSet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringTableCopyWith<$Res> get scoringTable {
  
  return $ScoringTableCopyWith<$Res>(_self.scoringTable, (value) {
    return _then(_self.copyWith(scoringTable: value));
  });
}
}

// dart format on
