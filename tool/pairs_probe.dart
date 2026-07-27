// How often bots actually take the pairs road.
//
//   dart run tool/pairs_probe.dart --games 300 --difficulty hard
//
// The main simulation only reports how hands FINISH, so a bot that opens with
// pairs and then runs out of deck shows up as "exhausted" and the road looks
// unused. This counts the lay-downs themselves, off the canonical action log.
import 'dart:io';

import 'package:okey101/domain/ai/bot_brain.dart';
import 'package:okey101/domain/ai/easy_bot.dart';
import 'package:okey101/domain/ai/hard_bot.dart';
import 'package:okey101/domain/ai/medium_bot.dart';
import 'package:okey101/domain/engine/match_runner.dart';
import 'package:okey101/domain/models/game_action.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/scoring.dart';

void main(List<String> args) {
  var games = 200;
  var difficulty = 'hard';
  for (var i = 0; i < args.length - 1; i++) {
    if (args[i] == '--games') games = int.parse(args[i + 1]);
    if (args[i] == '--difficulty') difficulty = args[i + 1];
  }

  final brain = switch (difficulty) {
    'easy' => const EasyBot(),
    'medium' => const MediumBot(),
    _ => const HardBot(),
  };
  final brains = List<BotBrain>.filled(kSeatCount, brain);

  var hands = 0;
  var pairsLayDowns = 0;
  var normalOpens = 0;
  final finishes = <ScoreRowKey, int>{
    for (final key in ScoreRowKey.values) key: 0,
  };

  final watch = Stopwatch()..start();
  for (var i = 0; i < games; i++) {
    final outcome = MatchRunner.run(
      ruleSet: const RuleSet(),
      seed: 1 + i,
      brains: brains,
      checkInvariants: false,
    );
    hands += outcome.hands.length;
    for (final hand in outcome.hands) {
      finishes[hand.rowKey] = finishes[hand.rowKey]! + 1;
    }
    for (final action in outcome.canonicalActions) {
      if (action is LayPairs) pairsLayDowns++;
      if (action is OpenWithMelds) normalOpens++;
    }
  }
  watch.stop();

  stdout
    ..writeln('$difficulty x4, $games matches, $hands hands '
        'in ${watch.elapsedMilliseconds} ms')
    ..writeln('  normal opens : $normalOpens '
        '(${(normalOpens / hands).toStringAsFixed(2)} per hand)')
    ..writeln('  pairs laid   : $pairsLayDowns '
        '(${(pairsLayDowns / hands * 100).toStringAsFixed(1)}% of hands)')
    ..writeln('  pairs finish : ${finishes[ScoreRowKey.pairs]} + '
        '${finishes[ScoreRowKey.pairsWithOkey]} with okey')
    ..writeln('  exhausted    : ${finishes[ScoreRowKey.exhausted]}');
}
