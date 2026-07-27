import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/engine/dealer.dart';
import 'package:okey101/domain/engine/random_source.dart';
import 'package:okey101/domain/engine/state_invariants.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/rules/tile_deck.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

void main() {
  const names = ['P0', 'P1', 'P2', 'P3'];
  const humans = [true, false, false, false];

  GameState dealWithSeed(int seed, {RuleSet? rules}) => Dealer.newMatch(
        ruleSet: rules ?? RulePresets.standard,
        seed: seed,
        names: names,
        humans: humans,
      );

  group('deal', () {
    test('gives 21 tiles to each player and 22 to the starter', () {
      for (var seed = 1; seed <= 50; seed++) {
        final state = dealWithSeed(seed);
        for (final player in state.players) {
          final expected =
              player.seat == state.startingSeat ? kHandSize + 1 : kHandSize;
          expect(
            player.hand.length,
            expected,
            reason: 'seed $seed seat ${player.seat}',
          );
        }
      }
    });

    test('leaves exactly 20 tiles in the draw pile', () {
      for (var seed = 1; seed <= 50; seed++) {
        expect(dealWithSeed(seed).drawPile.length, kDrawPileSize);
      }
    });

    test('accounts for all 106 tiles', () {
      for (var seed = 1; seed <= 50; seed++) {
        final state = dealWithSeed(seed);
        expect(state.allTiles().length, kTotalTiles);
        expect(StateInvariants.violation(state), isNull);
      }
    });

    test('starts the hand with the dealer discarding, not drawing', () {
      final state = dealWithSeed(7);
      expect(state.phase, TurnPhase.awaitingDiscard);
      expect(state.currentSeat, state.startingSeat);
      expect(state.currentPlayer.hand.length, kHandSize + 1);
    });

    test('hands come back in canonical id order', () {
      final state = dealWithSeed(11);
      for (final player in state.players) {
        final ids = player.hand.map((t) => t.id).toList();
        final sorted = List<int>.of(ids)..sort();
        expect(ids, sorted);
      }
    });

    test('is fully reproducible from the seed', () {
      final a = dealWithSeed(4242);
      final b = dealWithSeed(4242);
      expect(a, b);
    });

    test('different seeds give different deals', () {
      final a = dealWithSeed(1);
      final b = dealWithSeed(2);
      expect(a.players[0].hand, isNot(b.players[0].hand));
    });

    test('derives the okey from the indicator', () {
      for (var seed = 1; seed <= 100; seed++) {
        final state = dealWithSeed(seed);
        final identity = state.indicator.printedIdentity;
        expect(identity, isNotNull);
        expect(state.okey, TileSemantics.okeyForIndicator(identity!));
        expect(state.okey.color, identity.color);
        expect(
          state.okey.number,
          identity.number == 13 ? 1 : identity.number + 1,
        );
      }
    });
  });

  group('false joker as indicator', () {
    /// Replays exactly what [Dealer.newMatch] does up to the first flip, so the
    /// test can find seeds that genuinely exercise the reshuffle branch.
    bool firstFlipIsFalseJoker(int seed) {
      final rng = RandomSource(seed)..nextInt(kSeatCount);
      final deck = TileDeck.standard();
      RandomSource.fromState(rng.state).shuffle(deck);
      return deck.last.isFalseJoker;
    }

    test('the corpus actually contains seeds that flip a false joker', () {
      final hits = [
        for (var seed = 1; seed <= 2000; seed++)
          if (firstFlipIsFalseJoker(seed)) seed,
      ];
      expect(
        hits,
        isNotEmpty,
        reason: 'without such a seed the next test would be vacuous',
      );
    });

    test('reshuffles until the indicator is a numbered tile', () {
      var exercised = 0;
      for (var seed = 1; seed <= 2000; seed++) {
        if (!firstFlipIsFalseJoker(seed)) continue;
        exercised++;
        final state = dealWithSeed(seed);
        expect(state.indicator.isFalseJoker, isFalse);
        expect(state.drawPile.length, kDrawPileSize);
        expect(StateInvariants.violation(state), isNull);
      }
      expect(exercised, greaterThan(0));
    });

    test('drawNext also lands on a numbered indicator', () {
      final rules = RulePresets.standard
          .copyWith(falseJokerAsIndicator: FalseJokerIndicatorPolicy.drawNext);
      var exercised = 0;
      for (var seed = 1; seed <= 2000; seed++) {
        if (!firstFlipIsFalseJoker(seed)) continue;
        exercised++;
        final state = dealWithSeed(seed, rules: rules);
        expect(state.indicator.isFalseJoker, isFalse);
        expect(state.drawPile.length, kDrawPileSize);
        expect(StateInvariants.violation(state), isNull);
      }
      expect(exercised, greaterThan(0));
    });

    test('the indicator is never a false joker across many seeds', () {
      for (var seed = 1; seed <= 500; seed++) {
        expect(dealWithSeed(seed).indicator.isFalseJoker, isFalse);
      }
    });
  });

  group('starting seat rotation', () {
    test('rotate moves counter-clockwise to the seat on the right', () {
      final rng = RandomSource(1);
      for (var seat = 0; seat < kSeatCount; seat++) {
        expect(
          Dealer.nextStartingSeat(
            ruleSet: RulePresets.standard,
            previousStartingSeat: seat,
            rng: rng,
          ),
          seatToRightOf(seat),
        );
      }
    });

    test('fixed keeps the same seat', () {
      final rng = RandomSource(1);
      final rules = RulePresets.standard
          .copyWith(startingPlayerRotation: StartingPlayerRotation.fixed);
      expect(
        Dealer.nextStartingSeat(
          ruleSet: rules,
          previousStartingSeat: 2,
          rng: rng,
        ),
        2,
      );
    });
  });

  group('seat geometry', () {
    test('the left neighbour plays before you, the right one after', () {
      expect(seatToRightOf(0), 1);
      expect(seatToLeftOf(0), 3);
      for (var seat = 0; seat < kSeatCount; seat++) {
        expect(seatToLeftOf(seatToRightOf(seat)), seat);
      }
    });
  });
}
