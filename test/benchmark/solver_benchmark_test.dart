@Timeout(Duration(minutes: 5))
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/engine/dealer.dart';
import 'package:okey101/domain/engine/game_engine.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/meld_solver.dart';

/// MeldSolver timings.
///
/// The Dart VM is far faster than compiled JavaScript, so a number taken here
/// is NOT the number that matters. Run this in the browser to get the figure
/// the performance budget is written against:
///
///   flutter test --platform chrome test/benchmark/solver_benchmark_test.dart
///
/// The environment is printed with every result so no number is ever quoted
/// without saying where it came from.
void main() {
  const environment = bool.fromEnvironment('dart.library.js_util')
      ? 'compiled JavaScript (browser)'
      : 'Dart VM';

  /// 22-tile hands taken from real deals, so the shapes are representative.
  List<List<Tile>> sampleHands(int count) {
    final hands = <List<Tile>>[];
    for (var seed = 1; hands.length < count; seed++) {
      final state = Dealer.newMatch(
        ruleSet: RulePresets.standard,
        seed: seed,
        names: const ['A', 'B', 'C', 'D'],
        humans: const [false, false, false, false],
      );
      hands.add(state.players[state.startingSeat].hand);
    }
    return hands;
  }

  GameState gameFor(int seed) => Dealer.newMatch(
        ruleSet: RulePresets.standard,
        seed: seed,
        names: const ['A', 'B', 'C', 'D'],
        humans: const [false, false, false, false],
      );

  ({double average, int worst, int total}) time(
    List<List<Tile>> hands,
    void Function(MeldSolver solver, List<Tile> hand) body,
    MeldSolver Function(int index) solverFor,
  ) {
    // Warm up so JIT/dart2js inline caches are not part of the measurement.
    for (var i = 0; i < hands.length && i < 10; i++) {
      body(solverFor(i), hands[i]);
    }
    var worst = 0;
    final watch = Stopwatch()..start();
    for (var i = 0; i < hands.length; i++) {
      final one = Stopwatch()..start();
      body(solverFor(i), hands[i]);
      one.stop();
      if (one.elapsedMicroseconds > worst) worst = one.elapsedMicroseconds;
    }
    watch.stop();
    return (
      average: watch.elapsedMicroseconds / hands.length / 1000.0,
      worst: worst,
      total: watch.elapsedMilliseconds,
    );
  }

  test('maximizePoints on a 22-tile hand', () {
    const sampleCount = 120;
    final hands = sampleHands(sampleCount);
    final solvers = <MeldSolver>[
      for (var i = 0; i < sampleCount; i++)
        MeldSolver(GameEngine.semanticsOf(gameFor(i + 1))),
    ];

    final result = time(
      hands,
      (solver, hand) => solver.maximizePoints(hand),
      (i) => solvers[i],
    );

    // Benchmarks exist to report numbers, so printing is the point.
    // ignore: avoid_print
    print('[BENCH] maximizePoints, 22 tiles, $sampleCount hands, '
        '$environment: '
        'avg ${result.average.toStringAsFixed(2)} ms, '
        'worst ${(result.worst / 1000).toStringAsFixed(2)} ms, '
        'total ${result.total} ms');

    // The budget is 50 ms in Chrome on a mid-range phone. A desktop VM or
    // desktop Chrome must be comfortably inside it; this guard only catches a
    // catastrophic regression, it is not the budget check itself.
    expect(result.average, lessThan(50));
  });

  test('minimizeDeadwood on a 22-tile hand', () {
    const sampleCount = 120;
    final hands = sampleHands(sampleCount);
    final solvers = <MeldSolver>[
      for (var i = 0; i < sampleCount; i++)
        MeldSolver(GameEngine.semanticsOf(gameFor(i + 1))),
    ];

    final result = time(
      hands,
      (solver, hand) => solver.minimizeDeadwood(hand),
      (i) => solvers[i],
    );

    // Benchmarks exist to report numbers, so printing is the point.
    // ignore: avoid_print
    print('[BENCH] minimizeDeadwood, 22 tiles, $sampleCount hands, '
        '$environment: '
        'avg ${result.average.toStringAsFixed(2)} ms, '
        'worst ${(result.worst / 1000).toStringAsFixed(2)} ms');
    expect(result.average, lessThan(50));
  });

  test('canFinish on a 22-tile hand', () {
    const sampleCount = 120;
    final hands = sampleHands(sampleCount);
    final solvers = <MeldSolver>[
      for (var i = 0; i < sampleCount; i++)
        MeldSolver(GameEngine.semanticsOf(gameFor(i + 1))),
    ];

    final result = time(
      hands,
      (solver, hand) => solver.canFinish(hand),
      (i) => solvers[i],
    );

    // Benchmarks exist to report numbers, so printing is the point.
    // ignore: avoid_print
    print('[BENCH] canFinish, 22 tiles, $sampleCount hands, $environment: '
        'avg ${result.average.toStringAsFixed(2)} ms, '
        'worst ${(result.worst / 1000).toStringAsFixed(2)} ms');
    expect(result.average, lessThan(50));
  });

  test('a full turn of bot thinking', () {
    // What the live HUD does on every rack rearrangement: one maximizePoints
    // plus one minimizeDeadwood.
    const sampleCount = 80;
    final hands = sampleHands(sampleCount);
    final solvers = <MeldSolver>[
      for (var i = 0; i < sampleCount; i++)
        MeldSolver(GameEngine.semanticsOf(gameFor(i + 1))),
    ];

    final result = time(
      hands,
      (solver, hand) {
        solver
          ..maximizePoints(hand)
          ..minimizeDeadwood(hand);
      },
      (i) => solvers[i],
    );

    // Benchmarks exist to report numbers, so printing is the point.
    // ignore: avoid_print
    print('[BENCH] HUD refresh (points + deadwood), 22 tiles, $environment: '
        'avg ${result.average.toStringAsFixed(2)} ms, '
        'worst ${(result.worst / 1000).toStringAsFixed(2)} ms');
    expect(result.average, lessThan(100));
  });
}
