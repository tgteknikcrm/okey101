// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meld.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Meld _$MeldFromJson(Map<String, dynamic> json) => _Meld(
  id: (json['id'] as num).toInt(),
  kind: $enumDecode(_$MeldKindEnumMap, json['kind']),
  ownerSeat: (json['ownerSeat'] as num).toInt(),
  tiles: (json['tiles'] as List<dynamic>)
      .map((e) => Tile.fromJson(e as Map<String, dynamic>))
      .toList(),
  jokerAssignments: (json['jokerAssignments'] as List<dynamic>)
      .map(
        (e) =>
            e == null ? null : TileIdentity.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$MeldToJson(_Meld instance) => <String, dynamic>{
  'id': instance.id,
  'kind': _$MeldKindEnumMap[instance.kind]!,
  'ownerSeat': instance.ownerSeat,
  'tiles': instance.tiles.map((e) => e.toJson()).toList(),
  'jokerAssignments': instance.jokerAssignments
      .map((e) => e?.toJson())
      .toList(),
};

const _$MeldKindEnumMap = {
  MeldKind.run: 'run',
  MeldKind.set: 'set',
  MeldKind.pair: 'pair',
};

_MeldProposal _$MeldProposalFromJson(Map<String, dynamic> json) =>
    _MeldProposal(
      kind: $enumDecode(_$MeldKindEnumMap, json['kind']),
      tileIds: (json['tileIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$MeldProposalToJson(_MeldProposal instance) =>
    <String, dynamic>{
      'kind': _$MeldKindEnumMap[instance.kind]!,
      'tileIds': instance.tileIds,
    };
