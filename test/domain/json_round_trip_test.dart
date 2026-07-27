import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/engine/dealer.dart';
import 'package:okey101/domain/models/game_action.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/hand_result.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/scoring.dart';
import 'package:okey101/domain/models/tile.dart';

import 'test_tiles.dart';

/// These are the tests that catch the `explicit_to_json` class of bug: without
/// it, a nested model is emitted as a live Dart object rather than a map and
/// `Model.fromJson(model.toJson())` throws a cast error.
void main() {
  group('RuleSet', () {
    test('standard survives a JSON round trip', () {
      const rules = RulePresets.standard;
      expect(RuleSet.fromJson(rules.toJson()), rules);
    });

    test('aggressive survives a JSON round trip', () {
      final rules = RulePresets.aggressive;
      expect(RuleSet.fromJson(rules.toJson()), rules);
    });

    test('survives an encode/decode through a real JSON string', () {
      final rules = RulePresets.standard.copyWith(
        preset: RulePreset.custom,
        openThreshold: 121,
        escalatingOpenThreshold: true,
        allowCircularRuns: true,
        maxRunLengthOnLayDown: 6,
        maxJokersPerMeld: 2,
        minPairsToOpen: 4,
        pairsToFinish: 10,
        okeyDeadwoodValue: 40,
        handsPerMatch: 7,
        targetScore: -333,
        matchEndMode: MatchEndMode.targetOnly,
        onDeckExhausted: DeckExhaustedPolicy.voidHand,
        startingPlayerRotation: StartingPlayerRotation.seededRandom,
        falseJokerAsIndicator: FalseJokerIndicatorPolicy.drawNext,
      );
      final decoded = RuleSet.fromJson(
        jsonDecode(jsonEncode(rules.toJson())) as Map<String, dynamic>,
      );
      expect(decoded, rules);
      expect(decoded.scoringTable.normal.notOpened, isA<FlatPenalty>());
    });

    test('the nested scoring table really is a map, not a live object', () {
      final json = RulePresets.standard.toJson();
      expect(json['scoringTable'], isA<Map<String, dynamic>>());
      final table = json['scoringTable']! as Map<String, dynamic>;
      expect(table['normal'], isA<Map<String, dynamic>>());
      final normal = table['normal']! as Map<String, dynamic>;
      expect(normal['opened'], isA<Map<String, dynamic>>());
    });
  });

  group('ScoringTable', () {
    test('round trips both penalty shapes', () {
      const table = ScoringTable();
      final decoded = ScoringTable.fromJson(
        jsonDecode(jsonEncode(table.toJson())) as Map<String, dynamic>,
      );
      expect(decoded, table);
      expect(decoded.normal.opened, const DeadwoodMultiple(multiplier: 1));
      expect(decoded.normal.notOpened, const FlatPenalty(points: 202));
      expect(decoded.exhausted.winnerPoints, isNull);
      expect(decoded.exhausted.notOpened, const DeadwoodMultiple(multiplier: 1));
    });

    test('doubling doubles every number', () {
      final doubled = const ScoringTable().doubled;
      expect(doubled.normal.winnerPoints, -202);
      expect(doubled.normal.notOpened, const FlatPenalty(points: 404));
      expect(doubled.pairsWithOkey.opened, const DeadwoodMultiple(multiplier: 8));
      expect(doubled.exhausted.winnerPoints, isNull);
    });

    test('rowFor covers every key', () {
      const table = ScoringTable();
      for (final key in ScoreRowKey.values) {
        expect(table.rowFor(key), isNotNull);
      }
      for (final type in FinishType.values) {
        expect(table.rowFor(ScoreRowKey.fromFinishType(type)), isNotNull);
      }
    });
  });

  group('Tile and Meld', () {
    test('a numbered tile round trips', () {
      final tile = red(9, 1);
      expect(Tile.fromJson(tile.toJson()), tile);
    });

    test('a false joker round trips with null colour and number', () {
      expect(Tile.fromJson(falseJoker0.toJson()), falseJoker0);
      expect(falseJoker0.toJson()['color'], isNull);
    });

    test('a meld with joker assignments round trips', () {
      final meld = Meld(
        id: 3,
        kind: MeldKind.run,
        ownerSeat: 1,
        tiles: [red(5), black(2), red(7)],
        jokerAssignments: const [
          null,
          TileIdentity(color: TileColor.red, number: 6),
          null,
        ],
      );
      final decoded = Meld.fromJson(
        jsonDecode(jsonEncode(meld.toJson())) as Map<String, dynamic>,
      );
      expect(decoded, meld);
      expect(decoded.jokerAssignments[1]?.number, 6);
    });
  });

  group('GameAction', () {
    test('every union case round trips', () {
      final actions = <GameAction>[
        const GameAction.drawFromPile(),
        const GameAction.drawFromDiscard(),
        const GameAction.discard(tileId: 12),
        const GameAction.open(
          melds: [
            MeldProposal(kind: MeldKind.run, tileIds: [1, 2, 3]),
            MeldProposal(kind: MeldKind.set, tileIds: [4, 5, 6]),
          ],
        ),
        const GameAction.layPairs(
          pairs: [
            MeldProposal(kind: MeldKind.pair, tileIds: [7, 8]),
          ],
        ),
        const GameAction.layMeld(
          meld: MeldProposal(kind: MeldKind.run, tileIds: [9, 10, 11]),
        ),
        const GameAction.addToMeld(meldId: 2, tileId: 30, atStart: true),
        const GameAction.replaceJoker(meldId: 2, index: 1, tileId: 31),
        const GameAction.startNextHand(),
      ];
      for (final action in actions) {
        final decoded = GameAction.fromJson(
          jsonDecode(jsonEncode(action.toJson())) as Map<String, dynamic>,
        );
        expect(decoded, action, reason: '$action did not round trip');
      }
    });
  });

  group('GameState', () {
    test('a freshly dealt state round trips through a JSON string', () {
      final state = Dealer.newMatch(
        ruleSet: RulePresets.standard,
        seed: 90210,
        names: const ['A', 'B', 'C', 'D'],
        humans: const [true, false, false, false],
      );
      final decoded = GameState.fromJson(
        jsonDecode(jsonEncode(state.toJson())) as Map<String, dynamic>,
      );
      expect(decoded, state);
      expect(decoded.drawPile.length, kDrawPileSize);
      expect(decoded.allTiles().length, kTotalTiles);
    });
  });

  group('HandResult', () {
    test('round trips', () {
      const result = HandResult(
        handNumber: 3,
        winnerSeat: 2,
        finishType: FinishType.okeyHead,
        rowKey: ScoreRowKey.okeyHead,
        players: [
          PlayerHandResult(
            seat: 0,
            deadwood: 37,
            hasOpened: true,
            delta: 37,
            total: 120,
          ),
        ],
      );
      final decoded = HandResult.fromJson(
        jsonDecode(jsonEncode(result.toJson())) as Map<String, dynamic>,
      );
      expect(decoded, result);
    });
  });
}
