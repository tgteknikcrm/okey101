import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:okey101/domain/models/tile.dart';

part 'game_error.freezed.dart';

/// Every way an action can be rejected. Illegal actions return one of these;
/// the engine never throws and never silently no-ops.
@freezed
sealed class GameError with _$GameError {
  const GameError._();

  const factory GameError.notYourTurn({required int seat}) = NotYourTurn;
  const factory GameError.wrongPhase() = WrongPhase;
  const factory GameError.tileNotInHand({required int tileId}) = TileNotInHand;
  const factory GameError.drawPileEmpty() = DrawPileEmpty;
  const factory GameError.discardPileEmpty() = DiscardPileEmpty;
  const factory GameError.sameTileDiscardedBack({required int tileId}) =
      SameTileDiscardedBack;
  const factory GameError.takeDiscardBeforeOpeningDisabled() =
      TakeDiscardBeforeOpeningDisabled;

  const factory GameError.runTooShort({required int length}) = RunTooShort;
  const factory GameError.runTooLongOnLayDown({
    required int length,
    required int max,
  }) = RunTooLongOnLayDown;
  const factory GameError.runColorMismatch() = RunColorMismatch;
  const factory GameError.runNotConsecutive() = RunNotConsecutive;

  /// Returned instead of [RunNotConsecutive] when the tiles WOULD form a run if
  /// runs were circular, so the UI can say "a run cannot go from 13 to 1"
  /// rather than the generic message.
  const factory GameError.runCannotWrap() = RunCannotWrap;

  const factory GameError.setNumberMismatch() = SetNumberMismatch;
  const factory GameError.setDuplicateColor({required TileColor color}) =
      SetDuplicateColor;
  const factory GameError.setWrongSize({required int size}) = SetWrongSize;
  const factory GameError.tooManyJokers({
    required int count,
    required int max,
  }) = TooManyJokers;
  const factory GameError.meldAllJokers() = MeldAllJokers;
  const factory GameError.emptyProposal() = EmptyProposal;
  const factory GameError.duplicateTileInProposal({required int tileId}) =
      DuplicateTileInProposal;

  const factory GameError.openThresholdNotMet({
    required int requiredPoints,
    required int actualPoints,
  }) = OpenThresholdNotMet;
  const factory GameError.alreadyOpened() = AlreadyOpened;
  const factory GameError.notOpenedYet() = NotOpenedYet;
  const factory GameError.cannotAddBeforeOpening() = CannotAddBeforeOpening;
  const factory GameError.newMeldsAfterOpeningDisabled() =
      NewMeldsAfterOpeningDisabled;

  const factory GameError.pairsPathViolation() = PairsPathViolation;
  const factory GameError.notEnoughPairs({
    required int requiredPairs,
    required int actualPairs,
  }) = NotEnoughPairs;
  const factory GameError.invalidPair() = InvalidPair;

  const factory GameError.meldNotFound({required int meldId}) = MeldNotFound;
  const factory GameError.tileDoesNotExtendMeld({
    required int meldId,
    required int tileId,
  }) = TileDoesNotExtendMeld;
  const factory GameError.notAJokerAtPosition({
    required int meldId,
    required int index,
  }) = NotAJokerAtPosition;
  const factory GameError.jokerReplacementDisabled() =
      JokerReplacementDisabled;
  const factory GameError.cannotReplaceFalseJoker() = CannotReplaceFalseJoker;
  const factory GameError.jokerReplacementMismatch() =
      JokerReplacementMismatch;

  const factory GameError.handNotOver() = HandNotOver;
  const factory GameError.matchAlreadyOver() = MatchAlreadyOver;
  const factory GameError.mustDiscardToFinish() = MustDiscardToFinish;
  const factory GameError.notEnoughTiles() = NotEnoughTiles;
}
