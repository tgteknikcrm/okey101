// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavedGame _$SavedGameFromJson(Map<String, dynamic> json) => _SavedGame(
  state: GameState.fromJson(json['state'] as Map<String, dynamic>),
  rackSlots: (json['rackSlots'] as List<dynamic>)
      .map((e) => (e as num?)?.toInt())
      .toList(),
  savedAtMs: (json['savedAtMs'] as num).toInt(),
  version: (json['version'] as num?)?.toInt() ?? SavedGame.currentVersion,
);

Map<String, dynamic> _$SavedGameToJson(_SavedGame instance) =>
    <String, dynamic>{
      'state': instance.state.toJson(),
      'rackSlots': instance.rackSlots,
      'savedAtMs': instance.savedAtMs,
      'version': instance.version,
    };
