import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/models/game_error.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/meld_rules.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

import 'test_tiles.dart';

void main() {
  // Indicator black 1 -> okey is black 2. Every red/yellow/blue tile is a plain
  // tile, which keeps the run and set fixtures free of accidental wilds.
  final semantics = TileSemantics.fromIndicator(
    const TileIdentity(color: TileColor.black, number: 1),
    RulePresets.standard,
  );
  final okey = black(2);
  final okeySecondCopy = black(2, 1);

  MeldCheck check(
    MeldKind kind,
    List<Tile> tiles, {
    bool isLayDown = true,
    TileSemantics? using,
  }) =>
      MeldRules.validate(
        kind: kind,
        tiles: tiles,
        semantics: using ?? semantics,
        isLayDown: isLayDown,
      );

  GameError errorOf(MeldCheck result) => (result as MeldRejected).error;

  group('runs (seri)', () {
    test('accepts three consecutive tiles of one colour', () {
      final result = check(MeldKind.run, [red(5), red(6), red(7)]);
      expect(result, isA<MeldValid>());
      expect((result as MeldValid).points, 18);
      expect(result.jokerAssignments, [null, null, null]);
    });

    test('accepts five consecutive tiles', () {
      final result =
          check(MeldKind.run, [blue(9), blue(10), blue(11), blue(12), blue(13)]);
      expect(result, isA<MeldValid>());
      expect((result as MeldValid).points, 55);
    });

    test('rejects two tiles as too short', () {
      expect(
        errorOf(check(MeldKind.run, [red(5), red(6)])),
        const GameError.runTooShort(length: 2),
      );
    });

    test('rejects a six-tile run at lay-down but allows it off lay-down', () {
      final tiles = [red(3), red(4), red(5), red(6), red(7), red(8)];
      expect(
        errorOf(check(MeldKind.run, tiles)),
        const GameError.runTooLongOnLayDown(length: 6, max: 5),
      );
      expect(check(MeldKind.run, tiles, isLayDown: false), isA<MeldValid>());
    });

    test('rejects mixed colours', () {
      expect(
        errorOf(check(MeldKind.run, [red(5), blue(6), red(7)])),
        const GameError.runColorMismatch(),
      );
    });

    test('rejects a gap as not consecutive', () {
      expect(
        errorOf(check(MeldKind.run, [red(5), red(7), red(8)])),
        const GameError.runNotConsecutive(),
      );
    });

    test('rejects repeated numbers as not consecutive', () {
      expect(
        errorOf(check(MeldKind.run, [red(5), red(5, 1), red(6)])),
        const GameError.runNotConsecutive(),
      );
    });

    // The single most commonly mis-implemented rule in Okey 101.
    test('12-13-1 is INVALID and reports RunCannotWrap', () {
      expect(
        errorOf(check(MeldKind.run, [red(12), red(13), red(1)])),
        const GameError.runCannotWrap(),
      );
    });

    test('13-1-2 is INVALID and reports RunCannotWrap', () {
      expect(
        errorOf(check(MeldKind.run, [red(13), red(1), red(2)])),
        const GameError.runCannotWrap(),
      );
    });

    test('11-12-13-1 is INVALID and reports RunCannotWrap', () {
      expect(
        errorOf(check(MeldKind.run, [yellow(11), yellow(12), yellow(13), yellow(1)])),
        const GameError.runCannotWrap(),
      );
    });

    test('an underflowing run (okey, 1, 2) is the same error from the other side',
        () {
      expect(
        errorOf(check(MeldKind.run, [okey, red(1), red(2)])),
        const GameError.runCannotWrap(),
      );
    });

    test('12-13 plus an okey that would have to be 1 is RunCannotWrap', () {
      expect(
        errorOf(check(MeldKind.run, [red(12), red(13), okey])),
        const GameError.runCannotWrap(),
      );
    });

    test('allowCircularRuns opts in to 12-13-1', () {
      final circular = TileSemantics.fromIndicator(
        const TileIdentity(color: TileColor.black, number: 1),
        RulePresets.standard.copyWith(allowCircularRuns: true),
      );
      final result =
          check(MeldKind.run, [red(12), red(13), red(1)], using: circular);
      expect(result, isA<MeldValid>());
      expect((result as MeldValid).points, 26);
    });

    test('a joker takes the identity its ordered position demands', () {
      final result = check(MeldKind.run, [red(5), okey, red(7)]);
      expect(result, isA<MeldValid>());
      final valid = result as MeldValid;
      expect(
        valid.jokerAssignments[1],
        const TileIdentity(color: TileColor.red, number: 6),
      );
      expect(valid.points, 5 + 6 + 7);
    });

    test('a leading joker is the tile below the run', () {
      final result = check(MeldKind.run, [okey, blue(9), blue(10)]);
      expect(result, isA<MeldValid>());
      expect(
        (result as MeldValid).jokerAssignments[0],
        const TileIdentity(color: TileColor.blue, number: 8),
      );
      expect(result.points, 8 + 9 + 10);
    });

    test('rejects more jokers than the rule set allows', () {
      expect(
        errorOf(check(MeldKind.run, [red(5), okey, okeySecondCopy])),
        const GameError.tooManyJokers(count: 2, max: 1),
      );
    });

    test('rejects a meld made only of jokers', () {
      final permissive = TileSemantics.fromIndicator(
        const TileIdentity(color: TileColor.black, number: 1),
        RulePresets.standard.copyWith(maxJokersPerMeld: 4),
      );
      expect(
        errorOf(check(MeldKind.run, [okey, okeySecondCopy], using: permissive)),
        const GameError.meldAllJokers(),
      );
    });

    test('a false joker is an ordinary tile inside a run', () {
      // Indicator red 9 -> the okey is red 10 and a false joker counts as red 9,
      // so 7-8-(false joker) is a plain, joker-free run worth 24.
      final redNine = TileSemantics.fromIndicator(
        const TileIdentity(color: TileColor.red, number: 9),
        RulePresets.standard,
      );
      final result =
          check(MeldKind.run, [red(7), red(8), falseJoker0], using: redNine);
      expect(result, isA<MeldValid>());
      final valid = result as MeldValid;
      expect(valid.points, 24);
      // It is not wild, so it takes no joker assignment.
      expect(valid.jokerAssignments, [null, null, null]);
    });

    test('a false joker in the wrong slot is still just a tile', () {
      final redNine = TileSemantics.fromIndicator(
        const TileIdentity(color: TileColor.red, number: 9),
        RulePresets.standard,
      );
      expect(
        errorOf(
          check(MeldKind.run, [red(5), red(6), falseJoker0], using: redNine),
        ),
        const GameError.runNotConsecutive(),
      );
    });
  });

  group('sets (per)', () {
    test('accepts three different colours of the same number', () {
      final result = check(MeldKind.set, [red(7), yellow(7), blue(7)]);
      expect(result, isA<MeldValid>());
      expect((result as MeldValid).points, 21);
    });

    test('accepts four different colours', () {
      final result = check(MeldKind.set, [red(9), yellow(9), blue(9), black(9)]);
      expect(result, isA<MeldValid>());
      expect((result as MeldValid).points, 36);
    });

    test('11-11-11 is worth 33, not 11', () {
      final result = check(MeldKind.set, [red(11), yellow(11), blue(11)]);
      expect((result as MeldValid).points, 33);
    });

    test('rejects a duplicate colour', () {
      expect(
        errorOf(check(MeldKind.set, [red(7), red(7, 1), blue(7)])),
        const GameError.setDuplicateColor(color: TileColor.red),
      );
    });

    test('rejects mismatched numbers', () {
      expect(
        errorOf(check(MeldKind.set, [red(7), yellow(8), blue(7)])),
        const GameError.setNumberMismatch(),
      );
    });

    test('rejects the wrong size', () {
      expect(
        errorOf(check(MeldKind.set, [red(7), yellow(7)])),
        const GameError.setWrongSize(size: 2),
      );
      expect(
        errorOf(
          check(MeldKind.set, [red(7), yellow(7), blue(7), black(7), red(7, 1)]),
        ),
        const GameError.setWrongSize(size: 5),
      );
    });

    test('a joker fills the missing colour and scores that number', () {
      final result = check(MeldKind.set, [red(12), yellow(12), okey]);
      expect(result, isA<MeldValid>());
      final valid = result as MeldValid;
      expect(valid.jokerAssignments[2]?.number, 12);
      expect(valid.jokerAssignments[2]?.color, isNot(TileColor.red));
      expect(valid.jokerAssignments[2]?.color, isNot(TileColor.yellow));
      expect(valid.points, 36);
    });
  });

  group('pairs (cift)', () {
    test('accepts two tiles of the same colour and number', () {
      final result = check(MeldKind.pair, [red(6), red(6, 1)]);
      expect(result, isA<MeldValid>());
      expect((result as MeldValid).points, 12);
    });

    test('rejects two tiles of the same number but different colours', () {
      expect(
        errorOf(check(MeldKind.pair, [red(6), blue(6)])),
        const GameError.invalidPair(),
      );
    });

    test('rejects a single tile or three tiles', () {
      expect(
        errorOf(check(MeldKind.pair, [red(6)])),
        const GameError.invalidPair(),
      );
      expect(
        errorOf(check(MeldKind.pair, [red(6), red(6, 1), blue(6)])),
        const GameError.invalidPair(),
      );
    });

    test('the okey may complete a pair', () {
      final result = check(MeldKind.pair, [red(7), okey]);
      expect(result, isA<MeldValid>());
      final valid = result as MeldValid;
      expect(
        valid.jokerAssignments[1],
        const TileIdentity(color: TileColor.red, number: 7),
      );
      expect(valid.points, 14);
    });

    test('two false jokers form a valid pair with each other', () {
      final result = check(MeldKind.pair, [falseJoker0, falseJoker1]);
      expect(result, isA<MeldValid>());
      // Both carry the indicator's identity, black 1.
      expect((result as MeldValid).points, 2);
    });

    test('two okeys are not a pair', () {
      final permissive = TileSemantics.fromIndicator(
        const TileIdentity(color: TileColor.black, number: 1),
        RulePresets.standard.copyWith(maxJokersPerMeld: 2),
      );
      expect(
        errorOf(check(MeldKind.pair, [okey, okeySecondCopy], using: permissive)),
        const GameError.meldAllJokers(),
      );
    });
  });

  group('extending a table meld (islemek)', () {
    Meld runMeld(List<Tile> tiles, {List<TileIdentity?>? assignments}) => Meld(
          id: 1,
          kind: MeldKind.run,
          ownerSeat: 0,
          tiles: tiles,
          jokerAssignments:
              assignments ?? List<TileIdentity?>.filled(tiles.length, null),
        );

    test('extends a run at the top', () {
      final result = MeldRules.extend(
        meld: runMeld([red(5), red(6), red(7)]),
        tile: red(8),
        atStart: false,
        semantics: semantics,
      );
      expect(result, isA<MeldMutated>());
      expect((result as MeldMutated).meld.tiles.length, 4);
    });

    test('extends a run at the bottom', () {
      final result = MeldRules.extend(
        meld: runMeld([red(5), red(6), red(7)]),
        tile: red(4),
        atStart: true,
        semantics: semantics,
      );
      expect(result, isA<MeldMutated>());
      expect((result as MeldMutated).meld.tiles.first, red(4));
    });

    test('a table run may grow past the lay-down maximum of five', () {
      final six = MeldRules.extend(
        meld: runMeld([red(3), red(4), red(5), red(6), red(7)]),
        tile: red(8),
        atStart: false,
        semantics: semantics,
      );
      expect(six, isA<MeldMutated>());
      expect((six as MeldMutated).meld.tiles.length, 6);
    });

    test('a run cannot be extended past 13 into 1', () {
      final result = MeldRules.extend(
        meld: runMeld([red(11), red(12), red(13)]),
        tile: red(1),
        atStart: false,
        semantics: semantics,
      );
      expect(
        (result as MeldMutationRejected).error,
        const GameError.runCannotWrap(),
      );
    });

    test('a run cannot be extended below 1 into 13', () {
      final result = MeldRules.extend(
        meld: runMeld([red(1), red(2), red(3)]),
        tile: red(13),
        atStart: true,
        semantics: semantics,
      );
      expect(
        (result as MeldMutationRejected).error,
        const GameError.runCannotWrap(),
      );
    });

    test('rejects a tile that does not continue the run', () {
      final result = MeldRules.extend(
        meld: runMeld([red(5), red(6), red(7)]),
        tile: red(10),
        atStart: false,
        semantics: semantics,
      );
      expect(result, isA<MeldMutationRejected>());
    });

    test('completes a set with the missing colour', () {
      final meld = Meld(
        id: 2,
        kind: MeldKind.set,
        ownerSeat: 1,
        tiles: [red(7), yellow(7), blue(7)],
        jokerAssignments: const [null, null, null],
      );
      final result = MeldRules.extend(
        meld: meld,
        tile: black(7),
        atStart: false,
        semantics: semantics,
      );
      expect(result, isA<MeldMutated>());
      expect((result as MeldMutated).meld.tiles.length, 4);
    });

    test('rejects a colour the set already shows', () {
      final meld = Meld(
        id: 2,
        kind: MeldKind.set,
        ownerSeat: 1,
        tiles: [red(7), yellow(7), blue(7)],
        jokerAssignments: const [null, null, null],
      );
      final result = MeldRules.extend(
        meld: meld,
        tile: red(7, 1),
        atStart: false,
        semantics: semantics,
      );
      expect(
        (result as MeldMutationRejected).error,
        const GameError.setDuplicateColor(color: TileColor.red),
      );
    });

    test('a pair can never be extended', () {
      final meld = Meld(
        id: 3,
        kind: MeldKind.pair,
        ownerSeat: 0,
        tiles: [red(6), red(6, 1)],
        jokerAssignments: const [null, null],
      );
      final result = MeldRules.extend(
        meld: meld,
        tile: red(6),
        atStart: false,
        semantics: semantics,
      );
      expect(result, isA<MeldMutationRejected>());
    });
  });

  group('replacing a table joker', () {
    final meld = Meld(
      id: 7,
      kind: MeldKind.run,
      ownerSeat: 2,
      tiles: [red(5), okey, red(7)],
      jokerAssignments: const [
        null,
        TileIdentity(color: TileColor.red, number: 6),
        null,
      ],
    );

    test('accepts the exact tile the joker stands for', () {
      final result = MeldRules.replaceJoker(
        meld: meld,
        index: 1,
        tile: red(6),
        semantics: semantics,
      );
      expect(result, isA<MeldMutated>());
      final mutated = (result as MeldMutated).meld;
      expect(mutated.tiles[1], red(6));
      expect(mutated.jokerAssignments[1], isNull);
    });

    test('rejects a different tile', () {
      final result = MeldRules.replaceJoker(
        meld: meld,
        index: 1,
        tile: red(9),
        semantics: semantics,
      );
      expect(
        (result as MeldMutationRejected).error,
        const GameError.jokerReplacementMismatch(),
      );
    });

    test('rejects a position that holds no joker', () {
      final result = MeldRules.replaceJoker(
        meld: meld,
        index: 0,
        tile: red(5, 1),
        semantics: semantics,
      );
      expect(
        (result as MeldMutationRejected).error,
        const GameError.notAJokerAtPosition(meldId: 7, index: 0),
      );
    });

    test('a false joker is not wild and cannot be swapped out', () {
      final withFalseJoker = Meld(
        id: 8,
        kind: MeldKind.run,
        ownerSeat: 0,
        // Indicator black 1, so the false joker sits as black 1.
        tiles: [falseJoker0, black(2, 1), black(3)],
        jokerAssignments: const [null, null, null],
      );
      final result = MeldRules.replaceJoker(
        meld: withFalseJoker,
        index: 0,
        tile: black(1),
        semantics: semantics,
      );
      expect(
        (result as MeldMutationRejected).error,
        const GameError.cannotReplaceFalseJoker(),
      );
    });

    test('honours canReplaceJokerOnTable', () {
      final locked = TileSemantics.fromIndicator(
        const TileIdentity(color: TileColor.black, number: 1),
        RulePresets.standard.copyWith(canReplaceJokerOnTable: false),
      );
      final result = MeldRules.replaceJoker(
        meld: meld,
        index: 1,
        tile: red(6),
        semantics: locked,
      );
      expect(
        (result as MeldMutationRejected).error,
        const GameError.jokerReplacementDisabled(),
      );
    });
  });
}
