import 'package:okey101/domain/models/game_error.dart';
import 'package:okey101/l10n/generated/app_localizations.dart';

/// Turns a typed [GameError] into a sentence that explains *why*.
///
/// Widgets never build these strings themselves, and no message is hardcoded -
/// every one of them comes from the ARB files.
String messageForError(AppLocalizations l10n, GameError error) =>
    switch (error) {
      NotYourTurn() => l10n.errNotYourTurn,
      WrongPhase() => l10n.errWrongPhase,
      TileNotInHand() => l10n.errTileNotInHand,
      DrawPileEmpty() => l10n.errDrawPileEmpty,
      DiscardPileEmpty() => l10n.errDiscardPileEmpty,
      SameTileDiscardedBack() => l10n.errSameTileDiscardedBack,
      TakeDiscardBeforeOpeningDisabled() =>
        l10n.errTakeDiscardBeforeOpeningDisabled,
      RunTooShort() => l10n.errRunTooShort,
      RunTooLongOnLayDown(:final max) => l10n.errRunTooLongOnLayDown(max),
      RunColorMismatch() => l10n.errRunColorMismatch,
      RunNotConsecutive() => l10n.errRunNotConsecutive,
      RunCannotWrap() => l10n.errRunCannotWrap,
      SetNumberMismatch() => l10n.errSetNumberMismatch,
      SetDuplicateColor() => l10n.errSetDuplicateColor,
      SetWrongSize() => l10n.errSetWrongSize,
      TooManyJokers(:final max) => l10n.errTooManyJokers(max),
      MeldAllJokers() => l10n.errMeldAllJokers,
      EmptyProposal() => l10n.errEmptyProposal,
      DuplicateTileInProposal() => l10n.errDuplicateTileInProposal,
      OpenThresholdNotMet(:final requiredPoints, :final actualPoints) =>
        l10n.errOpenThresholdNotMet(requiredPoints, actualPoints),
      AlreadyOpened() => l10n.errAlreadyOpened,
      NotOpenedYet() => l10n.errNotOpenedYet,
      CannotAddBeforeOpening() => l10n.errCannotAddBeforeOpening,
      NewMeldsAfterOpeningDisabled() => l10n.errNewMeldsAfterOpeningDisabled,
      PairsPathViolation() => l10n.errPairsPathViolation,
      NotEnoughPairs(:final requiredPairs, :final actualPairs) =>
        l10n.errNotEnoughPairs(requiredPairs, actualPairs),
      InvalidPair() => l10n.errInvalidPair,
      MeldNotFound() => l10n.errMeldNotFound,
      TileDoesNotExtendMeld() => l10n.errTileDoesNotExtendMeld,
      NotAJokerAtPosition() => l10n.errNotAJokerAtPosition,
      JokerReplacementDisabled() => l10n.errJokerReplacementDisabled,
      CannotReplaceFalseJoker() => l10n.errCannotReplaceFalseJoker,
      JokerReplacementMismatch() => l10n.errJokerReplacementMismatch,
      HandNotOver() => l10n.errHandNotOver,
      MatchAlreadyOver() => l10n.errMatchOver,
      MustDiscardToFinish() => l10n.errMustDiscardToFinish,
      NotEnoughTiles() => l10n.errNotEnoughTiles,
    };
