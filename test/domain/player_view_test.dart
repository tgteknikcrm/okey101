import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/engine/dealer.dart';
import 'package:okey101/domain/engine/player_view_factory.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/player_view.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/tile.dart';

/// Bots must only ever see what a human at the table could see.
///
/// This is enforced two ways: structurally, by proving no bot source file can
/// even name [GameState], and behaviourally, by proving a redacted view holds
/// no tile that is supposed to be hidden.
void main() {
  GameState freshGame(int seed) => Dealer.newMatch(
        ruleSet: RulePresets.standard,
        seed: seed,
        names: const ['A', 'B', 'C', 'D'],
        humans: const [true, false, false, false],
      );

  /// Every tile physically reachable through a view.
  List<Tile> tilesVisibleIn(PlayerView view) => <Tile>[
        view.indicator,
        ...view.hand,
        ...view.ownDiscards,
        for (final opponent in view.opponents) ...opponent.discards,
        for (final meld in view.table) ...meld.tiles,
      ];

  group('type-level redaction', () {
    test('PlayerView never names GameState', () {
      final source =
          File('lib/domain/models/player_view.dart').readAsStringSync();
      expect(
        source.contains('GameState'),
        isFalse,
        reason: 'PlayerView must not be able to reach full game state',
      );
      // Only the count crosses the boundary, never the pile itself.
      expect(source.contains('drawPileCount'), isTrue);
      expect(
        RegExp(r'List<Tile>\s+drawPile\b').hasMatch(source),
        isFalse,
      );
    });

    test('OpponentView exposes a tile COUNT, never a rack', () {
      final source =
          File('lib/domain/models/player_view.dart').readAsStringSync();
      final opponentBlock = source.substring(
        source.indexOf('abstract class OpponentView'),
        source.indexOf('abstract class PlayerView'),
      );
      expect(opponentBlock.contains('required int tileCount'), isTrue);
      expect(
        RegExp(r'List<Tile>\s+hand\b').hasMatch(opponentBlock),
        isFalse,
        reason: 'an opponent rack must be unreachable',
      );
    });

    test('no bot source file can name GameState', () {
      final botFiles = Directory('lib/domain/ai')
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList();
      expect(
        botFiles.length,
        greaterThanOrEqualTo(6),
        reason: 'a wrong path must not make this test vacuous',
      );
      final offenders = <String>[];
      for (final file in botFiles) {
        final source = file.readAsStringSync();
        // `game_state.dart` is imported for TurnPhase and the seat helpers; the
        // GameState type itself must never appear.
        if (RegExp(r'\bGameState\b').hasMatch(source)) {
          offenders.add(file.path);
        }
      }
      expect(offenders, isEmpty);
    });
  });

  group('behavioural redaction', () {
    test('a view holds no tile from the pile or another rack', () {
      for (var seed = 1; seed <= 40; seed++) {
        final state = freshGame(seed);
        for (var seat = 0; seat < kSeatCount; seat++) {
          final view = PlayerViewFactory.forSeat(state, seat);
          final hidden = <int>{
            ...state.drawPile.map((t) => t.id),
            for (var other = 0; other < kSeatCount; other++)
              if (other != seat) ...state.players[other].hand.map((t) => t.id),
          };
          final visible = tilesVisibleIn(view).map((t) => t.id).toSet();
          expect(
            visible.intersection(hidden),
            isEmpty,
            reason: 'seed $seed seat $seat leaked hidden tiles',
          );
        }
      }
    });

    test('the view carries the seat own rack in full', () {
      final state = freshGame(7);
      for (var seat = 0; seat < kSeatCount; seat++) {
        final view = PlayerViewFactory.forSeat(state, seat);
        expect(view.hand, state.players[seat].hand);
        expect(view.drawPileCount, state.drawPile.length);
        expect(view.opponents.length, kSeatCount - 1);
      }
    });

    test('opponents are listed in turn order from the viewer right', () {
      final state = freshGame(11);
      for (var seat = 0; seat < kSeatCount; seat++) {
        final view = PlayerViewFactory.forSeat(state, seat);
        expect(
          view.opponents.map((o) => o.seat).toList(),
          [
            for (var step = 1; step < kSeatCount; step++)
              (seat + step) % kSeatCount,
          ],
        );
        expect(view.rightNeighbour.seat, seatToRightOf(seat));
        expect(view.leftNeighbour.seat, seatToLeftOf(seat));
      }
    });

    test('the taken-tile marker is only shown to the seat on turn', () {
      final state = freshGame(3).copyWith(takenFromDiscardTileId: 42);
      for (var seat = 0; seat < kSeatCount; seat++) {
        final view = PlayerViewFactory.forSeat(state, seat);
        if (seat == state.currentSeat) {
          expect(view.takenFromDiscardTileId, 42);
        } else {
          expect(view.takenFromDiscardTileId, isNull);
        }
      }
    });

    test('a view round trips through JSON', () {
      final view = PlayerViewFactory.forSeat(freshGame(5), 2);
      expect(PlayerView.fromJson(view.toJson()), view);
    });
  });
}
