// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError()';
}


}

/// @nodoc
class $GameErrorCopyWith<$Res>  {
$GameErrorCopyWith(GameError _, $Res Function(GameError) __);
}


/// Adds pattern-matching-related methods to [GameError].
extension GameErrorPatterns on GameError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NotYourTurn value)?  notYourTurn,TResult Function( WrongPhase value)?  wrongPhase,TResult Function( TileNotInHand value)?  tileNotInHand,TResult Function( DrawPileEmpty value)?  drawPileEmpty,TResult Function( DiscardPileEmpty value)?  discardPileEmpty,TResult Function( SameTileDiscardedBack value)?  sameTileDiscardedBack,TResult Function( TakeDiscardBeforeOpeningDisabled value)?  takeDiscardBeforeOpeningDisabled,TResult Function( RunTooShort value)?  runTooShort,TResult Function( RunTooLongOnLayDown value)?  runTooLongOnLayDown,TResult Function( RunColorMismatch value)?  runColorMismatch,TResult Function( RunNotConsecutive value)?  runNotConsecutive,TResult Function( RunCannotWrap value)?  runCannotWrap,TResult Function( SetNumberMismatch value)?  setNumberMismatch,TResult Function( SetDuplicateColor value)?  setDuplicateColor,TResult Function( SetWrongSize value)?  setWrongSize,TResult Function( TooManyJokers value)?  tooManyJokers,TResult Function( MeldAllJokers value)?  meldAllJokers,TResult Function( EmptyProposal value)?  emptyProposal,TResult Function( DuplicateTileInProposal value)?  duplicateTileInProposal,TResult Function( OpenThresholdNotMet value)?  openThresholdNotMet,TResult Function( AlreadyOpened value)?  alreadyOpened,TResult Function( NotOpenedYet value)?  notOpenedYet,TResult Function( CannotAddBeforeOpening value)?  cannotAddBeforeOpening,TResult Function( NewMeldsAfterOpeningDisabled value)?  newMeldsAfterOpeningDisabled,TResult Function( PairsPathViolation value)?  pairsPathViolation,TResult Function( NotEnoughPairs value)?  notEnoughPairs,TResult Function( InvalidPair value)?  invalidPair,TResult Function( MeldNotFound value)?  meldNotFound,TResult Function( TileDoesNotExtendMeld value)?  tileDoesNotExtendMeld,TResult Function( NotAJokerAtPosition value)?  notAJokerAtPosition,TResult Function( JokerReplacementDisabled value)?  jokerReplacementDisabled,TResult Function( CannotReplaceFalseJoker value)?  cannotReplaceFalseJoker,TResult Function( JokerReplacementMismatch value)?  jokerReplacementMismatch,TResult Function( HandNotOver value)?  handNotOver,TResult Function( MatchAlreadyOver value)?  matchAlreadyOver,TResult Function( MustDiscardToFinish value)?  mustDiscardToFinish,TResult Function( NotEnoughTiles value)?  notEnoughTiles,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NotYourTurn() when notYourTurn != null:
return notYourTurn(_that);case WrongPhase() when wrongPhase != null:
return wrongPhase(_that);case TileNotInHand() when tileNotInHand != null:
return tileNotInHand(_that);case DrawPileEmpty() when drawPileEmpty != null:
return drawPileEmpty(_that);case DiscardPileEmpty() when discardPileEmpty != null:
return discardPileEmpty(_that);case SameTileDiscardedBack() when sameTileDiscardedBack != null:
return sameTileDiscardedBack(_that);case TakeDiscardBeforeOpeningDisabled() when takeDiscardBeforeOpeningDisabled != null:
return takeDiscardBeforeOpeningDisabled(_that);case RunTooShort() when runTooShort != null:
return runTooShort(_that);case RunTooLongOnLayDown() when runTooLongOnLayDown != null:
return runTooLongOnLayDown(_that);case RunColorMismatch() when runColorMismatch != null:
return runColorMismatch(_that);case RunNotConsecutive() when runNotConsecutive != null:
return runNotConsecutive(_that);case RunCannotWrap() when runCannotWrap != null:
return runCannotWrap(_that);case SetNumberMismatch() when setNumberMismatch != null:
return setNumberMismatch(_that);case SetDuplicateColor() when setDuplicateColor != null:
return setDuplicateColor(_that);case SetWrongSize() when setWrongSize != null:
return setWrongSize(_that);case TooManyJokers() when tooManyJokers != null:
return tooManyJokers(_that);case MeldAllJokers() when meldAllJokers != null:
return meldAllJokers(_that);case EmptyProposal() when emptyProposal != null:
return emptyProposal(_that);case DuplicateTileInProposal() when duplicateTileInProposal != null:
return duplicateTileInProposal(_that);case OpenThresholdNotMet() when openThresholdNotMet != null:
return openThresholdNotMet(_that);case AlreadyOpened() when alreadyOpened != null:
return alreadyOpened(_that);case NotOpenedYet() when notOpenedYet != null:
return notOpenedYet(_that);case CannotAddBeforeOpening() when cannotAddBeforeOpening != null:
return cannotAddBeforeOpening(_that);case NewMeldsAfterOpeningDisabled() when newMeldsAfterOpeningDisabled != null:
return newMeldsAfterOpeningDisabled(_that);case PairsPathViolation() when pairsPathViolation != null:
return pairsPathViolation(_that);case NotEnoughPairs() when notEnoughPairs != null:
return notEnoughPairs(_that);case InvalidPair() when invalidPair != null:
return invalidPair(_that);case MeldNotFound() when meldNotFound != null:
return meldNotFound(_that);case TileDoesNotExtendMeld() when tileDoesNotExtendMeld != null:
return tileDoesNotExtendMeld(_that);case NotAJokerAtPosition() when notAJokerAtPosition != null:
return notAJokerAtPosition(_that);case JokerReplacementDisabled() when jokerReplacementDisabled != null:
return jokerReplacementDisabled(_that);case CannotReplaceFalseJoker() when cannotReplaceFalseJoker != null:
return cannotReplaceFalseJoker(_that);case JokerReplacementMismatch() when jokerReplacementMismatch != null:
return jokerReplacementMismatch(_that);case HandNotOver() when handNotOver != null:
return handNotOver(_that);case MatchAlreadyOver() when matchAlreadyOver != null:
return matchAlreadyOver(_that);case MustDiscardToFinish() when mustDiscardToFinish != null:
return mustDiscardToFinish(_that);case NotEnoughTiles() when notEnoughTiles != null:
return notEnoughTiles(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NotYourTurn value)  notYourTurn,required TResult Function( WrongPhase value)  wrongPhase,required TResult Function( TileNotInHand value)  tileNotInHand,required TResult Function( DrawPileEmpty value)  drawPileEmpty,required TResult Function( DiscardPileEmpty value)  discardPileEmpty,required TResult Function( SameTileDiscardedBack value)  sameTileDiscardedBack,required TResult Function( TakeDiscardBeforeOpeningDisabled value)  takeDiscardBeforeOpeningDisabled,required TResult Function( RunTooShort value)  runTooShort,required TResult Function( RunTooLongOnLayDown value)  runTooLongOnLayDown,required TResult Function( RunColorMismatch value)  runColorMismatch,required TResult Function( RunNotConsecutive value)  runNotConsecutive,required TResult Function( RunCannotWrap value)  runCannotWrap,required TResult Function( SetNumberMismatch value)  setNumberMismatch,required TResult Function( SetDuplicateColor value)  setDuplicateColor,required TResult Function( SetWrongSize value)  setWrongSize,required TResult Function( TooManyJokers value)  tooManyJokers,required TResult Function( MeldAllJokers value)  meldAllJokers,required TResult Function( EmptyProposal value)  emptyProposal,required TResult Function( DuplicateTileInProposal value)  duplicateTileInProposal,required TResult Function( OpenThresholdNotMet value)  openThresholdNotMet,required TResult Function( AlreadyOpened value)  alreadyOpened,required TResult Function( NotOpenedYet value)  notOpenedYet,required TResult Function( CannotAddBeforeOpening value)  cannotAddBeforeOpening,required TResult Function( NewMeldsAfterOpeningDisabled value)  newMeldsAfterOpeningDisabled,required TResult Function( PairsPathViolation value)  pairsPathViolation,required TResult Function( NotEnoughPairs value)  notEnoughPairs,required TResult Function( InvalidPair value)  invalidPair,required TResult Function( MeldNotFound value)  meldNotFound,required TResult Function( TileDoesNotExtendMeld value)  tileDoesNotExtendMeld,required TResult Function( NotAJokerAtPosition value)  notAJokerAtPosition,required TResult Function( JokerReplacementDisabled value)  jokerReplacementDisabled,required TResult Function( CannotReplaceFalseJoker value)  cannotReplaceFalseJoker,required TResult Function( JokerReplacementMismatch value)  jokerReplacementMismatch,required TResult Function( HandNotOver value)  handNotOver,required TResult Function( MatchAlreadyOver value)  matchAlreadyOver,required TResult Function( MustDiscardToFinish value)  mustDiscardToFinish,required TResult Function( NotEnoughTiles value)  notEnoughTiles,}){
final _that = this;
switch (_that) {
case NotYourTurn():
return notYourTurn(_that);case WrongPhase():
return wrongPhase(_that);case TileNotInHand():
return tileNotInHand(_that);case DrawPileEmpty():
return drawPileEmpty(_that);case DiscardPileEmpty():
return discardPileEmpty(_that);case SameTileDiscardedBack():
return sameTileDiscardedBack(_that);case TakeDiscardBeforeOpeningDisabled():
return takeDiscardBeforeOpeningDisabled(_that);case RunTooShort():
return runTooShort(_that);case RunTooLongOnLayDown():
return runTooLongOnLayDown(_that);case RunColorMismatch():
return runColorMismatch(_that);case RunNotConsecutive():
return runNotConsecutive(_that);case RunCannotWrap():
return runCannotWrap(_that);case SetNumberMismatch():
return setNumberMismatch(_that);case SetDuplicateColor():
return setDuplicateColor(_that);case SetWrongSize():
return setWrongSize(_that);case TooManyJokers():
return tooManyJokers(_that);case MeldAllJokers():
return meldAllJokers(_that);case EmptyProposal():
return emptyProposal(_that);case DuplicateTileInProposal():
return duplicateTileInProposal(_that);case OpenThresholdNotMet():
return openThresholdNotMet(_that);case AlreadyOpened():
return alreadyOpened(_that);case NotOpenedYet():
return notOpenedYet(_that);case CannotAddBeforeOpening():
return cannotAddBeforeOpening(_that);case NewMeldsAfterOpeningDisabled():
return newMeldsAfterOpeningDisabled(_that);case PairsPathViolation():
return pairsPathViolation(_that);case NotEnoughPairs():
return notEnoughPairs(_that);case InvalidPair():
return invalidPair(_that);case MeldNotFound():
return meldNotFound(_that);case TileDoesNotExtendMeld():
return tileDoesNotExtendMeld(_that);case NotAJokerAtPosition():
return notAJokerAtPosition(_that);case JokerReplacementDisabled():
return jokerReplacementDisabled(_that);case CannotReplaceFalseJoker():
return cannotReplaceFalseJoker(_that);case JokerReplacementMismatch():
return jokerReplacementMismatch(_that);case HandNotOver():
return handNotOver(_that);case MatchAlreadyOver():
return matchAlreadyOver(_that);case MustDiscardToFinish():
return mustDiscardToFinish(_that);case NotEnoughTiles():
return notEnoughTiles(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NotYourTurn value)?  notYourTurn,TResult? Function( WrongPhase value)?  wrongPhase,TResult? Function( TileNotInHand value)?  tileNotInHand,TResult? Function( DrawPileEmpty value)?  drawPileEmpty,TResult? Function( DiscardPileEmpty value)?  discardPileEmpty,TResult? Function( SameTileDiscardedBack value)?  sameTileDiscardedBack,TResult? Function( TakeDiscardBeforeOpeningDisabled value)?  takeDiscardBeforeOpeningDisabled,TResult? Function( RunTooShort value)?  runTooShort,TResult? Function( RunTooLongOnLayDown value)?  runTooLongOnLayDown,TResult? Function( RunColorMismatch value)?  runColorMismatch,TResult? Function( RunNotConsecutive value)?  runNotConsecutive,TResult? Function( RunCannotWrap value)?  runCannotWrap,TResult? Function( SetNumberMismatch value)?  setNumberMismatch,TResult? Function( SetDuplicateColor value)?  setDuplicateColor,TResult? Function( SetWrongSize value)?  setWrongSize,TResult? Function( TooManyJokers value)?  tooManyJokers,TResult? Function( MeldAllJokers value)?  meldAllJokers,TResult? Function( EmptyProposal value)?  emptyProposal,TResult? Function( DuplicateTileInProposal value)?  duplicateTileInProposal,TResult? Function( OpenThresholdNotMet value)?  openThresholdNotMet,TResult? Function( AlreadyOpened value)?  alreadyOpened,TResult? Function( NotOpenedYet value)?  notOpenedYet,TResult? Function( CannotAddBeforeOpening value)?  cannotAddBeforeOpening,TResult? Function( NewMeldsAfterOpeningDisabled value)?  newMeldsAfterOpeningDisabled,TResult? Function( PairsPathViolation value)?  pairsPathViolation,TResult? Function( NotEnoughPairs value)?  notEnoughPairs,TResult? Function( InvalidPair value)?  invalidPair,TResult? Function( MeldNotFound value)?  meldNotFound,TResult? Function( TileDoesNotExtendMeld value)?  tileDoesNotExtendMeld,TResult? Function( NotAJokerAtPosition value)?  notAJokerAtPosition,TResult? Function( JokerReplacementDisabled value)?  jokerReplacementDisabled,TResult? Function( CannotReplaceFalseJoker value)?  cannotReplaceFalseJoker,TResult? Function( JokerReplacementMismatch value)?  jokerReplacementMismatch,TResult? Function( HandNotOver value)?  handNotOver,TResult? Function( MatchAlreadyOver value)?  matchAlreadyOver,TResult? Function( MustDiscardToFinish value)?  mustDiscardToFinish,TResult? Function( NotEnoughTiles value)?  notEnoughTiles,}){
final _that = this;
switch (_that) {
case NotYourTurn() when notYourTurn != null:
return notYourTurn(_that);case WrongPhase() when wrongPhase != null:
return wrongPhase(_that);case TileNotInHand() when tileNotInHand != null:
return tileNotInHand(_that);case DrawPileEmpty() when drawPileEmpty != null:
return drawPileEmpty(_that);case DiscardPileEmpty() when discardPileEmpty != null:
return discardPileEmpty(_that);case SameTileDiscardedBack() when sameTileDiscardedBack != null:
return sameTileDiscardedBack(_that);case TakeDiscardBeforeOpeningDisabled() when takeDiscardBeforeOpeningDisabled != null:
return takeDiscardBeforeOpeningDisabled(_that);case RunTooShort() when runTooShort != null:
return runTooShort(_that);case RunTooLongOnLayDown() when runTooLongOnLayDown != null:
return runTooLongOnLayDown(_that);case RunColorMismatch() when runColorMismatch != null:
return runColorMismatch(_that);case RunNotConsecutive() when runNotConsecutive != null:
return runNotConsecutive(_that);case RunCannotWrap() when runCannotWrap != null:
return runCannotWrap(_that);case SetNumberMismatch() when setNumberMismatch != null:
return setNumberMismatch(_that);case SetDuplicateColor() when setDuplicateColor != null:
return setDuplicateColor(_that);case SetWrongSize() when setWrongSize != null:
return setWrongSize(_that);case TooManyJokers() when tooManyJokers != null:
return tooManyJokers(_that);case MeldAllJokers() when meldAllJokers != null:
return meldAllJokers(_that);case EmptyProposal() when emptyProposal != null:
return emptyProposal(_that);case DuplicateTileInProposal() when duplicateTileInProposal != null:
return duplicateTileInProposal(_that);case OpenThresholdNotMet() when openThresholdNotMet != null:
return openThresholdNotMet(_that);case AlreadyOpened() when alreadyOpened != null:
return alreadyOpened(_that);case NotOpenedYet() when notOpenedYet != null:
return notOpenedYet(_that);case CannotAddBeforeOpening() when cannotAddBeforeOpening != null:
return cannotAddBeforeOpening(_that);case NewMeldsAfterOpeningDisabled() when newMeldsAfterOpeningDisabled != null:
return newMeldsAfterOpeningDisabled(_that);case PairsPathViolation() when pairsPathViolation != null:
return pairsPathViolation(_that);case NotEnoughPairs() when notEnoughPairs != null:
return notEnoughPairs(_that);case InvalidPair() when invalidPair != null:
return invalidPair(_that);case MeldNotFound() when meldNotFound != null:
return meldNotFound(_that);case TileDoesNotExtendMeld() when tileDoesNotExtendMeld != null:
return tileDoesNotExtendMeld(_that);case NotAJokerAtPosition() when notAJokerAtPosition != null:
return notAJokerAtPosition(_that);case JokerReplacementDisabled() when jokerReplacementDisabled != null:
return jokerReplacementDisabled(_that);case CannotReplaceFalseJoker() when cannotReplaceFalseJoker != null:
return cannotReplaceFalseJoker(_that);case JokerReplacementMismatch() when jokerReplacementMismatch != null:
return jokerReplacementMismatch(_that);case HandNotOver() when handNotOver != null:
return handNotOver(_that);case MatchAlreadyOver() when matchAlreadyOver != null:
return matchAlreadyOver(_that);case MustDiscardToFinish() when mustDiscardToFinish != null:
return mustDiscardToFinish(_that);case NotEnoughTiles() when notEnoughTiles != null:
return notEnoughTiles(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int seat)?  notYourTurn,TResult Function()?  wrongPhase,TResult Function( int tileId)?  tileNotInHand,TResult Function()?  drawPileEmpty,TResult Function()?  discardPileEmpty,TResult Function( int tileId)?  sameTileDiscardedBack,TResult Function()?  takeDiscardBeforeOpeningDisabled,TResult Function( int length)?  runTooShort,TResult Function( int length,  int max)?  runTooLongOnLayDown,TResult Function()?  runColorMismatch,TResult Function()?  runNotConsecutive,TResult Function()?  runCannotWrap,TResult Function()?  setNumberMismatch,TResult Function( TileColor color)?  setDuplicateColor,TResult Function( int size)?  setWrongSize,TResult Function( int count,  int max)?  tooManyJokers,TResult Function()?  meldAllJokers,TResult Function()?  emptyProposal,TResult Function( int tileId)?  duplicateTileInProposal,TResult Function( int requiredPoints,  int actualPoints)?  openThresholdNotMet,TResult Function()?  alreadyOpened,TResult Function()?  notOpenedYet,TResult Function()?  cannotAddBeforeOpening,TResult Function()?  newMeldsAfterOpeningDisabled,TResult Function()?  pairsPathViolation,TResult Function( int requiredPairs,  int actualPairs)?  notEnoughPairs,TResult Function()?  invalidPair,TResult Function( int meldId)?  meldNotFound,TResult Function( int meldId,  int tileId)?  tileDoesNotExtendMeld,TResult Function( int meldId,  int index)?  notAJokerAtPosition,TResult Function()?  jokerReplacementDisabled,TResult Function()?  cannotReplaceFalseJoker,TResult Function()?  jokerReplacementMismatch,TResult Function()?  handNotOver,TResult Function()?  matchAlreadyOver,TResult Function()?  mustDiscardToFinish,TResult Function()?  notEnoughTiles,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NotYourTurn() when notYourTurn != null:
return notYourTurn(_that.seat);case WrongPhase() when wrongPhase != null:
return wrongPhase();case TileNotInHand() when tileNotInHand != null:
return tileNotInHand(_that.tileId);case DrawPileEmpty() when drawPileEmpty != null:
return drawPileEmpty();case DiscardPileEmpty() when discardPileEmpty != null:
return discardPileEmpty();case SameTileDiscardedBack() when sameTileDiscardedBack != null:
return sameTileDiscardedBack(_that.tileId);case TakeDiscardBeforeOpeningDisabled() when takeDiscardBeforeOpeningDisabled != null:
return takeDiscardBeforeOpeningDisabled();case RunTooShort() when runTooShort != null:
return runTooShort(_that.length);case RunTooLongOnLayDown() when runTooLongOnLayDown != null:
return runTooLongOnLayDown(_that.length,_that.max);case RunColorMismatch() when runColorMismatch != null:
return runColorMismatch();case RunNotConsecutive() when runNotConsecutive != null:
return runNotConsecutive();case RunCannotWrap() when runCannotWrap != null:
return runCannotWrap();case SetNumberMismatch() when setNumberMismatch != null:
return setNumberMismatch();case SetDuplicateColor() when setDuplicateColor != null:
return setDuplicateColor(_that.color);case SetWrongSize() when setWrongSize != null:
return setWrongSize(_that.size);case TooManyJokers() when tooManyJokers != null:
return tooManyJokers(_that.count,_that.max);case MeldAllJokers() when meldAllJokers != null:
return meldAllJokers();case EmptyProposal() when emptyProposal != null:
return emptyProposal();case DuplicateTileInProposal() when duplicateTileInProposal != null:
return duplicateTileInProposal(_that.tileId);case OpenThresholdNotMet() when openThresholdNotMet != null:
return openThresholdNotMet(_that.requiredPoints,_that.actualPoints);case AlreadyOpened() when alreadyOpened != null:
return alreadyOpened();case NotOpenedYet() when notOpenedYet != null:
return notOpenedYet();case CannotAddBeforeOpening() when cannotAddBeforeOpening != null:
return cannotAddBeforeOpening();case NewMeldsAfterOpeningDisabled() when newMeldsAfterOpeningDisabled != null:
return newMeldsAfterOpeningDisabled();case PairsPathViolation() when pairsPathViolation != null:
return pairsPathViolation();case NotEnoughPairs() when notEnoughPairs != null:
return notEnoughPairs(_that.requiredPairs,_that.actualPairs);case InvalidPair() when invalidPair != null:
return invalidPair();case MeldNotFound() when meldNotFound != null:
return meldNotFound(_that.meldId);case TileDoesNotExtendMeld() when tileDoesNotExtendMeld != null:
return tileDoesNotExtendMeld(_that.meldId,_that.tileId);case NotAJokerAtPosition() when notAJokerAtPosition != null:
return notAJokerAtPosition(_that.meldId,_that.index);case JokerReplacementDisabled() when jokerReplacementDisabled != null:
return jokerReplacementDisabled();case CannotReplaceFalseJoker() when cannotReplaceFalseJoker != null:
return cannotReplaceFalseJoker();case JokerReplacementMismatch() when jokerReplacementMismatch != null:
return jokerReplacementMismatch();case HandNotOver() when handNotOver != null:
return handNotOver();case MatchAlreadyOver() when matchAlreadyOver != null:
return matchAlreadyOver();case MustDiscardToFinish() when mustDiscardToFinish != null:
return mustDiscardToFinish();case NotEnoughTiles() when notEnoughTiles != null:
return notEnoughTiles();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int seat)  notYourTurn,required TResult Function()  wrongPhase,required TResult Function( int tileId)  tileNotInHand,required TResult Function()  drawPileEmpty,required TResult Function()  discardPileEmpty,required TResult Function( int tileId)  sameTileDiscardedBack,required TResult Function()  takeDiscardBeforeOpeningDisabled,required TResult Function( int length)  runTooShort,required TResult Function( int length,  int max)  runTooLongOnLayDown,required TResult Function()  runColorMismatch,required TResult Function()  runNotConsecutive,required TResult Function()  runCannotWrap,required TResult Function()  setNumberMismatch,required TResult Function( TileColor color)  setDuplicateColor,required TResult Function( int size)  setWrongSize,required TResult Function( int count,  int max)  tooManyJokers,required TResult Function()  meldAllJokers,required TResult Function()  emptyProposal,required TResult Function( int tileId)  duplicateTileInProposal,required TResult Function( int requiredPoints,  int actualPoints)  openThresholdNotMet,required TResult Function()  alreadyOpened,required TResult Function()  notOpenedYet,required TResult Function()  cannotAddBeforeOpening,required TResult Function()  newMeldsAfterOpeningDisabled,required TResult Function()  pairsPathViolation,required TResult Function( int requiredPairs,  int actualPairs)  notEnoughPairs,required TResult Function()  invalidPair,required TResult Function( int meldId)  meldNotFound,required TResult Function( int meldId,  int tileId)  tileDoesNotExtendMeld,required TResult Function( int meldId,  int index)  notAJokerAtPosition,required TResult Function()  jokerReplacementDisabled,required TResult Function()  cannotReplaceFalseJoker,required TResult Function()  jokerReplacementMismatch,required TResult Function()  handNotOver,required TResult Function()  matchAlreadyOver,required TResult Function()  mustDiscardToFinish,required TResult Function()  notEnoughTiles,}) {final _that = this;
switch (_that) {
case NotYourTurn():
return notYourTurn(_that.seat);case WrongPhase():
return wrongPhase();case TileNotInHand():
return tileNotInHand(_that.tileId);case DrawPileEmpty():
return drawPileEmpty();case DiscardPileEmpty():
return discardPileEmpty();case SameTileDiscardedBack():
return sameTileDiscardedBack(_that.tileId);case TakeDiscardBeforeOpeningDisabled():
return takeDiscardBeforeOpeningDisabled();case RunTooShort():
return runTooShort(_that.length);case RunTooLongOnLayDown():
return runTooLongOnLayDown(_that.length,_that.max);case RunColorMismatch():
return runColorMismatch();case RunNotConsecutive():
return runNotConsecutive();case RunCannotWrap():
return runCannotWrap();case SetNumberMismatch():
return setNumberMismatch();case SetDuplicateColor():
return setDuplicateColor(_that.color);case SetWrongSize():
return setWrongSize(_that.size);case TooManyJokers():
return tooManyJokers(_that.count,_that.max);case MeldAllJokers():
return meldAllJokers();case EmptyProposal():
return emptyProposal();case DuplicateTileInProposal():
return duplicateTileInProposal(_that.tileId);case OpenThresholdNotMet():
return openThresholdNotMet(_that.requiredPoints,_that.actualPoints);case AlreadyOpened():
return alreadyOpened();case NotOpenedYet():
return notOpenedYet();case CannotAddBeforeOpening():
return cannotAddBeforeOpening();case NewMeldsAfterOpeningDisabled():
return newMeldsAfterOpeningDisabled();case PairsPathViolation():
return pairsPathViolation();case NotEnoughPairs():
return notEnoughPairs(_that.requiredPairs,_that.actualPairs);case InvalidPair():
return invalidPair();case MeldNotFound():
return meldNotFound(_that.meldId);case TileDoesNotExtendMeld():
return tileDoesNotExtendMeld(_that.meldId,_that.tileId);case NotAJokerAtPosition():
return notAJokerAtPosition(_that.meldId,_that.index);case JokerReplacementDisabled():
return jokerReplacementDisabled();case CannotReplaceFalseJoker():
return cannotReplaceFalseJoker();case JokerReplacementMismatch():
return jokerReplacementMismatch();case HandNotOver():
return handNotOver();case MatchAlreadyOver():
return matchAlreadyOver();case MustDiscardToFinish():
return mustDiscardToFinish();case NotEnoughTiles():
return notEnoughTiles();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int seat)?  notYourTurn,TResult? Function()?  wrongPhase,TResult? Function( int tileId)?  tileNotInHand,TResult? Function()?  drawPileEmpty,TResult? Function()?  discardPileEmpty,TResult? Function( int tileId)?  sameTileDiscardedBack,TResult? Function()?  takeDiscardBeforeOpeningDisabled,TResult? Function( int length)?  runTooShort,TResult? Function( int length,  int max)?  runTooLongOnLayDown,TResult? Function()?  runColorMismatch,TResult? Function()?  runNotConsecutive,TResult? Function()?  runCannotWrap,TResult? Function()?  setNumberMismatch,TResult? Function( TileColor color)?  setDuplicateColor,TResult? Function( int size)?  setWrongSize,TResult? Function( int count,  int max)?  tooManyJokers,TResult? Function()?  meldAllJokers,TResult? Function()?  emptyProposal,TResult? Function( int tileId)?  duplicateTileInProposal,TResult? Function( int requiredPoints,  int actualPoints)?  openThresholdNotMet,TResult? Function()?  alreadyOpened,TResult? Function()?  notOpenedYet,TResult? Function()?  cannotAddBeforeOpening,TResult? Function()?  newMeldsAfterOpeningDisabled,TResult? Function()?  pairsPathViolation,TResult? Function( int requiredPairs,  int actualPairs)?  notEnoughPairs,TResult? Function()?  invalidPair,TResult? Function( int meldId)?  meldNotFound,TResult? Function( int meldId,  int tileId)?  tileDoesNotExtendMeld,TResult? Function( int meldId,  int index)?  notAJokerAtPosition,TResult? Function()?  jokerReplacementDisabled,TResult? Function()?  cannotReplaceFalseJoker,TResult? Function()?  jokerReplacementMismatch,TResult? Function()?  handNotOver,TResult? Function()?  matchAlreadyOver,TResult? Function()?  mustDiscardToFinish,TResult? Function()?  notEnoughTiles,}) {final _that = this;
switch (_that) {
case NotYourTurn() when notYourTurn != null:
return notYourTurn(_that.seat);case WrongPhase() when wrongPhase != null:
return wrongPhase();case TileNotInHand() when tileNotInHand != null:
return tileNotInHand(_that.tileId);case DrawPileEmpty() when drawPileEmpty != null:
return drawPileEmpty();case DiscardPileEmpty() when discardPileEmpty != null:
return discardPileEmpty();case SameTileDiscardedBack() when sameTileDiscardedBack != null:
return sameTileDiscardedBack(_that.tileId);case TakeDiscardBeforeOpeningDisabled() when takeDiscardBeforeOpeningDisabled != null:
return takeDiscardBeforeOpeningDisabled();case RunTooShort() when runTooShort != null:
return runTooShort(_that.length);case RunTooLongOnLayDown() when runTooLongOnLayDown != null:
return runTooLongOnLayDown(_that.length,_that.max);case RunColorMismatch() when runColorMismatch != null:
return runColorMismatch();case RunNotConsecutive() when runNotConsecutive != null:
return runNotConsecutive();case RunCannotWrap() when runCannotWrap != null:
return runCannotWrap();case SetNumberMismatch() when setNumberMismatch != null:
return setNumberMismatch();case SetDuplicateColor() when setDuplicateColor != null:
return setDuplicateColor(_that.color);case SetWrongSize() when setWrongSize != null:
return setWrongSize(_that.size);case TooManyJokers() when tooManyJokers != null:
return tooManyJokers(_that.count,_that.max);case MeldAllJokers() when meldAllJokers != null:
return meldAllJokers();case EmptyProposal() when emptyProposal != null:
return emptyProposal();case DuplicateTileInProposal() when duplicateTileInProposal != null:
return duplicateTileInProposal(_that.tileId);case OpenThresholdNotMet() when openThresholdNotMet != null:
return openThresholdNotMet(_that.requiredPoints,_that.actualPoints);case AlreadyOpened() when alreadyOpened != null:
return alreadyOpened();case NotOpenedYet() when notOpenedYet != null:
return notOpenedYet();case CannotAddBeforeOpening() when cannotAddBeforeOpening != null:
return cannotAddBeforeOpening();case NewMeldsAfterOpeningDisabled() when newMeldsAfterOpeningDisabled != null:
return newMeldsAfterOpeningDisabled();case PairsPathViolation() when pairsPathViolation != null:
return pairsPathViolation();case NotEnoughPairs() when notEnoughPairs != null:
return notEnoughPairs(_that.requiredPairs,_that.actualPairs);case InvalidPair() when invalidPair != null:
return invalidPair();case MeldNotFound() when meldNotFound != null:
return meldNotFound(_that.meldId);case TileDoesNotExtendMeld() when tileDoesNotExtendMeld != null:
return tileDoesNotExtendMeld(_that.meldId,_that.tileId);case NotAJokerAtPosition() when notAJokerAtPosition != null:
return notAJokerAtPosition(_that.meldId,_that.index);case JokerReplacementDisabled() when jokerReplacementDisabled != null:
return jokerReplacementDisabled();case CannotReplaceFalseJoker() when cannotReplaceFalseJoker != null:
return cannotReplaceFalseJoker();case JokerReplacementMismatch() when jokerReplacementMismatch != null:
return jokerReplacementMismatch();case HandNotOver() when handNotOver != null:
return handNotOver();case MatchAlreadyOver() when matchAlreadyOver != null:
return matchAlreadyOver();case MustDiscardToFinish() when mustDiscardToFinish != null:
return mustDiscardToFinish();case NotEnoughTiles() when notEnoughTiles != null:
return notEnoughTiles();case _:
  return null;

}
}

}

/// @nodoc


class NotYourTurn extends GameError {
  const NotYourTurn({required this.seat}): super._();
  

 final  int seat;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotYourTurnCopyWith<NotYourTurn> get copyWith => _$NotYourTurnCopyWithImpl<NotYourTurn>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotYourTurn&&(identical(other.seat, seat) || other.seat == seat));
}


@override
int get hashCode => Object.hash(runtimeType,seat);

@override
String toString() {
  return 'GameError.notYourTurn(seat: $seat)';
}


}

/// @nodoc
abstract mixin class $NotYourTurnCopyWith<$Res> implements $GameErrorCopyWith<$Res> {
  factory $NotYourTurnCopyWith(NotYourTurn value, $Res Function(NotYourTurn) _then) = _$NotYourTurnCopyWithImpl;
@useResult
$Res call({
 int seat
});




}
/// @nodoc
class _$NotYourTurnCopyWithImpl<$Res>
    implements $NotYourTurnCopyWith<$Res> {
  _$NotYourTurnCopyWithImpl(this._self, this._then);

  final NotYourTurn _self;
  final $Res Function(NotYourTurn) _then;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? seat = null,}) {
  return _then(NotYourTurn(
seat: null == seat ? _self.seat : seat // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class WrongPhase extends GameError {
  const WrongPhase(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WrongPhase);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.wrongPhase()';
}


}




/// @nodoc


class TileNotInHand extends GameError {
  const TileNotInHand({required this.tileId}): super._();
  

 final  int tileId;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TileNotInHandCopyWith<TileNotInHand> get copyWith => _$TileNotInHandCopyWithImpl<TileNotInHand>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TileNotInHand&&(identical(other.tileId, tileId) || other.tileId == tileId));
}


@override
int get hashCode => Object.hash(runtimeType,tileId);

@override
String toString() {
  return 'GameError.tileNotInHand(tileId: $tileId)';
}


}

/// @nodoc
abstract mixin class $TileNotInHandCopyWith<$Res> implements $GameErrorCopyWith<$Res> {
  factory $TileNotInHandCopyWith(TileNotInHand value, $Res Function(TileNotInHand) _then) = _$TileNotInHandCopyWithImpl;
@useResult
$Res call({
 int tileId
});




}
/// @nodoc
class _$TileNotInHandCopyWithImpl<$Res>
    implements $TileNotInHandCopyWith<$Res> {
  _$TileNotInHandCopyWithImpl(this._self, this._then);

  final TileNotInHand _self;
  final $Res Function(TileNotInHand) _then;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tileId = null,}) {
  return _then(TileNotInHand(
tileId: null == tileId ? _self.tileId : tileId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class DrawPileEmpty extends GameError {
  const DrawPileEmpty(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrawPileEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.drawPileEmpty()';
}


}




/// @nodoc


class DiscardPileEmpty extends GameError {
  const DiscardPileEmpty(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscardPileEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.discardPileEmpty()';
}


}




/// @nodoc


class SameTileDiscardedBack extends GameError {
  const SameTileDiscardedBack({required this.tileId}): super._();
  

 final  int tileId;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SameTileDiscardedBackCopyWith<SameTileDiscardedBack> get copyWith => _$SameTileDiscardedBackCopyWithImpl<SameTileDiscardedBack>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SameTileDiscardedBack&&(identical(other.tileId, tileId) || other.tileId == tileId));
}


@override
int get hashCode => Object.hash(runtimeType,tileId);

@override
String toString() {
  return 'GameError.sameTileDiscardedBack(tileId: $tileId)';
}


}

/// @nodoc
abstract mixin class $SameTileDiscardedBackCopyWith<$Res> implements $GameErrorCopyWith<$Res> {
  factory $SameTileDiscardedBackCopyWith(SameTileDiscardedBack value, $Res Function(SameTileDiscardedBack) _then) = _$SameTileDiscardedBackCopyWithImpl;
@useResult
$Res call({
 int tileId
});




}
/// @nodoc
class _$SameTileDiscardedBackCopyWithImpl<$Res>
    implements $SameTileDiscardedBackCopyWith<$Res> {
  _$SameTileDiscardedBackCopyWithImpl(this._self, this._then);

  final SameTileDiscardedBack _self;
  final $Res Function(SameTileDiscardedBack) _then;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tileId = null,}) {
  return _then(SameTileDiscardedBack(
tileId: null == tileId ? _self.tileId : tileId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class TakeDiscardBeforeOpeningDisabled extends GameError {
  const TakeDiscardBeforeOpeningDisabled(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TakeDiscardBeforeOpeningDisabled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.takeDiscardBeforeOpeningDisabled()';
}


}




/// @nodoc


class RunTooShort extends GameError {
  const RunTooShort({required this.length}): super._();
  

 final  int length;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunTooShortCopyWith<RunTooShort> get copyWith => _$RunTooShortCopyWithImpl<RunTooShort>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunTooShort&&(identical(other.length, length) || other.length == length));
}


@override
int get hashCode => Object.hash(runtimeType,length);

@override
String toString() {
  return 'GameError.runTooShort(length: $length)';
}


}

/// @nodoc
abstract mixin class $RunTooShortCopyWith<$Res> implements $GameErrorCopyWith<$Res> {
  factory $RunTooShortCopyWith(RunTooShort value, $Res Function(RunTooShort) _then) = _$RunTooShortCopyWithImpl;
@useResult
$Res call({
 int length
});




}
/// @nodoc
class _$RunTooShortCopyWithImpl<$Res>
    implements $RunTooShortCopyWith<$Res> {
  _$RunTooShortCopyWithImpl(this._self, this._then);

  final RunTooShort _self;
  final $Res Function(RunTooShort) _then;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? length = null,}) {
  return _then(RunTooShort(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class RunTooLongOnLayDown extends GameError {
  const RunTooLongOnLayDown({required this.length, required this.max}): super._();
  

 final  int length;
 final  int max;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunTooLongOnLayDownCopyWith<RunTooLongOnLayDown> get copyWith => _$RunTooLongOnLayDownCopyWithImpl<RunTooLongOnLayDown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunTooLongOnLayDown&&(identical(other.length, length) || other.length == length)&&(identical(other.max, max) || other.max == max));
}


@override
int get hashCode => Object.hash(runtimeType,length,max);

@override
String toString() {
  return 'GameError.runTooLongOnLayDown(length: $length, max: $max)';
}


}

/// @nodoc
abstract mixin class $RunTooLongOnLayDownCopyWith<$Res> implements $GameErrorCopyWith<$Res> {
  factory $RunTooLongOnLayDownCopyWith(RunTooLongOnLayDown value, $Res Function(RunTooLongOnLayDown) _then) = _$RunTooLongOnLayDownCopyWithImpl;
@useResult
$Res call({
 int length, int max
});




}
/// @nodoc
class _$RunTooLongOnLayDownCopyWithImpl<$Res>
    implements $RunTooLongOnLayDownCopyWith<$Res> {
  _$RunTooLongOnLayDownCopyWithImpl(this._self, this._then);

  final RunTooLongOnLayDown _self;
  final $Res Function(RunTooLongOnLayDown) _then;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? length = null,Object? max = null,}) {
  return _then(RunTooLongOnLayDown(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class RunColorMismatch extends GameError {
  const RunColorMismatch(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunColorMismatch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.runColorMismatch()';
}


}




/// @nodoc


class RunNotConsecutive extends GameError {
  const RunNotConsecutive(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunNotConsecutive);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.runNotConsecutive()';
}


}




/// @nodoc


class RunCannotWrap extends GameError {
  const RunCannotWrap(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunCannotWrap);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.runCannotWrap()';
}


}




/// @nodoc


class SetNumberMismatch extends GameError {
  const SetNumberMismatch(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetNumberMismatch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.setNumberMismatch()';
}


}




/// @nodoc


class SetDuplicateColor extends GameError {
  const SetDuplicateColor({required this.color}): super._();
  

 final  TileColor color;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetDuplicateColorCopyWith<SetDuplicateColor> get copyWith => _$SetDuplicateColorCopyWithImpl<SetDuplicateColor>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetDuplicateColor&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,color);

@override
String toString() {
  return 'GameError.setDuplicateColor(color: $color)';
}


}

/// @nodoc
abstract mixin class $SetDuplicateColorCopyWith<$Res> implements $GameErrorCopyWith<$Res> {
  factory $SetDuplicateColorCopyWith(SetDuplicateColor value, $Res Function(SetDuplicateColor) _then) = _$SetDuplicateColorCopyWithImpl;
@useResult
$Res call({
 TileColor color
});




}
/// @nodoc
class _$SetDuplicateColorCopyWithImpl<$Res>
    implements $SetDuplicateColorCopyWith<$Res> {
  _$SetDuplicateColorCopyWithImpl(this._self, this._then);

  final SetDuplicateColor _self;
  final $Res Function(SetDuplicateColor) _then;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? color = null,}) {
  return _then(SetDuplicateColor(
color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as TileColor,
  ));
}


}

/// @nodoc


class SetWrongSize extends GameError {
  const SetWrongSize({required this.size}): super._();
  

 final  int size;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetWrongSizeCopyWith<SetWrongSize> get copyWith => _$SetWrongSizeCopyWithImpl<SetWrongSize>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetWrongSize&&(identical(other.size, size) || other.size == size));
}


@override
int get hashCode => Object.hash(runtimeType,size);

@override
String toString() {
  return 'GameError.setWrongSize(size: $size)';
}


}

/// @nodoc
abstract mixin class $SetWrongSizeCopyWith<$Res> implements $GameErrorCopyWith<$Res> {
  factory $SetWrongSizeCopyWith(SetWrongSize value, $Res Function(SetWrongSize) _then) = _$SetWrongSizeCopyWithImpl;
@useResult
$Res call({
 int size
});




}
/// @nodoc
class _$SetWrongSizeCopyWithImpl<$Res>
    implements $SetWrongSizeCopyWith<$Res> {
  _$SetWrongSizeCopyWithImpl(this._self, this._then);

  final SetWrongSize _self;
  final $Res Function(SetWrongSize) _then;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? size = null,}) {
  return _then(SetWrongSize(
size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class TooManyJokers extends GameError {
  const TooManyJokers({required this.count, required this.max}): super._();
  

 final  int count;
 final  int max;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TooManyJokersCopyWith<TooManyJokers> get copyWith => _$TooManyJokersCopyWithImpl<TooManyJokers>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TooManyJokers&&(identical(other.count, count) || other.count == count)&&(identical(other.max, max) || other.max == max));
}


@override
int get hashCode => Object.hash(runtimeType,count,max);

@override
String toString() {
  return 'GameError.tooManyJokers(count: $count, max: $max)';
}


}

/// @nodoc
abstract mixin class $TooManyJokersCopyWith<$Res> implements $GameErrorCopyWith<$Res> {
  factory $TooManyJokersCopyWith(TooManyJokers value, $Res Function(TooManyJokers) _then) = _$TooManyJokersCopyWithImpl;
@useResult
$Res call({
 int count, int max
});




}
/// @nodoc
class _$TooManyJokersCopyWithImpl<$Res>
    implements $TooManyJokersCopyWith<$Res> {
  _$TooManyJokersCopyWithImpl(this._self, this._then);

  final TooManyJokers _self;
  final $Res Function(TooManyJokers) _then;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,Object? max = null,}) {
  return _then(TooManyJokers(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class MeldAllJokers extends GameError {
  const MeldAllJokers(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeldAllJokers);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.meldAllJokers()';
}


}




/// @nodoc


class EmptyProposal extends GameError {
  const EmptyProposal(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmptyProposal);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.emptyProposal()';
}


}




/// @nodoc


class DuplicateTileInProposal extends GameError {
  const DuplicateTileInProposal({required this.tileId}): super._();
  

 final  int tileId;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DuplicateTileInProposalCopyWith<DuplicateTileInProposal> get copyWith => _$DuplicateTileInProposalCopyWithImpl<DuplicateTileInProposal>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DuplicateTileInProposal&&(identical(other.tileId, tileId) || other.tileId == tileId));
}


@override
int get hashCode => Object.hash(runtimeType,tileId);

@override
String toString() {
  return 'GameError.duplicateTileInProposal(tileId: $tileId)';
}


}

/// @nodoc
abstract mixin class $DuplicateTileInProposalCopyWith<$Res> implements $GameErrorCopyWith<$Res> {
  factory $DuplicateTileInProposalCopyWith(DuplicateTileInProposal value, $Res Function(DuplicateTileInProposal) _then) = _$DuplicateTileInProposalCopyWithImpl;
@useResult
$Res call({
 int tileId
});




}
/// @nodoc
class _$DuplicateTileInProposalCopyWithImpl<$Res>
    implements $DuplicateTileInProposalCopyWith<$Res> {
  _$DuplicateTileInProposalCopyWithImpl(this._self, this._then);

  final DuplicateTileInProposal _self;
  final $Res Function(DuplicateTileInProposal) _then;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tileId = null,}) {
  return _then(DuplicateTileInProposal(
tileId: null == tileId ? _self.tileId : tileId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class OpenThresholdNotMet extends GameError {
  const OpenThresholdNotMet({required this.requiredPoints, required this.actualPoints}): super._();
  

 final  int requiredPoints;
 final  int actualPoints;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenThresholdNotMetCopyWith<OpenThresholdNotMet> get copyWith => _$OpenThresholdNotMetCopyWithImpl<OpenThresholdNotMet>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenThresholdNotMet&&(identical(other.requiredPoints, requiredPoints) || other.requiredPoints == requiredPoints)&&(identical(other.actualPoints, actualPoints) || other.actualPoints == actualPoints));
}


@override
int get hashCode => Object.hash(runtimeType,requiredPoints,actualPoints);

@override
String toString() {
  return 'GameError.openThresholdNotMet(requiredPoints: $requiredPoints, actualPoints: $actualPoints)';
}


}

/// @nodoc
abstract mixin class $OpenThresholdNotMetCopyWith<$Res> implements $GameErrorCopyWith<$Res> {
  factory $OpenThresholdNotMetCopyWith(OpenThresholdNotMet value, $Res Function(OpenThresholdNotMet) _then) = _$OpenThresholdNotMetCopyWithImpl;
@useResult
$Res call({
 int requiredPoints, int actualPoints
});




}
/// @nodoc
class _$OpenThresholdNotMetCopyWithImpl<$Res>
    implements $OpenThresholdNotMetCopyWith<$Res> {
  _$OpenThresholdNotMetCopyWithImpl(this._self, this._then);

  final OpenThresholdNotMet _self;
  final $Res Function(OpenThresholdNotMet) _then;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? requiredPoints = null,Object? actualPoints = null,}) {
  return _then(OpenThresholdNotMet(
requiredPoints: null == requiredPoints ? _self.requiredPoints : requiredPoints // ignore: cast_nullable_to_non_nullable
as int,actualPoints: null == actualPoints ? _self.actualPoints : actualPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class AlreadyOpened extends GameError {
  const AlreadyOpened(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlreadyOpened);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.alreadyOpened()';
}


}




/// @nodoc


class NotOpenedYet extends GameError {
  const NotOpenedYet(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotOpenedYet);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.notOpenedYet()';
}


}




/// @nodoc


class CannotAddBeforeOpening extends GameError {
  const CannotAddBeforeOpening(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CannotAddBeforeOpening);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.cannotAddBeforeOpening()';
}


}




/// @nodoc


class NewMeldsAfterOpeningDisabled extends GameError {
  const NewMeldsAfterOpeningDisabled(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewMeldsAfterOpeningDisabled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.newMeldsAfterOpeningDisabled()';
}


}




/// @nodoc


class PairsPathViolation extends GameError {
  const PairsPathViolation(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PairsPathViolation);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.pairsPathViolation()';
}


}




/// @nodoc


class NotEnoughPairs extends GameError {
  const NotEnoughPairs({required this.requiredPairs, required this.actualPairs}): super._();
  

 final  int requiredPairs;
 final  int actualPairs;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotEnoughPairsCopyWith<NotEnoughPairs> get copyWith => _$NotEnoughPairsCopyWithImpl<NotEnoughPairs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotEnoughPairs&&(identical(other.requiredPairs, requiredPairs) || other.requiredPairs == requiredPairs)&&(identical(other.actualPairs, actualPairs) || other.actualPairs == actualPairs));
}


@override
int get hashCode => Object.hash(runtimeType,requiredPairs,actualPairs);

@override
String toString() {
  return 'GameError.notEnoughPairs(requiredPairs: $requiredPairs, actualPairs: $actualPairs)';
}


}

/// @nodoc
abstract mixin class $NotEnoughPairsCopyWith<$Res> implements $GameErrorCopyWith<$Res> {
  factory $NotEnoughPairsCopyWith(NotEnoughPairs value, $Res Function(NotEnoughPairs) _then) = _$NotEnoughPairsCopyWithImpl;
@useResult
$Res call({
 int requiredPairs, int actualPairs
});




}
/// @nodoc
class _$NotEnoughPairsCopyWithImpl<$Res>
    implements $NotEnoughPairsCopyWith<$Res> {
  _$NotEnoughPairsCopyWithImpl(this._self, this._then);

  final NotEnoughPairs _self;
  final $Res Function(NotEnoughPairs) _then;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? requiredPairs = null,Object? actualPairs = null,}) {
  return _then(NotEnoughPairs(
requiredPairs: null == requiredPairs ? _self.requiredPairs : requiredPairs // ignore: cast_nullable_to_non_nullable
as int,actualPairs: null == actualPairs ? _self.actualPairs : actualPairs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class InvalidPair extends GameError {
  const InvalidPair(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidPair);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.invalidPair()';
}


}




/// @nodoc


class MeldNotFound extends GameError {
  const MeldNotFound({required this.meldId}): super._();
  

 final  int meldId;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeldNotFoundCopyWith<MeldNotFound> get copyWith => _$MeldNotFoundCopyWithImpl<MeldNotFound>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeldNotFound&&(identical(other.meldId, meldId) || other.meldId == meldId));
}


@override
int get hashCode => Object.hash(runtimeType,meldId);

@override
String toString() {
  return 'GameError.meldNotFound(meldId: $meldId)';
}


}

/// @nodoc
abstract mixin class $MeldNotFoundCopyWith<$Res> implements $GameErrorCopyWith<$Res> {
  factory $MeldNotFoundCopyWith(MeldNotFound value, $Res Function(MeldNotFound) _then) = _$MeldNotFoundCopyWithImpl;
@useResult
$Res call({
 int meldId
});




}
/// @nodoc
class _$MeldNotFoundCopyWithImpl<$Res>
    implements $MeldNotFoundCopyWith<$Res> {
  _$MeldNotFoundCopyWithImpl(this._self, this._then);

  final MeldNotFound _self;
  final $Res Function(MeldNotFound) _then;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? meldId = null,}) {
  return _then(MeldNotFound(
meldId: null == meldId ? _self.meldId : meldId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class TileDoesNotExtendMeld extends GameError {
  const TileDoesNotExtendMeld({required this.meldId, required this.tileId}): super._();
  

 final  int meldId;
 final  int tileId;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TileDoesNotExtendMeldCopyWith<TileDoesNotExtendMeld> get copyWith => _$TileDoesNotExtendMeldCopyWithImpl<TileDoesNotExtendMeld>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TileDoesNotExtendMeld&&(identical(other.meldId, meldId) || other.meldId == meldId)&&(identical(other.tileId, tileId) || other.tileId == tileId));
}


@override
int get hashCode => Object.hash(runtimeType,meldId,tileId);

@override
String toString() {
  return 'GameError.tileDoesNotExtendMeld(meldId: $meldId, tileId: $tileId)';
}


}

/// @nodoc
abstract mixin class $TileDoesNotExtendMeldCopyWith<$Res> implements $GameErrorCopyWith<$Res> {
  factory $TileDoesNotExtendMeldCopyWith(TileDoesNotExtendMeld value, $Res Function(TileDoesNotExtendMeld) _then) = _$TileDoesNotExtendMeldCopyWithImpl;
@useResult
$Res call({
 int meldId, int tileId
});




}
/// @nodoc
class _$TileDoesNotExtendMeldCopyWithImpl<$Res>
    implements $TileDoesNotExtendMeldCopyWith<$Res> {
  _$TileDoesNotExtendMeldCopyWithImpl(this._self, this._then);

  final TileDoesNotExtendMeld _self;
  final $Res Function(TileDoesNotExtendMeld) _then;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? meldId = null,Object? tileId = null,}) {
  return _then(TileDoesNotExtendMeld(
meldId: null == meldId ? _self.meldId : meldId // ignore: cast_nullable_to_non_nullable
as int,tileId: null == tileId ? _self.tileId : tileId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class NotAJokerAtPosition extends GameError {
  const NotAJokerAtPosition({required this.meldId, required this.index}): super._();
  

 final  int meldId;
 final  int index;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotAJokerAtPositionCopyWith<NotAJokerAtPosition> get copyWith => _$NotAJokerAtPositionCopyWithImpl<NotAJokerAtPosition>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotAJokerAtPosition&&(identical(other.meldId, meldId) || other.meldId == meldId)&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,meldId,index);

@override
String toString() {
  return 'GameError.notAJokerAtPosition(meldId: $meldId, index: $index)';
}


}

/// @nodoc
abstract mixin class $NotAJokerAtPositionCopyWith<$Res> implements $GameErrorCopyWith<$Res> {
  factory $NotAJokerAtPositionCopyWith(NotAJokerAtPosition value, $Res Function(NotAJokerAtPosition) _then) = _$NotAJokerAtPositionCopyWithImpl;
@useResult
$Res call({
 int meldId, int index
});




}
/// @nodoc
class _$NotAJokerAtPositionCopyWithImpl<$Res>
    implements $NotAJokerAtPositionCopyWith<$Res> {
  _$NotAJokerAtPositionCopyWithImpl(this._self, this._then);

  final NotAJokerAtPosition _self;
  final $Res Function(NotAJokerAtPosition) _then;

/// Create a copy of GameError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? meldId = null,Object? index = null,}) {
  return _then(NotAJokerAtPosition(
meldId: null == meldId ? _self.meldId : meldId // ignore: cast_nullable_to_non_nullable
as int,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class JokerReplacementDisabled extends GameError {
  const JokerReplacementDisabled(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokerReplacementDisabled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.jokerReplacementDisabled()';
}


}




/// @nodoc


class CannotReplaceFalseJoker extends GameError {
  const CannotReplaceFalseJoker(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CannotReplaceFalseJoker);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.cannotReplaceFalseJoker()';
}


}




/// @nodoc


class JokerReplacementMismatch extends GameError {
  const JokerReplacementMismatch(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokerReplacementMismatch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.jokerReplacementMismatch()';
}


}




/// @nodoc


class HandNotOver extends GameError {
  const HandNotOver(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HandNotOver);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.handNotOver()';
}


}




/// @nodoc


class MatchAlreadyOver extends GameError {
  const MatchAlreadyOver(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchAlreadyOver);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.matchAlreadyOver()';
}


}




/// @nodoc


class MustDiscardToFinish extends GameError {
  const MustDiscardToFinish(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MustDiscardToFinish);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.mustDiscardToFinish()';
}


}




/// @nodoc


class NotEnoughTiles extends GameError {
  const NotEnoughTiles(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotEnoughTiles);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameError.notEnoughTiles()';
}


}




// dart format on
