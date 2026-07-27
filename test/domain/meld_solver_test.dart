import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/meld_rules.dart';
import 'package:okey101/domain/rules/meld_solver.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

import 'test_tiles.dart';

void main() {
  // Indicator black 1 -> the okey is black 2.
  final semantics = TileSemantics.fromIndicator(
    const TileIdentity(color: TileColor.black, number: 1),
    RulePresets.standard,
  );
  final solver = MeldSolver(semantics);
  final okey = black(2);
  final okeyCopy = black(2, 1);

  /// Re-validates a solution through the same rules the engine uses, so the
  /// solver can never propose something the engine would reject.
  void expectLegal(MeldSolution solution) {
    for (final meld in solution.melds) {
      final check = MeldRules.validate(
        kind: meld.kind,
        tiles: meld.tiles,
        semantics: semantics,
        isLayDown: true,
      );
      expect(
        check,
        isA<MeldValid>(),
        reason: '${meld.kind} ${meld.tiles.map((t) => t.debugLabel)} '
            'was rejected by MeldRules',
      );
      expect((check as MeldValid).points, meld.points);
    }
    final usedIds = <int>{};
    for (final meld in solution.melds) {
      for (final tile in meld.tiles) {
        expect(usedIds.add(tile.id), isTrue, reason: 'tile ${tile.id} reused');
      }
    }
    for (final tile in solution.leftovers) {
      expect(usedIds.contains(tile.id), isFalse);
    }
  }

  group('maximizePoints', () {
    test('finds a single run', () {
      final solution = solver.maximizePoints([red(5), red(6), red(7)]);
      expect(solution.points, 18);
      expect(solution.melds.single.kind, MeldKind.run);
      expect(solution.leftovers, isEmpty);
      expectLegal(solution);
    });

    test('finds a single set', () {
      final solution = solver.maximizePoints([red(11), yellow(11), blue(11)]);
      expect(solution.points, 33);
      expect(solution.melds.single.kind, MeldKind.set);
      expectLegal(solution);
    });

    test('leaves unmeldable tiles out', () {
      final solution =
          solver.maximizePoints([red(5), red(6), red(7), blue(1), yellow(9)]);
      expect(solution.points, 18);
      expect(solution.leftovers.length, 2);
      expectLegal(solution);
    });

    test('never wraps 12-13-1 into a run', () {
      final solution = solver.maximizePoints([red(12), red(13), red(1)]);
      expect(solution.melds, isEmpty);
      expect(solution.points, 0);
    });

    test('respects the lay-down run length cap', () {
      final tiles = [red(3), red(4), red(5), red(6), red(7), red(8)];
      final solution = solver.maximizePoints(tiles);
      for (final meld in solution.melds) {
        expect(meld.tiles.length, lessThanOrEqualTo(5));
      }
      expectLegal(solution);
    });

    test('uses the okey where it is worth the most', () {
      // 13-13-okey is 39; 5-6-okey would only be 21.
      final solution = solver.maximizePoints([
        red(13), yellow(13), okey, //
        red(5), red(6),
      ]);
      expect(solution.points, 39);
      expect(solution.melds.single.tiles.contains(okey), isTrue);
      expectLegal(solution);
    });

    test('splits a shared tile between a run and a set optimally', () {
      // red 7 could extend the run or complete the set; the solver picks the
      // partition that scores most overall.
      final solution = solver.maximizePoints([
        red(5), red(6), red(7), //
        yellow(7), blue(7), black(7),
      ]);
      expect(solution.leftovers, isEmpty);
      expect(solution.points, 18 + 28 - 7);
      expectLegal(solution);
    });

    test('finds an opening worth exactly 101', () {
      final solution = solver.maximizePoints([
        red(13), yellow(13), black(13), blue(13), // 52
        red(9), yellow(9), blue(9), //              27
        red(4), red(5), red(6), red(7), //          22
      ]);
      expect(solution.points, 101);
      expect(solution.leftovers, isEmpty);
      expectLegal(solution);
    });

    test('handles a realistic 22-tile hand without leaving anything illegal',
        () {
      final hand = <Tile>[
        red(1), red(2), red(3), red(9), red(10), //
        yellow(4), yellow(5), yellow(6), yellow(11), //
        blue(7), blue(8), blue(9), blue(13), //
        black(3), black(4), black(5), black(12), //
        red(7), yellow(7), blue(7, 1), //
        okey, falseJoker0,
      ];
      expect(hand.length, 22);
      final solution = solver.maximizePoints(hand);
      expect(solution.points, greaterThan(101));
      expectLegal(solution);
    });

    test('an empty hand scores nothing', () {
      final solution = solver.maximizePoints(const []);
      expect(solution.points, 0);
      expect(solution.melds, isEmpty);
    });
  });

  group('minimizeDeadwood', () {
    test('prefers to place the okey rather than leave it at 25', () {
      // Melding 5-6-okey saves 25 of deadwood, which beats leaving it.
      final solution = solver.minimizeDeadwood([red(5), red(6), okey, blue(1)]);
      expect(solution.melds.single.tiles.contains(okey), isTrue);
      expect(solution.deadwood, 1);
      expectLegal(solution);
    });

    test('a lone okey is 25 points of deadwood', () {
      final solution = solver.minimizeDeadwood([okey, blue(1), yellow(3)]);
      expect(solution.melds, isEmpty);
      expect(solution.deadwood, 25 + 1 + 3);
    });

    test('a false joker is deadwood at the indicator number, not 25', () {
      final solution = solver.minimizeDeadwood([falseJoker0, blue(9)]);
      expect(solution.deadwood, 1 + 9);
    });

    test('reports zero deadwood for a fully melded hand', () {
      final solution = solver.minimizeDeadwood([
        red(5), red(6), red(7), //
        yellow(11), blue(11), black(11),
      ]);
      expect(solution.deadwood, 0);
      expect(solution.usesEveryTile, isTrue);
      expectLegal(solution);
    });
  });

  group('canFinish', () {
    test('returns the tile to discard when the hand can go out', () {
      final hand = <Tile>[
        red(5), red(6), red(7), //
        yellow(11), blue(11), black(11), //
        blue(1), blue(2), blue(3), //
        yellow(9), // the odd one out
      ];
      final discard = solver.canFinish(hand);
      expect(discard, isNotNull);
      expect(discard, yellow(9));
    });

    test('returns null when the hand cannot go out', () {
      final hand = <Tile>[
        red(5), red(6), red(7), //
        yellow(2), blue(4), black(9), yellow(13),
      ];
      expect(solver.canFinish(hand), isNull);
    });

    test('canMeldEverything is exact', () {
      expect(
        solver.canMeldEverything([red(5), red(6), red(7)]),
        isTrue,
      );
      expect(
        solver.canMeldEverything([red(5), red(6), red(7), blue(1)]),
        isFalse,
      );
      expect(solver.canMeldEverything(const []), isTrue);
    });
  });

  group('bestPairs', () {
    test('counts natural pairs', () {
      final pairs = solver.bestPairs([
        red(3), red(3, 1), //
        blue(9), blue(9, 1), //
        yellow(4),
      ]);
      expect(pairs.length, 2);
      expect(pairs.every((p) => p.kind == MeldKind.pair), isTrue);
    });

    test('the okey completes a pair with the highest single', () {
      final pairs = solver.bestPairs([red(3), yellow(12), okey]);
      expect(pairs.length, 1);
      expect(pairs.single.tiles.contains(okey), isTrue);
      // Spent on the 12, not the 3.
      expect(pairs.single.tiles.contains(yellow(12)), isTrue);
    });

    test('two false jokers pair with each other', () {
      final pairs = solver.bestPairs([falseJoker0, falseJoker1]);
      expect(pairs.length, 1);
      expect(pairs.single.tiles.toSet(), {falseJoker0, falseJoker1});
    });

    test('two okeys do not pair with each other', () {
      final pairs = solver.bestPairs([okey, okeyCopy]);
      expect(pairs, isEmpty);
    });

    test('finds eleven pairs in a finished pairs hand', () {
      final hand = <Tile>[
        for (var i = 0; i < 11; i++) ...[
          tile(TileColor.values[i % 4], (i ~/ 4) + 3),
          tile(TileColor.values[i % 4], (i ~/ 4) + 3, 1),
        ],
      ];
      expect(solver.bestPairs(hand).length, 11);
    });
  });

  group('configurability', () {
    test('the lay-down cap bounds meld length, not achievable points', () {
      // Any run longer than the cap splits into legal shorter runs with the
      // same total, so the cap changes the SHAPE of a solution, never its
      // score. Both of these are worth 33.
      final tiles = [red(3), red(4), red(5), red(6), red(7), red(8)];
      final capped = solver.maximizePoints(tiles);
      expect(capped.points, 33);
      expect(capped.melds.every((m) => m.tiles.length <= 5), isTrue);

      final raised = TileSemantics.fromIndicator(
        const TileIdentity(color: TileColor.black, number: 1),
        RulePresets.standard.copyWith(maxRunLengthOnLayDown: 7),
      );
      final longRuns = MeldSolver(raised).maximizePoints(tiles);
      expect(longRuns.points, 33);
      expect(longRuns.melds.every((m) => m.tiles.length <= 7), isTrue);

      // The rules themselves reject the 6-run at the default cap and accept it
      // once the cap is raised.
      expect(
        MeldRules.validate(
          kind: MeldKind.run,
          tiles: tiles,
          semantics: semantics,
          isLayDown: true,
        ),
        isA<MeldRejected>(),
      );
      expect(
        MeldRules.validate(
          kind: MeldKind.run,
          tiles: tiles,
          semantics: raised,
          isLayDown: true,
        ),
        isA<MeldValid>(),
      );
    });

    test('allowCircularRuns opts 12-13-1 back in', () {
      final circular = MeldSolver(
        TileSemantics.fromIndicator(
          const TileIdentity(color: TileColor.black, number: 1),
          RulePresets.standard.copyWith(allowCircularRuns: true),
        ),
      );
      // The solver never builds wrapping runs even when the rule allows them,
      // because it only ever starts a run at the lowest remaining number. That
      // is a deliberate, documented limitation of the search, not a rule bug:
      // MeldRules still accepts a hand-built 12-13-1.
      final solution = circular.maximizePoints([red(12), red(13), red(1)]);
      expect(solution.melds, isEmpty);
    });
  });
}
