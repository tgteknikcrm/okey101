// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TileIdentity _$TileIdentityFromJson(Map<String, dynamic> json) =>
    _TileIdentity(
      color: $enumDecode(_$TileColorEnumMap, json['color']),
      number: (json['number'] as num).toInt(),
    );

Map<String, dynamic> _$TileIdentityToJson(_TileIdentity instance) =>
    <String, dynamic>{
      'color': _$TileColorEnumMap[instance.color]!,
      'number': instance.number,
    };

const _$TileColorEnumMap = {
  TileColor.red: 'red',
  TileColor.yellow: 'yellow',
  TileColor.black: 'black',
  TileColor.blue: 'blue',
};

_Tile _$TileFromJson(Map<String, dynamic> json) => _Tile(
  id: (json['id'] as num).toInt(),
  copyIndex: (json['copyIndex'] as num).toInt(),
  color: $enumDecodeNullable(_$TileColorEnumMap, json['color']),
  number: (json['number'] as num?)?.toInt(),
  isFalseJoker: json['isFalseJoker'] as bool? ?? false,
);

Map<String, dynamic> _$TileToJson(_Tile instance) => <String, dynamic>{
  'id': instance.id,
  'copyIndex': instance.copyIndex,
  'color': _$TileColorEnumMap[instance.color],
  'number': instance.number,
  'isFalseJoker': instance.isFalseJoker,
};
