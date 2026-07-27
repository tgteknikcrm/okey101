import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/domain/engine/dealer.dart';
import 'package:okey101/domain/engine/state_invariants.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/l10n/generated/app_localizations.dart';

/// Throwaway P1 screen: the only thing that can be looked at on a phone before
/// the real game screen lands in P4. Replaced then.
final debugGameProvider = NotifierProvider<DebugGameNotifier, GameState?>(
  DebugGameNotifier.new,
);

class DebugGameNotifier extends Notifier<GameState?> {
  @override
  GameState? build() => null;

  /// Seeds from the wall clock. The clock is read here, in the UI layer -
  /// never inside the engine.
  void dealNewHand() {
    final seed = DateTime.now().millisecondsSinceEpoch & 0xFFFFFFFF;
    state = Dealer.newMatch(
      ruleSet: RulePresets.standard,
      seed: seed,
      names: const ['P0', 'P1', 'P2', 'P3'],
      humans: const [true, false, false, false],
    );
  }
}

class DebugScreen extends ConsumerWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final game = ref.watch(debugGameProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.debugTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: () =>
                    ref.read(debugGameProvider.notifier).dealNewHand(),
                icon: const Icon(Icons.casino_outlined),
                label: Text(l10n.debugDeal),
              ),
              const SizedBox(height: 20),
              if (game == null)
                Text(
                  l10n.gameDiscardHint,
                  style: const TextStyle(color: OkeyPalette.ivoryShade),
                )
              else
                _DebugReport(game: game),
            ],
          ),
        ),
      ),
    );
  }
}

class _DebugReport extends StatelessWidget {
  const _DebugReport({required this.game});

  final GameState game;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final total = game.allTiles().length;
    final problem = StateInvariants.violation(game);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Line(l10n.debugSeed(game.seed)),
        _Line(
          l10n.debugIndicator(
            _label(game.indicator),
            game.okey.shortLabel,
          ),
        ),
        _Line(
          l10n.debugDrawPile(game.drawPile.length),
          ok: game.drawPile.length == kDrawPileSize,
        ),
        _Line(l10n.debugTotalTiles(total), ok: total == kTotalTiles),
        _Line(l10n.debugStartingSeat(game.players[game.startingSeat].name)),
        _Line(
          problem == null ? 'Invariants: OK' : 'Invariants: $problem',
          ok: problem == null,
        ),
        const SizedBox(height: 16),
        for (final player in game.players) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              '${player.name} - ${l10n.gameTileCount(player.hand.length)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: OkeyPalette.brass,
              ),
            ),
          ),
          Text(
            player.hand.map(_label).join('  '),
            style: const TextStyle(fontFamily: 'monospace', height: 1.6),
          ),
        ],
      ],
    );
  }

  String _label(Tile tile) {
    if (tile.isFalseJoker) return 'SJ';
    // Safe: a non-false-joker tile always carries a printed identity.
    final identity = tile.printedIdentity!;
    final colorLetter = switch (identity.color) {
      TileColor.red => 'K',
      TileColor.yellow => 'S',
      TileColor.black => 'Y',
      TileColor.blue => 'M',
    };
    return '$colorLetter${identity.number}';
  }
}

class _Line extends StatelessWidget {
  const _Line(this.text, {this.ok});

  final String text;
  final bool? ok;

  @override
  Widget build(BuildContext context) {
    final color = switch (ok) {
      null => OkeyPalette.ivory,
      true => OkeyPalette.success,
      false => OkeyPalette.danger,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(text, style: TextStyle(color: color, fontSize: 15)),
    );
  }
}
