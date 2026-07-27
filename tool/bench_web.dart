// MeldSolver benchmark, compiled to JavaScript and run in a real browser.
//
// The Dart VM is several times faster than compiled JS, so a number taken with
// `flutter test` is not the number the 50 ms budget is written against. This
// entrypoint exists so a genuine browser figure can be produced headlessly:
//
//   dart compile js -O2 -o bench.js tool/bench_web.dart
//   chrome --headless=new --disable-gpu --dump-dom file:///.../bench.html
//
// It writes its results into the document body, which is what --dump-dom
// captures.
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:okey101/domain/engine/dealer.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/meld_solver.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

const int sampleCount = 120;
const int warmup = 15;

void main() {
  final hands = <List<Tile>>[];
  final solvers = <MeldSolver>[];
  for (var seed = 1; seed <= sampleCount; seed++) {
    final state = Dealer.newMatch(
      ruleSet: RulePresets.standard,
      seed: seed,
      names: const ['A', 'B', 'C', 'D'],
      humans: const [false, false, false, false],
    );
    hands.add(state.players[state.startingSeat].hand);
    solvers.add(
      MeldSolver(
        TileSemantics(
          indicatorIdentity: state.indicatorIdentity,
          okey: state.okey,
          ruleSet: state.ruleSet,
        ),
      ),
    );
  }

  final report = StringBuffer()
    ..writeln('environment: compiled JavaScript in Chrome')
    ..writeln('samples: $sampleCount 22-tile hands')
    ..writeln(
      _measure('maximizePoints', (i) => solvers[i].maximizePoints(hands[i])),
    )
    ..writeln(
      _measure(
        'minimizeDeadwood',
        (i) => solvers[i].minimizeDeadwood(hands[i]),
      ),
    )
    ..writeln(_measure('canFinish', (i) => solvers[i].canFinish(hands[i])))
    ..writeln(
      _measure('HUD refresh', (i) {
        solvers[i]
          ..maximizePoints(hands[i])
          ..minimizeDeadwood(hands[i]);
      }),
    );

  final document = globalContext.getProperty<JSObject>('document'.toJS);
  document
      .getProperty<JSObject>('body'.toJS)
      .setProperty('textContent'.toJS, report.toString().toJS);
}

String _measure(String label, void Function(int index) body) {
  // Warm up first so dart2js inline caches are not part of the measurement.
  for (var i = 0; i < warmup; i++) {
    body(i);
  }
  var worst = 0;
  final watch = Stopwatch()..start();
  for (var i = 0; i < sampleCount; i++) {
    final one = Stopwatch()..start();
    body(i);
    one.stop();
    if (one.elapsedMicroseconds > worst) worst = one.elapsedMicroseconds;
  }
  watch.stop();
  final average = watch.elapsedMicroseconds / sampleCount / 1000.0;
  return '$label: avg ${average.toStringAsFixed(2)} ms, '
      'worst ${(worst / 1000).toStringAsFixed(2)} ms, '
      'total ${watch.elapsedMilliseconds} ms';
}
