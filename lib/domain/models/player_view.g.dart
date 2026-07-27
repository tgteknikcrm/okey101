// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OpponentView _$OpponentViewFromJson(Map<String, dynamic> json) =>
    _OpponentView(
      seat: (json['seat'] as num).toInt(),
      name: json['name'] as String,
      tileCount: (json['tileCount'] as num).toInt(),
      hasOpened: json['hasOpened'] as bool,
      openedWithPairs: json['openedWithPairs'] as bool,
      score: (json['score'] as num).toInt(),
      discards: (json['discards'] as List<dynamic>)
          .map((e) => Tile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OpponentViewToJson(_OpponentView instance) =>
    <String, dynamic>{
      'seat': instance.seat,
      'name': instance.name,
      'tileCount': instance.tileCount,
      'hasOpened': instance.hasOpened,
      'openedWithPairs': instance.openedWithPairs,
      'score': instance.score,
      'discards': instance.discards.map((e) => e.toJson()).toList(),
    };

_PlayerView _$PlayerViewFromJson(Map<String, dynamic> json) => _PlayerView(
  ruleSet: RuleSet.fromJson(json['ruleSet'] as Map<String, dynamic>),
  seat: (json['seat'] as num).toInt(),
  name: json['name'] as String,
  hand: (json['hand'] as List<dynamic>)
      .map((e) => Tile.fromJson(e as Map<String, dynamic>))
      .toList(),
  indicator: Tile.fromJson(json['indicator'] as Map<String, dynamic>),
  okey: TileIdentity.fromJson(json['okey'] as Map<String, dynamic>),
  drawPileCount: (json['drawPileCount'] as num).toInt(),
  table: (json['table'] as List<dynamic>)
      .map((e) => Meld.fromJson(e as Map<String, dynamic>))
      .toList(),
  opponents: (json['opponents'] as List<dynamic>)
      .map((e) => OpponentView.fromJson(e as Map<String, dynamic>))
      .toList(),
  ownDiscards: (json['ownDiscards'] as List<dynamic>)
      .map((e) => Tile.fromJson(e as Map<String, dynamic>))
      .toList(),
  phase: $enumDecode(_$TurnPhaseEnumMap, json['phase']),
  hasOpened: json['hasOpened'] as bool,
  openedWithPairs: json['openedWithPairs'] as bool,
  openedCount: (json['openedCount'] as num).toInt(),
  handNumber: (json['handNumber'] as num).toInt(),
  score: (json['score'] as num).toInt(),
  takenFromDiscardTileId: (json['takenFromDiscardTileId'] as num?)?.toInt(),
);

Map<String, dynamic> _$PlayerViewToJson(_PlayerView instance) =>
    <String, dynamic>{
      'ruleSet': instance.ruleSet.toJson(),
      'seat': instance.seat,
      'name': instance.name,
      'hand': instance.hand.map((e) => e.toJson()).toList(),
      'indicator': instance.indicator.toJson(),
      'okey': instance.okey.toJson(),
      'drawPileCount': instance.drawPileCount,
      'table': instance.table.map((e) => e.toJson()).toList(),
      'opponents': instance.opponents.map((e) => e.toJson()).toList(),
      'ownDiscards': instance.ownDiscards.map((e) => e.toJson()).toList(),
      'phase': _$TurnPhaseEnumMap[instance.phase]!,
      'hasOpened': instance.hasOpened,
      'openedWithPairs': instance.openedWithPairs,
      'openedCount': instance.openedCount,
      'handNumber': instance.handNumber,
      'score': instance.score,
      'takenFromDiscardTileId': instance.takenFromDiscardTileId,
    };

const _$TurnPhaseEnumMap = {
  TurnPhase.awaitingDraw: 'awaitingDraw',
  TurnPhase.awaitingDiscard: 'awaitingDiscard',
  TurnPhase.handOver: 'handOver',
  TurnPhase.matchOver: 'matchOver',
};
