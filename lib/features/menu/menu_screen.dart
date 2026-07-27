import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okey101/app/app.dart';
import 'package:okey101/app/providers.dart';
import 'package:okey101/app/theme.dart';
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Logo(),
                  const SizedBox(height: 10),
                  Text(
                    l10n.appTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                      color: OkeyPalette.ivory,
                    ),
                  ),
                  Text(
                    l10n.appTagline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: OkeyPalette.ivoryShade,
                    ),
                  ),
                  const SizedBox(height: 32),
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
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => _push(Routes.debug),
                    child: Text(
                      l10n.menuDebug,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
    ref.read(gameControllerProvider.notifier).restore(saved);
    await Navigator.of(context).pushNamed(Routes.game);
    if (mounted) _refreshSaved();
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TileWidget.heightFor(54) + 12,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LogoTile(number: 1, color: OkeyPalette.tileRed, angle: -0.12),
          SizedBox(width: 6),
          _LogoTile(number: 0, color: OkeyPalette.tileBlue, angle: 0.04),
          SizedBox(width: 6),
          _LogoTile(number: 1, color: OkeyPalette.tileBlack, angle: 0.13),
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
  });

  final int number;
  final Color color;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 54,
        height: TileWidget.heightFor(54),
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
            fontSize: 34,
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
