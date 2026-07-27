// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hand_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerHandResult _$PlayerHandResultFromJson(Map<String, dynamic> json) =>
    _PlayerHandResult(
      seat: (json['seat'] as num).toInt(),
      deadwood: (json['deadwood'] as num).toInt(),
      hasOpened: json['hasOpened'] as bool,
      delta: (json['delta'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$PlayerHandResultToJson(_PlayerHandResult instance) =>
    <String, dynamic>{
      'seat': instance.seat,
      'deadwood': instance.deadwood,
      'hasOpened': instance.hasOpened,
      'delta': instance.delta,
      'total': instance.total,
    };

_HandResult _$HandResultFromJson(Map<String, dynamic> json) => _HandResult(
  handNumber: (json['handNumber'] as num).toInt(),
  winnerSeat: (json['winnerSeat'] as num?)?.toInt(),
  finishType: $enumDecodeNullable(_$FinishTypeEnumMap, json['finishType']),
  rowKey: $enumDecode(_$ScoreRowKeyEnumMap, json['rowKey']),
  players: (json['players'] as List<dynamic>)
      .map((e) => PlayerHandResult.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$HandResultToJson(_HandResult instance) =>
    <String, dynamic>{
      'handNumber': instance.handNumber,
      'winnerSeat': instance.winnerSeat,
      'finishType': _$FinishTypeEnumMap[instance.finishType],
      'rowKey': _$ScoreRowKeyEnumMap[instance.rowKey]!,
      'players': instance.players.map((e) => e.toJson()).toList(),
    };

const _$FinishTypeEnumMap = {
  FinishType.normal: 'normal',
  FinishType.head: 'head',
  FinishType.pairs: 'pairs',
  FinishType.withOkey: 'withOkey',
  FinishType.okeyHead: 'okeyHead',
  FinishType.pairsWithOkey: 'pairsWithOkey',
};

const _$ScoreRowKeyEnumMap = {
  ScoreRowKey.normal: 'normal',
  ScoreRowKey.head: 'head',
  ScoreRowKey.pairs: 'pairs',
  ScoreRowKey.withOkey: 'withOkey',
  ScoreRowKey.okeyHead: 'okeyHead',
  ScoreRowKey.pairsWithOkey: 'pairsWithOkey',
  ScoreRowKey.exhausted: 'exhausted',
};

_MatchRecord _$MatchRecordFromJson(Map<String, dynamic> json) => _MatchRecord(
  id: json['id'] as String,
  timestampMs: (json['timestampMs'] as num).toInt(),
  playerNames: (json['playerNames'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  finalScores: (json['finalScores'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  winnerSeat: (json['winnerSeat'] as num).toInt(),
  handsPlayed: (json['handsPlayed'] as num).toInt(),
  preset: $enumDecode(_$RulePresetEnumMap, json['preset']),
);

Map<String, dynamic> _$MatchRecordToJson(_MatchRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestampMs': instance.timestampMs,
      'playerNames': instance.playerNames,
      'finalScores': instance.finalScores,
      'winnerSeat': instance.winnerSeat,
      'handsPlayed': instance.handsPlayed,
      'preset': _$RulePresetEnumMap[instance.preset]!,
    };

const _$RulePresetEnumMap = {
  RulePreset.standard: 'standard',
  RulePreset.aggressive: 'aggressive',
  RulePreset.custom: 'custom',
};
