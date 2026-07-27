// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerState _$PlayerStateFromJson(Map<String, dynamic> json) => _PlayerState(
  seat: (json['seat'] as num).toInt(),
  name: json['name'] as String,
  isHuman: json['isHuman'] as bool,
  hand: (json['hand'] as List<dynamic>)
      .map((e) => Tile.fromJson(e as Map<String, dynamic>))
      .toList(),
  discards: (json['discards'] as List<dynamic>)
      .map((e) => Tile.fromJson(e as Map<String, dynamic>))
      .toList(),
  hasOpened: json['hasOpened'] as bool? ?? false,
  openedWithPairs: json['openedWithPairs'] as bool? ?? false,
  openOrder: (json['openOrder'] as num?)?.toInt() ?? -1,
  score: (json['score'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PlayerStateToJson(_PlayerState instance) =>
    <String, dynamic>{
      'seat': instance.seat,
      'name': instance.name,
      'isHuman': instance.isHuman,
      'hand': instance.hand.map((e) => e.toJson()).toList(),
      'discards': instance.discards.map((e) => e.toJson()).toList(),
      'hasOpened': instance.hasOpened,
      'openedWithPairs': instance.openedWithPairs,
      'openOrder': instance.openOrder,
      'score': instance.score,
    };

_GameState _$GameStateFromJson(Map<String, dynamic> json) => _GameState(
  ruleSet: RuleSet.fromJson(json['ruleSet'] as Map<String, dynamic>),
  seed: (json['seed'] as num).toInt(),
  randomState: (json['randomState'] as num).toInt(),
  handNumber: (json['handNumber'] as num).toInt(),
  startingSeat: (json['startingSeat'] as num).toInt(),
  indicator: Tile.fromJson(json['indicator'] as Map<String, dynamic>),
  okey: TileIdentity.fromJson(json['okey'] as Map<String, dynamic>),
  drawPile: (json['drawPile'] as List<dynamic>)
      .map((e) => Tile.fromJson(e as Map<String, dynamic>))
      .toList(),
  players: (json['players'] as List<dynamic>)
      .map((e) => PlayerState.fromJson(e as Map<String, dynamic>))
      .toList(),
  table: (json['table'] as List<dynamic>)
      .map((e) => Meld.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentSeat: (json['currentSeat'] as num).toInt(),
  phase: $enumDecode(_$TurnPhaseEnumMap, json['phase']),
  takenFromDiscardTileId: (json['takenFromDiscardTileId'] as num?)?.toInt(),
  openedThisTurn: json['openedThisTurn'] as bool? ?? false,
  nextMeldId: (json['nextMeldId'] as num?)?.toInt() ?? 0,
  openedCount: (json['openedCount'] as num?)?.toInt() ?? 0,
  handResult: json['handResult'] == null
      ? null
      : HandResult.fromJson(json['handResult'] as Map<String, dynamic>),
  history:
      (json['history'] as List<dynamic>?)
          ?.map((e) => HandResult.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <HandResult>[],
);

Map<String, dynamic> _$GameStateToJson(_GameState instance) =>
    <String, dynamic>{
      'ruleSet': instance.ruleSet.toJson(),
      'seed': instance.seed,
      'randomState': instance.randomState,
      'handNumber': instance.handNumber,
      'startingSeat': instance.startingSeat,
      'indicator': instance.indicator.toJson(),
      'okey': instance.okey.toJson(),
      'drawPile': instance.drawPile.map((e) => e.toJson()).toList(),
      'players': instance.players.map((e) => e.toJson()).toList(),
      'table': instance.table.map((e) => e.toJson()).toList(),
      'currentSeat': instance.currentSeat,
      'phase': _$TurnPhaseEnumMap[instance.phase]!,
      'takenFromDiscardTileId': instance.takenFromDiscardTileId,
      'openedThisTurn': instance.openedThisTurn,
      'nextMeldId': instance.nextMeldId,
      'openedCount': instance.openedCount,
      'handResult': instance.handResult?.toJson(),
      'history': instance.history.map((e) => e.toJson()).toList(),
    };

const _$TurnPhaseEnumMap = {
  TurnPhase.awaitingDraw: 'awaitingDraw',
  TurnPhase.awaitingDiscard: 'awaitingDiscard',
  TurnPhase.handOver: 'handOver',
  TurnPhase.matchOver: 'matchOver',
};
