import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okey101/app/providers.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/core/tile_glyphs.dart';
import 'package:okey101/domain/ai/bot_brain.dart';
import 'package:okey101/domain/ai/hard_bot.dart';
import 'package:okey101/domain/ai/medium_bot.dart';
import 'package:okey101/domain/engine/dealer.dart';
import 'package:okey101/domain/engine/game_engine.dart';
import 'package:okey101/domain/engine/match_runner.dart';
import 'package:okey101/domain/engine/state_invariants.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/rules/meld_solver.dart';
import 'package:okey101/l10n/generated/app_localizations.dart';

/// Diagnostics, and the only place that measures the solver on the device the
/// game actually runs on.
///
/// The Dart VM is far faster than compiled JavaScript, so a benchmark taken in
/// `flutter test` is not the number that matters. Running this screen in the
/// browser - ideally on the phone - gives the figure the 50 ms budget is
/// written against.
final debugGameProvider = NotifierProvider<DebugGameNotifier, GameState?>(
  DebugGameNotifier.new,
);

class DebugGameNotifier extends Notifier<GameState?> {
  @override
  GameState? build() => null;

  void dealNewHand(int seed) {
    state = Dealer.newMatch(
      ruleSet: RulePresets.standard,
      seed: seed,
      names: const ['P0', 'P1', 'P2', 'P3'],
      humans: const [true, false, false, false],
    );
  }
}

class DebugScreen extends ConsumerStatefulWidget {
  const DebugScreen({super.key});

  @override
  ConsumerState<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends ConsumerState<DebugScreen> {
  String? _benchmark;
  String? _simulation;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final game = ref.watch(debugGameProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.debugTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: () => ref
                    .read(debugGameProvider.notifier)
                    .dealNewHand(ref.read(nowProvider)() & 0xFFFFFFFF),
                icon: const Icon(Icons.casino_outlined),
                label: Text(l10n.debugDeal),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _busy ? null : _runBenchmark,
                icon: const Icon(Icons.speed),
                label: const Text('MeldSolver benchmark'),
              ),
              if (_benchmark != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SelectableText(
                    _benchmark!,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: OkeyPalette.success,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _busy ? null : _runSimulation,
                icon: const Icon(Icons.playlist_play),
                label: Text(l10n.debugRunSimulation),
              ),
              if (_simulation != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SelectableText(
                    _simulation!,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: OkeyPalette.success,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              if (game != null) _DebugReport(game: game),
            ],
          ),
        ),
      ),
    );
  }

  /// Measured wherever this build is running: `kIsWeb` decides which label the
  /// result carries, so a number is never quoted without its environment.
  Future<void> _runBenchmark() async {
    setState(() => _busy = true);
    await Future<void>.delayed(const Duration(milliseconds: 16));

    const sampleCount = 60;
    final hands = <List<dynamic>>[];
    final solvers = <MeldSolver>[];
    for (var seed = 1; seed <= sampleCount; seed++) {
      final state = Dealer.newMatch(
        ruleSet: RulePresets.standard,
        seed: seed,
        names: const ['A', 'B', 'C', 'D'],
        humans: const [false, false, false, false],
      );
      hands.add(state.players[state.startingSeat].hand);
      solvers.add(MeldSolver(GameEngine.semanticsOf(state)));
    }

    // Warm up first: dart2js inline caches would otherwise be measured too.
    for (var i = 0; i < 8; i++) {
      solvers[i].maximizePoints(hands[i].cast());
    }

    var worstMicros = 0;
    final watch = Stopwatch()..start();
    for (var i = 0; i < sampleCount; i++) {
      final one = Stopwatch()..start();
      solvers[i].maximizePoints(hands[i].cast());
      one.stop();
      if (one.elapsedMicroseconds > worstMicros) {
        worstMicros = one.elapsedMicroseconds;
      }
    }
    watch.stop();

    final deadwoodWatch = Stopwatch()..start();
    for (var i = 0; i < sampleCount; i++) {
      solvers[i].minimizeDeadwood(hands[i].cast());
    }
    deadwoodWatch.stop();

    final finishWatch = Stopwatch()..start();
    for (var i = 0; i < sampleCount; i++) {
      solvers[i].canFinish(hands[i].cast());
    }
    finishWatch.stop();

    const environment = kIsWeb ? 'browser (compiled JS)' : 'Dart VM';
    final result = StringBuffer()
      ..writeln('environment: $environment')
      ..writeln('22-tile hands: $sampleCount')
      ..writeln(
        'maximizePoints  avg '
        '${(watch.elapsedMicroseconds / sampleCount / 1000).toStringAsFixed(2)}'
        ' ms  worst ${(worstMicros / 1000).toStringAsFixed(2)} ms',
      )
      ..writeln(
        'minimizeDeadwood avg '
        '${(deadwoodWatch.elapsedMicroseconds / sampleCount / 1000).toStringAsFixed(2)} ms',
      )
      ..writeln(
        'canFinish        avg '
        '${(finishWatch.elapsedMicroseconds / sampleCount / 1000).toStringAsFixed(2)} ms',
      )
      ..write('budget: 50 ms for maximizePoints');

    setState(() {
      _benchmark = result.toString();
      _busy = false;
    });
  }

  Future<void> _runSimulation() async {
    setState(() => _busy = true);
    await Future<void>.delayed(const Duration(milliseconds: 16));

    const games = 20;
    final brains = <BotBrain>[
      const HardBot(),
      const MediumBot(),
      const HardBot(),
      const MediumBot(),
    ];
    var issues = 0;
    var hands = 0;
    final watch = Stopwatch()..start();
    for (var seed = 1; seed <= games; seed++) {
      final outcome = MatchRunner.run(
        ruleSet: RulePresets.standard,
        seed: seed,
        brains: brains,
      );
      issues += outcome.issues.length;
      hands += outcome.hands.length;
      if (!outcome.completed) issues++;
    }
    watch.stop();

    setState(() {
      _simulation = '$games matches, $hands hands, '
          '${watch.elapsedMilliseconds} ms, $issues issues';
      _busy = false;
    });
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
            tileLabel(l10n, game.indicator),
            identityLabel(l10n, game.okey),
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
          SelectableText(
            player.hand.map((t) => tileLabel(l10n, t)).join('  '),
            style: const TextStyle(fontFamily: 'monospace', height: 1.6),
          ),
        ],
      ],
    );
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
      child: SelectableText(text, style: TextStyle(color: color, fontSize: 15)),
    );
  }
}
