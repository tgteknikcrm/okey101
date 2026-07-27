import 'dart:convert';

import 'package:okey101/data/models/app_settings.dart';
import 'package:okey101/data/models/saved_game.dart';
import 'package:okey101/domain/models/hand_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The only persistence in the app.
///
/// `shared_preferences` maps to `window.localStorage` on the web, which gives
/// roughly 5 MB - plenty for settings, history and one saved game. Everything
/// is stored as a JSON string under a namespaced key.
///
/// iOS can evict web-app storage under memory pressure, which is why the
/// history can also be exported by hand from Settings.
class LocalStore {
  const LocalStore(this._prefs);

  final SharedPreferences _prefs;

  static const String settingsKey = 'okey101.settings.v1';
  static const String savedGameKey = 'okey101.savedGame.v1';
  static const String historyKey = 'okey101.history.v1';

  /// Keeping the history bounded keeps the whole store far under the quota.
  static const int maxHistoryEntries = 100;

  static Future<LocalStore> open() async =>
      LocalStore(await SharedPreferences.getInstance());

  // --- Settings ------------------------------------------------------------

  AppSettings loadSettings() {
    final raw = _prefs.getString(settingsKey);
    if (raw == null) return const AppSettings();
    try {
      return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      // A settings blob written by an older, incompatible build. Falling back
      // to defaults is always better than refusing to start.
      return const AppSettings();
    }
  }

  Future<void> saveSettings(AppSettings settings) =>
      _prefs.setString(settingsKey, jsonEncode(settings.toJson()));

  // --- In-progress game ----------------------------------------------------

  SavedGame? loadSavedGame() {
    final raw = _prefs.getString(savedGameKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final saved = SavedGame.fromJson(decoded);
      if (saved.version != SavedGame.currentVersion) return null;
      return saved;
    } on Object {
      return null;
    }
  }

  Future<void> saveGame(SavedGame game) =>
      _prefs.setString(savedGameKey, jsonEncode(game.toJson()));

  Future<void> clearSavedGame() => _prefs.remove(savedGameKey);

  // --- Match history -------------------------------------------------------

  List<MatchRecord> loadHistory() {
    final raw = _prefs.getString(historyKey);
    if (raw == null) return const <MatchRecord>[];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return <MatchRecord>[
        for (final entry in decoded)
          MatchRecord.fromJson(entry as Map<String, dynamic>),
      ];
    } on Object {
      return const <MatchRecord>[];
    }
  }

  Future<void> saveHistory(List<MatchRecord> history) {
    final trimmed = history.length > maxHistoryEntries
        ? history.sublist(history.length - maxHistoryEntries)
        : history;
    return _prefs.setString(
      historyKey,
      jsonEncode([for (final record in trimmed) record.toJson()]),
    );
  }

  Future<void> clearHistory() => _prefs.remove(historyKey);

  /// Pretty-printed history for the "export scores" button.
  String exportHistoryJson(List<MatchRecord> history) =>
      const JsonEncoder.withIndent('  ').convert({
        'app': 'okey101',
        'exportVersion': 1,
        'matches': [for (final record in history) record.toJson()],
      });

  Future<void> clearEverything() async {
    await _prefs.remove(settingsKey);
    await _prefs.remove(savedGameKey);
    await _prefs.remove(historyKey);
  }
}
