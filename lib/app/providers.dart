import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okey101/core/feedback_service.dart';
import 'package:okey101/data/local_store.dart';
import 'package:okey101/data/models/app_settings.dart';
import 'package:okey101/data/models/saved_game.dart';
import 'package:okey101/data/models/wallet.dart';
import 'package:okey101/domain/models/hand_result.dart';
import 'package:okey101/domain/models/rule_set.dart';

/// Riverpod 3.x manual API only - no code generation anywhere in this project.

/// Overridden in `main()` once shared_preferences has loaded.
final localStoreProvider = Provider<LocalStore>(
  (ref) => throw StateError('localStoreProvider must be overridden in main()'),
);

/// The clock, injected. The domain never reads it; only persistence and seeding
/// do, and they go through here so tests can pin time.
final nowProvider = Provider<int Function()>(
  (ref) => () => DateTime.now().millisecondsSinceEpoch,
);

/// Haptics behind an interface. The web build gets the no-op.
final feedbackProvider = Provider<FeedbackService>(
  (ref) => const NoopFeedbackService(),
);

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

final walletProvider = NotifierProvider<WalletNotifier, Wallet>(
  WalletNotifier.new,
);

class WalletNotifier extends Notifier<Wallet> {
  @override
  Wallet build() => ref.read(localStoreProvider).loadWallet();

  /// Hands over a top-up. The game is free and sells nothing, so there is no
  /// purchase to make and no receipt to check - the button simply gives.
  void topUpGold() {
    state = state.copyWith(gold: state.gold + Wallet.topUpAmount);
    unawaited(ref.read(localStoreProvider).saveWallet(state));
  }
}

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(localStoreProvider).loadSettings();

  void update(AppSettings Function(AppSettings) change) {
    state = change(state);
    unawaited(ref.read(localStoreProvider).saveSettings(state));
  }

  void setLanguage(String code) =>
      update((s) => s.copyWith(languageCode: code));

  void setRuleSet(RuleSet rules) => update((s) => s.copyWith(ruleSet: rules));

  void resetRules() =>
      update((s) => s.copyWith(ruleSet: RulePresets.standard));

  /// Back to factory defaults, including the language.
  void resetAll() => update((_) => const AppSettings());
}

/// Active UI locale, derived from the persisted setting.
final localeProvider = Provider<Locale>(
  (ref) => Locale(ref.watch(settingsProvider).languageCode),
);

final historyProvider =
    NotifierProvider<HistoryNotifier, List<MatchRecord>>(HistoryNotifier.new);

class HistoryNotifier extends Notifier<List<MatchRecord>> {
  @override
  List<MatchRecord> build() => ref.read(localStoreProvider).loadHistory();

  void add(MatchRecord record) {
    state = [...state, record];
    unawaited(ref.read(localStoreProvider).saveHistory(state));
  }

  void clear() {
    state = const <MatchRecord>[];
    unawaited(ref.read(localStoreProvider).clearHistory());
  }

  String exportJson() =>
      ref.read(localStoreProvider).exportHistoryJson(state);
}

/// The saved game found at start-up, if any. Read once; the game controller
/// owns it after that.
final savedGameProvider = Provider<SavedGame?>(
  (ref) => ref.read(localStoreProvider).loadSavedGame(),
);
