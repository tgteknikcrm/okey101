// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameLog _$GameLogFromJson(Map<String, dynamic> json) => _GameLog(
  seed: (json['seed'] as num).toInt(),
  ruleSet: RuleSet.fromJson(json['ruleSet'] as Map<String, dynamic>),
  playerNames: (json['playerNames'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  canonicalActions:
      (json['canonicalActions'] as List<dynamic>?)
          ?.map((e) => GameAction.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <GameAction>[],
);

Map<String, dynamic> _$GameLogToJson(_GameLog instance) => <String, dynamic>{
  'seed': instance.seed,
  'ruleSet': instance.ruleSet.toJson(),
  'playerNames': instance.playerNames,
  'canonicalActions': instance.canonicalActions.map((e) => e.toJson()).toList(),
};
