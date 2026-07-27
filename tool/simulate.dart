// Bulk game simulation.
//
//   dart run tool/simulate.dart --games 10000
//   dart run tool/simulate.dart --games 2000 --difficulty hard
//   dart run tool/simulate.dart --games 500 --preset aggressive --verbose
//
// Deliberately NOT part of the test suite: the suite runs a smaller, fixed
// corpus, and this is the long-running command.
import 'dart:io';

import 'package:okey101/domain/ai/bot_brain.dart';
import 'package:okey101/domain/ai/easy_bot.dart';
import 'package:okey101/domain/ai/hard_bot.dart';
import 'package:okey101/domain/ai/medium_bot.dart';
import 'package:okey101/domain/ai/random_bot.dart';
import 'package:okey101/domain/engine/match_runner.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/scoring.dart';

void main(List<String> args) {
  final options = _Options.parse(args);
  stdout
    ..writeln('Okey 101 simulation')
    ..writeln('  games      : ${options.games}')
    ..writeln('  seed base  : ${options.seed}')
    ..writeln('  line-up    : ${options.lineUpLabel}')
    ..writeln('  preset     : ${options.preset.name}')
    ..writeln();

  final brains = options.brains();
  final rules = RulePresets.of(options.preset);

  final winsBySeat = List<int>.filled(kSeatCount, 0);
  final finishCounts = <ScoreRowKey, int>{
    for (final key in ScoreRowKey.values) key: 0,
  };
  final issues = <String>[];
  var totalActions = 0;
  var totalHands = 0;
  var incomplete = 0;

  final watch = Stopwatch()..start();
  for (var i = 0; i < options.games; i++) {
    final seed = options.seed + i;
    final outcome = MatchRunner.run(
      ruleSet: rules,
      seed: seed,
      brains: brains,
      checkInvariants: options.checkInvariants,
    );

    totalActions += outcome.actionCount;
    totalHands += outcome.hands.length;
    if (!outcome.completed) incomplete++;
    for (final issue in outcome.issues) {
      if (issues.length < 25) issues.add('seed $seed $issue');
    }
    for (final hand in outcome.hands) {
      finishCounts[hand.rowKey] = finishCounts[hand.rowKey]! + 1;
    }
    if (outcome.completed) winsBySeat[outcome.winnerSeat]++;

    if (options.verbose && (i + 1) % 500 == 0) {
      stdout.writeln('  ${i + 1}/${options.games} '
          '(${watch.elapsedMilliseconds} ms)');
    }
  }
  watch.stop();

  final elapsed = watch.elapsedMilliseconds;
  stdout
    ..writeln('Done in $elapsed ms '
        '(${(elapsed / options.games).toStringAsFixed(2)} ms/game)')
    ..writeln('  hands played   : $totalHands')
    ..writeln('  actions applied: $totalActions')
    ..writeln('  incomplete     : $incomplete')
    ..writeln('  issues         : ${issues.length}')
    ..writeln()
    ..writeln('Wins by seat');
  for (var seat = 0; seat < kSeatCount; seat++) {
    final pct = options.games == 0
        ? 0.0
        : winsBySeat[seat] * 100.0 / options.games;
    stdout.writeln('  seat $seat (${options.brainNames[seat]}): '
        '${winsBySeat[seat]} (${pct.toStringAsFixed(1)}%)');
  }

  stdout
    ..writeln()
    ..writeln('Hand outcomes');
  for (final entry in finishCounts.entries) {
    if (entry.value == 0) continue;
    final pct = totalHands == 0 ? 0.0 : entry.value * 100.0 / totalHands;
    stdout.writeln('  ${entry.key.name.padRight(14)} ${entry.value} '
        '(${pct.toStringAsFixed(1)}%)');
  }

  if (issues.isNotEmpty) {
    stdout
      ..writeln()
      ..writeln('First ${issues.length} issues:');
    for (final issue in issues) {
      stdout.writeln('  $issue');
    }
    exitCode = 1;
  }
}

class _Options {
  _Options({
    required this.games,
    required this.seed,
    required this.preset,
    required this.difficulty,
    required this.mixed,
    required this.lineup,
    required this.verbose,
    required this.checkInvariants,
  });

  factory _Options.parse(List<String> args) {
    var games = 1000;
    var seed = 1;
    var preset = RulePreset.standard;
    var difficulty = 'random';
    var mixed = false;
    var verbose = false;
    var checkInvariants = true;
    List<String>? lineup;

    for (var i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '--games':
          games = int.parse(args[++i]);
        case '--seed':
          seed = int.parse(args[++i]);
        case '--preset':
          preset = RulePreset.values.firstWhere((p) => p.name == args[++i]);
        case '--difficulty':
          difficulty = args[++i];
        case '--mixed':
          mixed = true;
        case '--lineup':
          lineup = args[++i].split(',');
          if (lineup.length != kSeatCount) {
            stderr.writeln('--lineup needs exactly $kSeatCount entries');
            exit(64);
          }
        case '--verbose':
          verbose = true;
        case '--no-invariants':
          checkInvariants = false;
        case '--help':
          stdout.writeln(
            'Usage: dart run tool/simulate.dart '
            '[--games N] [--seed N] [--preset standard|aggressive] '
            '[--difficulty random|easy|medium|hard] [--mixed] '
            '[--lineup a,b,c,d] [--verbose] [--no-invariants]',
          );
          exit(0);
        default:
          stderr.writeln('Unknown argument: ${args[i]}');
          exit(64);
      }
    }
    return _Options(
      games: games,
      seed: seed,
      preset: preset,
      difficulty: difficulty,
      mixed: mixed,
      lineup: lineup,
      verbose: verbose,
      checkInvariants: checkInvariants,
    );
  }

  final int games;
  final int seed;
  final RulePreset preset;
  final String difficulty;
  final bool mixed;
  final List<String>? lineup;
  final bool verbose;
  final bool checkInvariants;

  static BotBrain _brainFor(String name) => switch (name) {
        'easy' => const EasyBot(),
        'medium' => const MediumBot(),
        'hard' => const HardBot(),
        _ => const RandomBot(),
      };

  /// In mixed mode the four seats are Hard, Medium, Easy, Random, which is what
  /// makes the win-rate ranking meaningful. --lineup overrides it, which is how
  /// a head-to-head that cancels seat bias is run:
  /// `--lineup hard,medium,hard,medium`.
  List<String> get brainNames => lineup ??
      (mixed
          ? const ['hard', 'medium', 'easy', 'random']
          : List<String>.filled(kSeatCount, difficulty));

  String get lineUpLabel => brainNames.join(' / ');

  List<BotBrain> brains() => brainNames.map(_brainFor).toList();
}
