// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  languageCode: json['languageCode'] as String? ?? 'tr',
  colorblind: json['colorblind'] as bool? ?? false,
  fastMode: json['fastMode'] as bool? ?? false,
  animations: json['animations'] as bool? ?? true,
  keepScreenAwake: json['keepScreenAwake'] as bool? ?? true,
  difficulty:
      $enumDecodeNullable(_$BotDifficultyEnumMap, json['difficulty']) ??
      BotDifficulty.medium,
  ruleSet: json['ruleSet'] == null
      ? const RuleSet()
      : RuleSet.fromJson(json['ruleSet'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'languageCode': instance.languageCode,
      'colorblind': instance.colorblind,
      'fastMode': instance.fastMode,
      'animations': instance.animations,
      'keepScreenAwake': instance.keepScreenAwake,
      'difficulty': _$BotDifficultyEnumMap[instance.difficulty]!,
      'ruleSet': instance.ruleSet.toJson(),
    };

const _$BotDifficultyEnumMap = {
  BotDifficulty.easy: 'easy',
  BotDifficulty.medium: 'medium',
  BotDifficulty.hard: 'hard',
};
