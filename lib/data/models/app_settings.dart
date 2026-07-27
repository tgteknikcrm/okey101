import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:okey101/domain/ai/bot_brain.dart';
import 'package:okey101/domain/models/rule_set.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// Everything the player can change, persisted as one JSON blob in
/// localStorage via shared_preferences.
@freezed
abstract class AppSettings with _$AppSettings {
  const AppSettings._();

  const factory AppSettings({
    /// 'tr' or 'en'. Turkish is the default.
    @Default('tr') String languageCode,

    /// Adds a colour glyph to every tile. The whole game is colour coded, so
    /// this is not optional for a lot of people.
    @Default(false) bool colorblind,

    /// Bots play without their think delay.
    @Default(false) bool fastMode,
    @Default(true) bool animations,
    @Default(true) bool keepScreenAwake,
    @Default(BotDifficulty.medium) BotDifficulty difficulty,
    @Default(RuleSet()) RuleSet ruleSet,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
