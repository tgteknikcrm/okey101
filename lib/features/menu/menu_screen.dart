import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okey101/app/app.dart';
import 'package:okey101/app/providers.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/core/orientation_lock.dart';
import 'package:okey101/data/models/saved_game.dart';
import 'package:okey101/features/game/game_controller.dart';
import 'package:okey101/features/game/widgets/tile_widget.dart';
import 'package:okey101/l10n/generated/app_localizations.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  SavedGame? _saved;

  @override
  void initState() {
    super.initState();
    _refreshSaved();
  }

  void _refreshSaved() {
    setState(() {
      _saved = ref.read(localStoreProvider).loadSavedGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Stacked, the menu measures about 600 logical pixels. A landscape
            // phone is 390 tall, so everything below "New game" would sit under
            // the fold. Side by side it fits without scrolling.
            final wide = constraints.maxWidth > constraints.maxHeight &&
                constraints.maxHeight < 520;
            final brand = _Brand(compact: wide);
            final actions = _actions(l10n);

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: wide ? 12 : 32,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: wide ? 720 : 420),
                  child: wide
                      ? Row(
                          children: [
                            Expanded(child: brand),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: actions,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            brand,
                            const SizedBox(height: 32),
                            ...actions,
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _actions(AppLocalizations l10n) => [
        if (_saved != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FilledButton.icon(
              onPressed: _continueGame,
              icon: const Icon(Icons.play_arrow),
              label: Text(l10n.menuContinue),
            ),
          ),
        _MenuButton(
          icon: Icons.casino_outlined,
          label: l10n.menuNewGame,
          primary: _saved == null,
          onPressed: _startNewGame,
        ),
        _MenuButton(
          icon: Icons.settings_outlined,
          label: l10n.menuSettings,
          onPressed: () => _push(Routes.settings),
        ),
        _MenuButton(
          icon: Icons.history,
          label: l10n.menuHistory,
          onPressed: () => _push(Routes.history),
        ),
        _MenuButton(
          icon: Icons.menu_book_outlined,
          label: l10n.menuRules,
          onPressed: () => _push(Routes.rules),
        ),
        TextButton(
          onPressed: () => _push(Routes.debug),
          child: Text(l10n.menuDebug, style: const TextStyle(fontSize: 12)),
        ),
        // Which build is actually running. On the web a phone can sit on a
        // cached copy for a while, so "I still see the old bug" and "the fix
        // did not work" are otherwise impossible to tell apart.
        const Text(
          buildId,
          style: TextStyle(fontSize: 10, color: OkeyPalette.ivoryShade),
        ),
      ];

  /// Stamped in by the publish script; "dev" in a local run.
  static const String buildId =
      String.fromEnvironment('BUILD_ID', defaultValue: 'dev');

  Future<void> _push(String route) async {
    await Navigator.of(context).pushNamed(route);
    if (mounted) _refreshSaved();
  }

  Future<void> _startNewGame() async {
    final l10n = AppLocalizations.of(context);
    if (_saved != null) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(l10n.menuNewGameWarning),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.commonYes),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    if (!mounted) return;

    final settings = ref.read(settingsProvider);
    // Android Chrome only grants a real orientation lock from inside a user
    // gesture, and only while fullscreen. Everywhere else this quietly does
    // nothing and ForceLandscape rotates the board instead.
    if (settings.forceLandscape) unawaited(OrientationLock.requestLandscape());
    // The clock is read here, in the UI layer, and handed to the engine as a
    // seed. Nothing inside the domain ever reads it.
    final seed = ref.read(nowProvider)() & 0xFFFFFFFF;
    ref.read(gameControllerProvider.notifier).newMatch(
          seed: seed,
          ruleSet: settings.ruleSet,
          names: [
            l10n.playerYou,
            l10n.botNameRight,
            l10n.botNameAcross,
            l10n.botNameLeft,
          ],
        );
    await Navigator.of(context).pushNamed(Routes.game);
    if (mounted) _refreshSaved();
  }

  Future<void> _continueGame() async {
    final saved = _saved;
    if (saved == null) return;
    if (ref.read(settingsProvider).forceLandscape) {
      unawaited(OrientationLock.requestLandscape());
    }
    ref.read(gameControllerProvider.notifier).restore(saved);
    await Navigator.of(context).pushNamed(Routes.game);
    if (mounted) _refreshSaved();
  }
}

/// Logo, title and tagline. Shrinks on a short landscape viewport.
class _Brand extends StatelessWidget {
  const _Brand({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Logo(tileWidth: compact ? 42 : 54),
        const SizedBox(height: 8),
        Text(
          l10n.appTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: compact ? 28 : 34,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
            color: OkeyPalette.ivory,
          ),
        ),
        Text(
          l10n.appTagline,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: compact ? 11 : 13,
            color: OkeyPalette.ivoryShade,
          ),
        ),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({this.tileWidth = 54});

  final double tileWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TileWidget.heightFor(tileWidth) + 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LogoTile(
            number: 1,
            color: OkeyPalette.tileRed,
            angle: -0.12,
            width: tileWidth,
          ),
          const SizedBox(width: 6),
          _LogoTile(
            number: 0,
            color: OkeyPalette.tileBlue,
            angle: 0.04,
            width: tileWidth,
          ),
          const SizedBox(width: 6),
          _LogoTile(
            number: 1,
            color: OkeyPalette.tileBlack,
            angle: 0.13,
            width: tileWidth,
          ),
        ],
      ),
    );
  }
}

class _LogoTile extends StatelessWidget {
  const _LogoTile({
    required this.number,
    required this.color,
    required this.angle,
    required this.width,
  });

  final int number;
  final Color color;
  final double angle;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: width,
        height: TileWidget.heightFor(width),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [OkeyPalette.ivory, OkeyPalette.ivoryShade],
          ),
          borderRadius: BorderRadius.circular(9),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '$number',
          style: TextStyle(
            fontSize: width * 0.63,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: primary
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label),
            ),
    );
  }
}
