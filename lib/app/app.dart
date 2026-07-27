import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okey101/app/providers.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/features/debug/debug_screen.dart';
import 'package:okey101/features/game/game_screen.dart';
import 'package:okey101/features/history/history_screen.dart';
import 'package:okey101/features/menu/menu_screen.dart';
import 'package:okey101/features/rules/rules_screen.dart';
import 'package:okey101/features/settings/settings_screen.dart';
import 'package:okey101/l10n/generated/app_localizations.dart';

abstract final class Routes {
  static const String menu = '/';
  static const String game = '/game';
  static const String settings = '/settings';
  static const String history = '/history';
  static const String rules = '/rules';
  static const String debug = '/debug';
}

class Okey101App extends ConsumerWidget {
  const Okey101App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildOkeyTheme(),
      initialRoute: Routes.menu,
      routes: {
        Routes.menu: (_) => const MenuScreen(),
        Routes.game: (_) => const GameScreen(),
        Routes.settings: (_) => const SettingsScreen(),
        Routes.history: (_) => const HistoryScreen(),
        Routes.rules: (_) => const RulesScreen(),
        Routes.debug: (_) => const DebugScreen(),
      },
    );
  }
}
