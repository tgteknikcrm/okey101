// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrawFromPile _$DrawFromPileFromJson(Map<String, dynamic> json) =>
    DrawFromPile($type: json['type'] as String?);

Map<String, dynamic> _$DrawFromPileToJson(DrawFromPile instance) =>
    <String, dynamic>{'type': instance.$type};

DrawFromDiscard _$DrawFromDiscardFromJson(Map<String, dynamic> json) =>
    DrawFromDiscard($type: json['type'] as String?);

Map<String, dynamic> _$DrawFromDiscardToJson(DrawFromDiscard instance) =>
    <String, dynamic>{'type': instance.$type};

DiscardTile _$DiscardTileFromJson(Map<String, dynamic> json) => DiscardTile(
  tileId: (json['tileId'] as num).toInt(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$DiscardTileToJson(DiscardTile instance) =>
    <String, dynamic>{'tileId': instance.tileId, 'type': instance.$type};

OpenWithMelds _$OpenWithMeldsFromJson(Map<String, dynamic> json) =>
    OpenWithMelds(
      melds: (json['melds'] as List<dynamic>)
          .map((e) => MeldProposal.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$OpenWithMeldsToJson(OpenWithMelds instance) =>
    <String, dynamic>{
      'melds': instance.melds.map((e) => e.toJson()).toList(),
      'type': instance.$type,
    };

LayPairs _$LayPairsFromJson(Map<String, dynamic> json) => LayPairs(
  pairs: (json['pairs'] as List<dynamic>)
      .map((e) => MeldProposal.fromJson(e as Map<String, dynamic>))
      .toList(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$LayPairsToJson(LayPairs instance) => <String, dynamic>{
  'pairs': instance.pairs.map((e) => e.toJson()).toList(),
  'type': instance.$type,
};

LayNewMeld _$LayNewMeldFromJson(Map<String, dynamic> json) => LayNewMeld(
  meld: MeldProposal.fromJson(json['meld'] as Map<String, dynamic>),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$LayNewMeldToJson(LayNewMeld instance) =>
    <String, dynamic>{'meld': instance.meld.toJson(), 'type': instance.$type};

AddToMeld _$AddToMeldFromJson(Map<String, dynamic> json) => AddToMeld(
  meldId: (json['meldId'] as num).toInt(),
  tileId: (json['tileId'] as num).toInt(),
  atStart: json['atStart'] as bool? ?? false,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$AddToMeldToJson(AddToMeld instance) => <String, dynamic>{
  'meldId': instance.meldId,
  'tileId': instance.tileId,
  'atStart': instance.atStart,
  'type': instance.$type,
};

ReplaceJoker _$ReplaceJokerFromJson(Map<String, dynamic> json) => ReplaceJoker(
  meldId: (json['meldId'] as num).toInt(),
  index: (json['index'] as num).toInt(),
  tileId: (json['tileId'] as num).toInt(),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$ReplaceJokerToJson(ReplaceJoker instance) =>
    <String, dynamic>{
      'meldId': instance.meldId,
      'index': instance.index,
      'tileId': instance.tileId,
      'type': instance.$type,
    };

StartNextHand _$StartNextHandFromJson(Map<String, dynamic> json) =>
    StartNextHand($type: json['type'] as String?);

Map<String, dynamic> _$StartNextHandToJson(StartNextHand instance) =>
    <String, dynamic>{'type': instance.$type};
