// How long melds on the table actually get.
//
//   dart run tool/meld_length_probe.dart --games 200
//
// The board draws each half thirteen columns wide because a run can in
// principle reach 1..13. This measures how often it really does, which is what
// decides whether a narrower half would ever cost anything.
import 'dart:io';

import 'package:okey101/domain/ai/bot_brain.dart';
import 'package:okey101/domain/ai/hard_bot.dart';
import 'package:okey101/domain/ai/medium_bot.dart';
import 'package:okey101/domain/engine/dealer.dart';
import 'package:okey101/domain/engine/engine_result.dart';
import 'package:okey101/domain/engine/game_engine.dart';
import 'package:okey101/domain/engine/match_runner.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/rule_set.dart';

void main(List<String> args) {
  var games = 200;
  for (var i = 0; i < args.length - 1; i++) {
    if (args[i] == '--games') games = int.parse(args[i + 1]);
  }

  const rules = RuleSet();
  final brains = <BotBrain>[
    const HardBot(),
    const MediumBot(),
    const HardBot(),
    const MediumBot(),
  ];

  // How many melds ever reached each length, counted once per meld at its
  // longest, and how many hands held a meld longer than eight.
  final byLength = <int, int>{};
  var melds = 0;
  var hands = 0;
  var handsOverEight = 0;

  for (var game = 0; game < games; game++) {
    final seed = 1 + game;
    final outcome = MatchRunner.run(
      ruleSet: rules,
      seed: seed,
      brains: brains,
      checkInvariants: false,
    );

    // Replay so every intermediate table can be looked at; the runner only
    // keeps the final state.
    var state = Dealer.newMatch(
      ruleSet: rules,
      seed: seed,
      names: Dealer.defaultNames,
      humans: List<bool>.filled(kSeatCount, false),
    );
    final longest = <int, int>{};
    var handNumber = state.handNumber;

    void closeHand() {
      if (longest.isEmpty) return;
      hands++;
      melds += longest.length;
      var over = false;
      for (final length in longest.values) {
        byLength.update(length, (n) => n + 1, ifAbsent: () => 1);
        if (length > 8) over = true;
      }
      if (over) handsOverEight++;
      longest.clear();
    }

    for (final action in outcome.canonicalActions) {
      final result = GameEngine.apply(state, action);
      if (result is EngineErr) break;
      state = (result as EngineOk).state;
      if (state.handNumber != handNumber) {
        closeHand();
        handNumber = state.handNumber;
      }
      for (final meld in state.table) {
        if (meld.kind == MeldKind.pair) continue;
        final length = meld.tiles.length;
        final seen = longest[meld.id] ?? 0;
        if (length > seen) longest[meld.id] = length;
      }
    }
    closeHand();
  }

  stdout
    ..writeln('$games matches, $hands hands, $melds melds on the table')
    ..writeln('  hands holding a meld longer than 8: $handsOverEight '
        '(${(handsOverEight / hands * 100).toStringAsFixed(2)}%)')
    ..writeln();
  final lengths = byLength.keys.toList()..sort();
  for (final length in lengths) {
    final count = byLength[length]!;
    stdout.writeln('  length ${length.toString().padLeft(2)}: '
        '${count.toString().padLeft(6)} '
        '(${(count / melds * 100).toStringAsFixed(2)}%)');
  }
}
