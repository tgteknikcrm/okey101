import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:okey101/domain/models/scoring.dart';

part 'rule_set.freezed.dart';
part 'rule_set.g.dart';

enum RulePreset { standard, aggressive, custom }

/// Who deals/opens the next hand.
enum StartingPlayerRotation { rotate, fixed, seededRandom }

/// What to do when the tile flipped for the indicator turns out to be a false
/// joker, which has no colour or number of its own and therefore cannot derive
/// an okey.
///
/// Both options end with a numbered tile as the indicator, so nothing
/// downstream ever has to cope with an okey-less hand.
enum FalseJokerIndicatorPolicy {
  /// Put it back, reshuffle the whole deck, flip again. The default.
  reshuffle,

  /// Leave the deck alone and simply flip the next tile.
  drawNext,
}

/// What happens when the 20-tile draw pile runs out with nobody having gone
/// out. With only 20 draws this is a main-line outcome, not an edge case.
enum DeckExhaustedPolicy { scoreDeadwood, voidHand }

/// Which end condition(s) terminate a match.
enum MatchEndMode { handsOnly, targetOnly, both }

/// Every configurable rule in one place. Nothing in the engine reads a
/// hardcoded rule constant; it all comes from here.
@freezed
abstract class RuleSet with _$RuleSet {
  const RuleSet._();

  const factory RuleSet({
    @Default(RulePreset.standard) RulePreset preset,

    // --- Opening -----------------------------------------------------------
    /// Minimum points that must go down in a single turn to open.
    @Default(101) int openThreshold,

    /// "Katlamali acma": the n-th player to open in a hand needs
    /// `openThreshold - 1 + n`. Resets at the start of every hand.
    @Default(false) bool escalatingOpenThreshold,

    /// Only consulted in the faithful-simulation mode below. The normal UI and
    /// engine validate before the player commits, so no penalty is ever
    /// incurred by accident.
    @Default(101) int illegalOpenPenalty,

    /// Faithful-simulation mode: allow an under-threshold open attempt to be
    /// committed and punished instead of rejected. Off by default.
    @Default(false) bool enforceIllegalOpenPenalty,

    // --- Melds -------------------------------------------------------------
    /// 12-13-1 and 13-1-2 are invalid by default. This is the single most
    /// commonly mis-implemented Okey 101 rule.
    @Default(false) bool allowCircularRuns,

    /// A run laid on the table may not exceed this. The limit applies ONLY at
    /// lay-down; a table run may be extended past it via addToMeld.
    @Default(5) int maxRunLengthOnLayDown,

    @Default(1) int maxJokersPerMeld,

    // --- Pairs path --------------------------------------------------------
    @Default(5) int minPairsToOpen,
    @Default(11) int pairsToFinish,

    // --- After opening -----------------------------------------------------
    @Default(true) bool canLayNewMeldsAfterOpening,
    @Default(true) bool canReplaceJokerOnTable,
    @Default(true) bool canTakeDiscardBeforeOpening,

    // --- Scoring -----------------------------------------------------------
    /// An okey left on the rack scores this much deadwood. A false joker is not
    /// wild, so it scores the indicator's number like any ordinary tile.
    @Default(25) int okeyDeadwoodValue,
    @Default(DeckExhaustedPolicy.scoreDeadwood)
    DeckExhaustedPolicy onDeckExhausted,
    @Default(ScoringTable()) ScoringTable scoringTable,

    // --- Match shape -------------------------------------------------------
    @Default(11) int handsPerMatch,
    @Default(-500) int targetScore,
    @Default(MatchEndMode.both) MatchEndMode matchEndMode,
    @Default(StartingPlayerRotation.rotate)
    StartingPlayerRotation startingPlayerRotation,
    @Default(FalseJokerIndicatorPolicy.reshuffle)
    FalseJokerIndicatorPolicy falseJokerAsIndicator,
  }) = _RuleSet;

  factory RuleSet.fromJson(Map<String, dynamic> json) =>
      _$RuleSetFromJson(json);

  /// Points the [openOrder]-th player to open in this hand must lay down.
  /// [openOrder] is zero based, so the first opener needs [openThreshold].
  int openThresholdFor(int openOrder) => escalatingOpenThreshold
      ? openThreshold - 1 + (openOrder + 1)
      : openThreshold;
}

/// The shipped presets. These are plain factories rather than freezed
/// constructors so freezed does not mistake them for union cases.
abstract final class RulePresets {
  static const RuleSet standard = RuleSet();

  static RuleSet get aggressive => RuleSet(
        preset: RulePreset.aggressive,
        scoringTable: const ScoringTable().doubled,
      );

  static RuleSet of(RulePreset preset) => switch (preset) {
        RulePreset.standard => standard,
        RulePreset.aggressive => aggressive,
        RulePreset.custom => standard.copyWith(preset: RulePreset.custom),
      };
}
