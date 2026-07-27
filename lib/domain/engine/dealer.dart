import 'package:okey101/domain/engine/random_source.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/hand_result.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/tile_deck.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

/// Deals a hand. Pure: all randomness comes from the [RandomSource] built from
/// the state carried in [GameState.randomState].
abstract final class Dealer {
  /// Default seat names, used when the caller does not supply localised ones.
  static const List<String> defaultNames = <String>['P0', 'P1', 'P2', 'P3'];

  /// Deals hand [handNumber], preserving [scores] and [history].
  ///
  /// Order of operations is shuffle -> reveal indicator -> deal, which is what
  /// makes the draw pile exactly [kDrawPileSize] tiles.
  static GameState deal({
    required RuleSet ruleSet,
    required int seed,
    required int randomState,
    required int handNumber,
    required int startingSeat,
    required List<String> names,
    required List<bool> humans,
    required List<int> scores,
    List<HandResult> history = const <HandResult>[],
  }) {
    final rng = RandomSource.fromState(randomState);
    final deck = TileDeck.standard();
    rng.shuffle(deck);

    var indicator = deck.removeLast();
    while (indicator.isFalseJoker) {
      switch (ruleSet.falseJokerAsIndicator) {
        case FalseJokerIndicatorPolicy.reshuffle:
          deck.add(indicator);
          rng.shuffle(deck);
        case FalseJokerIndicatorPolicy.drawNext:
          // The false joker goes back to the bottom so the tile count holds.
          deck.insert(0, indicator);
      }
      indicator = deck.removeLast();
    }

    final hands = List<List<Tile>>.generate(kSeatCount, (_) => <Tile>[]);
    for (var seat = 0; seat < kSeatCount; seat++) {
      final count = seat == startingSeat ? kHandSize + 1 : kHandSize;
      for (var i = 0; i < count; i++) {
        hands[seat].add(deck.removeLast());
      }
    }
    for (final hand in hands) {
      hand.sort((a, b) => a.id.compareTo(b.id));
    }

    assert(
      deck.length == kDrawPileSize,
      'Draw pile must hold exactly $kDrawPileSize tiles, got ${deck.length}',
    );

    final players = List<PlayerState>.generate(
      kSeatCount,
      (seat) => PlayerState(
        seat: seat,
        name: names[seat],
        isHuman: humans[seat],
        hand: hands[seat],
        discards: const <Tile>[],
        score: scores[seat],
      ),
    );

    // Safe: the loop above guarantees a numbered indicator.
    final indicatorIdentity = indicator.printedIdentity!;

    return GameState(
      ruleSet: ruleSet,
      seed: seed,
      randomState: rng.state,
      handNumber: handNumber,
      startingSeat: startingSeat,
      indicator: indicator,
      okey: TileSemantics.okeyForIndicator(indicatorIdentity),
      drawPile: deck,
      players: players,
      table: const <Meld>[],
      currentSeat: startingSeat,
      // The starting player opens the hand by discarding, without drawing.
      phase: TurnPhase.awaitingDiscard,
      history: history,
    );
  }

  /// Deals the first hand of a fresh match.
  static GameState newMatch({
    required RuleSet ruleSet,
    required int seed,
    required List<String> names,
    required List<bool> humans,
  }) {
    // Hand 1's starting player is seeded-random for every rotation policy.
    final rng = RandomSource(seed);
    final startingSeat = rng.nextInt(kSeatCount);
    return deal(
      ruleSet: ruleSet,
      seed: seed,
      randomState: rng.state,
      handNumber: 1,
      startingSeat: startingSeat,
      names: names,
      humans: humans,
      scores: List<int>.filled(kSeatCount, 0),
    );
  }

  /// Who starts hand `n + 1` given who started hand `n`.
  static int nextStartingSeat({
    required RuleSet ruleSet,
    required int previousStartingSeat,
    required RandomSource rng,
  }) =>
      switch (ruleSet.startingPlayerRotation) {
        StartingPlayerRotation.rotate => seatToRightOf(previousStartingSeat),
        StartingPlayerRotation.fixed => previousStartingSeat,
        StartingPlayerRotation.seededRandom => rng.nextInt(kSeatCount),
      };
}
