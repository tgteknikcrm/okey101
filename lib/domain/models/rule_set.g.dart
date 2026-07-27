// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RuleSet _$RuleSetFromJson(Map<String, dynamic> json) => _RuleSet(
  preset:
      $enumDecodeNullable(_$RulePresetEnumMap, json['preset']) ??
      RulePreset.standard,
  openThreshold: (json['openThreshold'] as num?)?.toInt() ?? 101,
  escalatingOpenThreshold: json['escalatingOpenThreshold'] as bool? ?? false,
  illegalOpenPenalty: (json['illegalOpenPenalty'] as num?)?.toInt() ?? 101,
  enforceIllegalOpenPenalty:
      json['enforceIllegalOpenPenalty'] as bool? ?? false,
  allowCircularRuns: json['allowCircularRuns'] as bool? ?? false,
  maxRunLengthOnLayDown: (json['maxRunLengthOnLayDown'] as num?)?.toInt() ?? 5,
  maxJokersPerMeld: (json['maxJokersPerMeld'] as num?)?.toInt() ?? 1,
  minPairsToOpen: (json['minPairsToOpen'] as num?)?.toInt() ?? 5,
  pairsToFinish: (json['pairsToFinish'] as num?)?.toInt() ?? 11,
  canLayNewMeldsAfterOpening:
      json['canLayNewMeldsAfterOpening'] as bool? ?? true,
  canReplaceJokerOnTable: json['canReplaceJokerOnTable'] as bool? ?? true,
  canTakeDiscardBeforeOpening:
      json['canTakeDiscardBeforeOpening'] as bool? ?? true,
  okeyDeadwoodValue: (json['okeyDeadwoodValue'] as num?)?.toInt() ?? 25,
  onDeckExhausted:
      $enumDecodeNullable(
        _$DeckExhaustedPolicyEnumMap,
        json['onDeckExhausted'],
      ) ??
      DeckExhaustedPolicy.scoreDeadwood,
  scoringTable: json['scoringTable'] == null
      ? const ScoringTable()
      : ScoringTable.fromJson(json['scoringTable'] as Map<String, dynamic>),
  handsPerMatch: (json['handsPerMatch'] as num?)?.toInt() ?? 11,
  targetScore: (json['targetScore'] as num?)?.toInt() ?? -500,
  matchEndMode:
      $enumDecodeNullable(_$MatchEndModeEnumMap, json['matchEndMode']) ??
      MatchEndMode.both,
  startingPlayerRotation:
      $enumDecodeNullable(
        _$StartingPlayerRotationEnumMap,
        json['startingPlayerRotation'],
      ) ??
      StartingPlayerRotation.rotate,
  falseJokerAsIndicator:
      $enumDecodeNullable(
        _$FalseJokerIndicatorPolicyEnumMap,
        json['falseJokerAsIndicator'],
      ) ??
      FalseJokerIndicatorPolicy.reshuffle,
);

Map<String, dynamic> _$RuleSetToJson(_RuleSet instance) => <String, dynamic>{
  'preset': _$RulePresetEnumMap[instance.preset]!,
  'openThreshold': instance.openThreshold,
  'escalatingOpenThreshold': instance.escalatingOpenThreshold,
  'illegalOpenPenalty': instance.illegalOpenPenalty,
  'enforceIllegalOpenPenalty': instance.enforceIllegalOpenPenalty,
  'allowCircularRuns': instance.allowCircularRuns,
  'maxRunLengthOnLayDown': instance.maxRunLengthOnLayDown,
  'maxJokersPerMeld': instance.maxJokersPerMeld,
  'minPairsToOpen': instance.minPairsToOpen,
  'pairsToFinish': instance.pairsToFinish,
  'canLayNewMeldsAfterOpening': instance.canLayNewMeldsAfterOpening,
  'canReplaceJokerOnTable': instance.canReplaceJokerOnTable,
  'canTakeDiscardBeforeOpening': instance.canTakeDiscardBeforeOpening,
  'okeyDeadwoodValue': instance.okeyDeadwoodValue,
  'onDeckExhausted': _$DeckExhaustedPolicyEnumMap[instance.onDeckExhausted]!,
  'scoringTable': instance.scoringTable.toJson(),
  'handsPerMatch': instance.handsPerMatch,
  'targetScore': instance.targetScore,
  'matchEndMode': _$MatchEndModeEnumMap[instance.matchEndMode]!,
  'startingPlayerRotation':
      _$StartingPlayerRotationEnumMap[instance.startingPlayerRotation]!,
  'falseJokerAsIndicator':
      _$FalseJokerIndicatorPolicyEnumMap[instance.falseJokerAsIndicator]!,
};

const _$RulePresetEnumMap = {
  RulePreset.standard: 'standard',
  RulePreset.aggressive: 'aggressive',
  RulePreset.custom: 'custom',
};

const _$DeckExhaustedPolicyEnumMap = {
  DeckExhaustedPolicy.scoreDeadwood: 'scoreDeadwood',
  DeckExhaustedPolicy.voidHand: 'voidHand',
};

const _$MatchEndModeEnumMap = {
  MatchEndMode.handsOnly: 'handsOnly',
  MatchEndMode.targetOnly: 'targetOnly',
  MatchEndMode.both: 'both',
};

const _$StartingPlayerRotationEnumMap = {
  StartingPlayerRotation.rotate: 'rotate',
  StartingPlayerRotation.fixed: 'fixed',
  StartingPlayerRotation.seededRandom: 'seededRandom',
};

const _$FalseJokerIndicatorPolicyEnumMap = {
  FalseJokerIndicatorPolicy.reshuffle: 'reshuffle',
  FalseJokerIndicatorPolicy.drawNext: 'drawNext',
};
