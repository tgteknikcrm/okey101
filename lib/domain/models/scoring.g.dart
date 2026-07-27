// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scoring.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeadwoodMultiple _$DeadwoodMultipleFromJson(Map<String, dynamic> json) =>
    DeadwoodMultiple(
      multiplier: (json['multiplier'] as num).toInt(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$DeadwoodMultipleToJson(DeadwoodMultiple instance) =>
    <String, dynamic>{
      'multiplier': instance.multiplier,
      'type': instance.$type,
    };

FlatPenalty _$FlatPenaltyFromJson(Map<String, dynamic> json) => FlatPenalty(
  points: (json['points'] as num).toInt(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$FlatPenaltyToJson(FlatPenalty instance) =>
    <String, dynamic>{'points': instance.points, 'type': instance.$type};

_ScoringRow _$ScoringRowFromJson(Map<String, dynamic> json) => _ScoringRow(
  winnerPoints: (json['winnerPoints'] as num?)?.toInt(),
  opened: OpponentPenalty.fromJson(json['opened'] as Map<String, dynamic>),
  notOpened: OpponentPenalty.fromJson(
    json['notOpened'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ScoringRowToJson(_ScoringRow instance) =>
    <String, dynamic>{
      'winnerPoints': instance.winnerPoints,
      'opened': instance.opened.toJson(),
      'notOpened': instance.notOpened.toJson(),
    };

_ScoringTable _$ScoringTableFromJson(Map<String, dynamic> json) =>
    _ScoringTable(
      normal: json['normal'] == null
          ? const ScoringRow(
              winnerPoints: -101,
              opened: OpponentPenalty.deadwoodMultiple(multiplier: 1),
              notOpened: OpponentPenalty.flat(points: 202),
            )
          : ScoringRow.fromJson(json['normal'] as Map<String, dynamic>),
      head: json['head'] == null
          ? const ScoringRow(
              winnerPoints: -202,
              opened: OpponentPenalty.deadwoodMultiple(multiplier: 1),
              notOpened: OpponentPenalty.flat(points: 404),
            )
          : ScoringRow.fromJson(json['head'] as Map<String, dynamic>),
      pairs: json['pairs'] == null
          ? const ScoringRow(
              winnerPoints: -202,
              opened: OpponentPenalty.deadwoodMultiple(multiplier: 2),
              notOpened: OpponentPenalty.flat(points: 404),
            )
          : ScoringRow.fromJson(json['pairs'] as Map<String, dynamic>),
      withOkey: json['withOkey'] == null
          ? const ScoringRow(
              winnerPoints: -202,
              opened: OpponentPenalty.deadwoodMultiple(multiplier: 2),
              notOpened: OpponentPenalty.flat(points: 404),
            )
          : ScoringRow.fromJson(json['withOkey'] as Map<String, dynamic>),
      okeyHead: json['okeyHead'] == null
          ? const ScoringRow(
              winnerPoints: -404,
              opened: OpponentPenalty.deadwoodMultiple(multiplier: 2),
              notOpened: OpponentPenalty.flat(points: 808),
            )
          : ScoringRow.fromJson(json['okeyHead'] as Map<String, dynamic>),
      pairsWithOkey: json['pairsWithOkey'] == null
          ? const ScoringRow(
              winnerPoints: -404,
              opened: OpponentPenalty.deadwoodMultiple(multiplier: 4),
              notOpened: OpponentPenalty.flat(points: 808),
            )
          : ScoringRow.fromJson(json['pairsWithOkey'] as Map<String, dynamic>),
      exhausted: json['exhausted'] == null
          ? const ScoringRow(
              winnerPoints: null,
              opened: OpponentPenalty.deadwoodMultiple(multiplier: 1),
              notOpened: OpponentPenalty.deadwoodMultiple(multiplier: 1),
            )
          : ScoringRow.fromJson(json['exhausted'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScoringTableToJson(_ScoringTable instance) =>
    <String, dynamic>{
      'normal': instance.normal.toJson(),
      'head': instance.head.toJson(),
      'pairs': instance.pairs.toJson(),
      'withOkey': instance.withOkey.toJson(),
      'okeyHead': instance.okeyHead.toJson(),
      'pairsWithOkey': instance.pairsWithOkey.toJson(),
      'exhausted': instance.exhausted.toJson(),
    };
