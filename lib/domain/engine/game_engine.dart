import 'package:okey101/domain/engine/dealer.dart';
import 'package:okey101/domain/engine/engine_result.dart';
import 'package:okey101/domain/engine/random_source.dart';
import 'package:okey101/domain/engine/score_calculator.dart';
import 'package:okey101/domain/engine/state_invariants.dart';
import 'package:okey101/domain/models/game_action.dart';
import 'package:okey101/domain/models/game_error.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/scoring.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/meld_rules.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

/// The rules engine.
///
/// [apply] is a pure function: it never mutates its input, never reads the
/// clock, and never touches ambient randomness. Everything random comes from a
/// [RandomSource] rebuilt from [GameState.randomState], so a game replays
/// exactly from `(seed, canonicalActions)`.
abstract final class GameEngine {
  /// Applies [action] on behalf of the player whose turn it is.
  static EngineResult apply(GameState state, GameAction action) {
    if (state.phase == TurnPhase.matchOver) {
      return const EngineErr(GameError.matchAlreadyOver());
    }
    if (state.phase == TurnPhase.handOver && action is! StartNextHand) {
      return const EngineErr(GameError.wrongPhase());
    }

    final result = switch (action) {
      DrawFromPile() => _drawFromPile(state),
      DrawFromDiscard() => _drawFromDiscard(state),
      DiscardTile(:final tileId) => _discard(state, tileId),
      OpenWithMelds(:final melds) => _open(state, melds),
      LayPairs(:final pairs) => _layPairs(state, pairs),
      LayNewMeld(:final meld) => _layNewMeld(state, meld),
      AddToMeld(:final meldId, :final tileId, :final atStart) =>
        _addToMeld(state, meldId, tileId, atStart: atStart),
      ReplaceJoker(:final meldId, :final index, :final tileId) =>
        _replaceJoker(state, meldId, index, tileId),
      StartNextHand() => _startNextHand(state),
    };

    if (result is EngineOk) {
      StateInvariants.assertValid(result.state);
    }
    return result;
  }

  /// The tile semantics implied by a state's indicator and rule set.
  static TileSemantics semanticsOf(GameState state) => TileSemantics(
        indicatorIdentity: state.indicatorIdentity,
        okey: state.okey,
        ruleSet: state.ruleSet,
      );

  /// Points the current player must lay down to open right now.
  static int openThresholdFor(GameState state) =>
      state.ruleSet.openThresholdFor(state.openedCount);

  // --- Drawing -------------------------------------------------------------

  static EngineResult _drawFromPile(GameState state) {
    if (state.phase != TurnPhase.awaitingDraw) {
      return const EngineErr(GameError.wrongPhase());
    }
    if (state.drawPile.isEmpty) {
      return const EngineErr(GameError.drawPileEmpty());
    }
    final pile = List<Tile>.of(state.drawPile);
    final drawn = pile.removeLast();
    return EngineOk(
      _withPlayer(
        state,
        state.currentSeat,
        (player) => player.copyWith(hand: _sorted([...player.hand, drawn])),
      ).copyWith(
        drawPile: pile,
        phase: TurnPhase.awaitingDiscard,
        takenFromDiscardTileId: null,
      ),
    );
  }

  static EngineResult _drawFromDiscard(GameState state) {
    if (state.phase != TurnPhase.awaitingDraw) {
      return const EngineErr(GameError.wrongPhase());
    }
    final player = state.currentPlayer;
    if (!player.hasOpened && !state.ruleSet.canTakeDiscardBeforeOpening) {
      return const EngineErr(GameError.takeDiscardBeforeOpeningDisabled());
    }
    final leftSeat = seatToLeftOf(state.currentSeat);
    final leftPile = state.players[leftSeat].discards;
    if (leftPile.isEmpty) {
      return const EngineErr(GameError.discardPileEmpty());
    }

    final newLeftPile = List<Tile>.of(leftPile);
    final taken = newLeftPile.removeLast();
    final players = List<PlayerState>.of(state.players);
    players[leftSeat] = players[leftSeat].copyWith(discards: newLeftPile);
    players[state.currentSeat] = players[state.currentSeat]
        .copyWith(hand: _sorted([...player.hand, taken]));

    return EngineOk(
      state.copyWith(
        players: players,
        phase: TurnPhase.awaitingDiscard,
        takenFromDiscardTileId: taken.id,
      ),
    );
  }

  // --- Discarding and finishing --------------------------------------------

  static EngineResult _discard(GameState state, int tileId) {
    if (state.phase != TurnPhase.awaitingDiscard) {
      return const EngineErr(GameError.wrongPhase());
    }
    final player = state.currentPlayer;
    final index = player.hand.indexWhere((t) => t.id == tileId);
    if (index < 0) {
      return EngineErr(GameError.tileNotInHand(tileId: tileId));
    }
    if (state.takenFromDiscardTileId == tileId) {
      return EngineErr(GameError.sameTileDiscardedBack(tileId: tileId));
    }

    final hand = List<Tile>.of(player.hand);
    final discarded = hand.removeAt(index);
    final next = _withPlayer(
      state,
      state.currentSeat,
      (p) => p.copyWith(hand: hand, discards: [...p.discards, discarded]),
    );

    if (hand.isEmpty) {
      final semantics = semanticsOf(state);
      final discardedOkey = semantics.isWild(discarded);
      final finishType = state.openedThisTurn
          ? (discardedOkey ? FinishType.okeyHead : FinishType.head)
          : (discardedOkey ? FinishType.withOkey : FinishType.normal);
      return EngineOk(_finishHand(next, state.currentSeat, finishType));
    }

    return EngineOk(_advanceTurn(next));
  }

  static GameState _advanceTurn(GameState state) {
    // The hand ends the moment the 20-tile draw pile is exhausted. Without
    // this the hand could circulate discards forever, and it is also the
    // ordinary house rule.
    if (state.drawPile.isEmpty) {
      return _finishHand(state, null, null);
    }
    return state.copyWith(
      currentSeat: seatToRightOf(state.currentSeat),
      phase: TurnPhase.awaitingDraw,
      takenFromDiscardTileId: null,
      openedThisTurn: false,
    );
  }

  static GameState _finishHand(
    GameState state,
    int? winnerSeat,
    FinishType? finishType,
  ) {
    final result = ScoreCalculator.score(
      state: state,
      winnerSeat: winnerSeat,
      finishType: finishType,
    );
    final players = <PlayerState>[
      for (final player in state.players)
        player.copyWith(
          score: result.players
              .firstWhere((line) => line.seat == player.seat)
              .total,
        ),
    ];
    final matchOver = ScoreCalculator.isMatchOver(
      rules: state.ruleSet,
      handNumber: state.handNumber,
      totals: players.map((p) => p.score).toList(),
    );
    return state.copyWith(
      players: players,
      phase: matchOver ? TurnPhase.matchOver : TurnPhase.handOver,
      handResult: result,
      history: [...state.history, result],
      takenFromDiscardTileId: null,
      openedThisTurn: false,
    );
  }

  static EngineResult _startNextHand(GameState state) {
    if (state.phase != TurnPhase.handOver) {
      return const EngineErr(GameError.handNotOver());
    }
    final rng = RandomSource.fromState(state.randomState);
    final nextSeat = Dealer.nextStartingSeat(
      ruleSet: state.ruleSet,
      previousStartingSeat: state.startingSeat,
      rng: rng,
    );
    return EngineOk(
      Dealer.deal(
        ruleSet: state.ruleSet,
        seed: state.seed,
        randomState: rng.state,
        handNumber: state.handNumber + 1,
        startingSeat: nextSeat,
        names: state.players.map((p) => p.name).toList(),
        humans: state.players.map((p) => p.isHuman).toList(),
        scores: state.players.map((p) => p.score).toList(),
        history: state.history,
      ),
    );
  }

  // --- Opening -------------------------------------------------------------

  static EngineResult _open(GameState state, List<MeldProposal> proposals) {
    if (state.phase != TurnPhase.awaitingDiscard) {
      return const EngineErr(GameError.wrongPhase());
    }
    final player = state.currentPlayer;
    if (player.hasOpened) {
      return const EngineErr(GameError.alreadyOpened());
    }
    if (proposals.isEmpty) {
      return const EngineErr(GameError.emptyProposal());
    }
    for (final proposal in proposals) {
      if (proposal.kind == MeldKind.pair) {
        return const EngineErr(GameError.pairsPathViolation());
      }
    }

    final semantics = semanticsOf(state);
    final resolved = _resolveProposals(player.hand, proposals, semantics);
    if (resolved is _ResolveFailed) {
      return EngineErr(resolved.error);
    }
    final ok = resolved as _ResolveOk;
    final required = openThresholdFor(state);
    if (ok.points < required) {
      if (!state.ruleSet.enforceIllegalOpenPenalty) {
        return EngineErr(
          GameError.openThresholdNotMet(
            requiredPoints: required,
            actualPoints: ok.points,
          ),
        );
      }
      // Faithful-simulation mode: the attempt is punished but the melds stay in
      // hand, the player still discards this turn, and may try again later.
      return EngineOk(
        _withPlayer(
          state,
          state.currentSeat,
          (p) => p.copyWith(score: p.score + state.ruleSet.illegalOpenPenalty),
        ),
      );
    }

    final remaining = ok.remainingHand;
    if (!_leavesALegalDiscard(remaining, state.takenFromDiscardTileId)) {
      return const EngineErr(GameError.mustDiscardToFinish());
    }

    return EngineOk(
      _layDown(
        state,
        remainingHand: remaining,
        melds: ok.melds,
        markOpened: true,
        withPairs: false,
      ),
    );
  }

  static EngineResult _layPairs(GameState state, List<MeldProposal> proposals) {
    if (state.phase != TurnPhase.awaitingDiscard) {
      return const EngineErr(GameError.wrongPhase());
    }
    if (proposals.isEmpty) {
      return const EngineErr(GameError.emptyProposal());
    }
    for (final proposal in proposals) {
      if (proposal.kind != MeldKind.pair) {
        return const EngineErr(GameError.pairsPathViolation());
      }
    }
    final player = state.currentPlayer;
    final opening = !player.hasOpened;
    if (!opening && !player.openedWithPairs) {
      return const EngineErr(GameError.pairsPathViolation());
    }
    if (opening && proposals.length < state.ruleSet.minPairsToOpen) {
      return EngineErr(
        GameError.notEnoughPairs(
          requiredPairs: state.ruleSet.minPairsToOpen,
          actualPairs: proposals.length,
        ),
      );
    }

    final semantics = semanticsOf(state);
    final resolved = _resolveProposals(player.hand, proposals, semantics);
    if (resolved is _ResolveFailed) {
      return EngineErr(resolved.error);
    }
    final ok = resolved as _ResolveOk;

    final alreadyLaid = state.table
        .where((m) => m.ownerSeat == state.currentSeat && m.kind == MeldKind.pair)
        .length;
    final totalPairs = alreadyLaid + proposals.length;

    // Unless this lay-down goes out, the turn still has to end with a discard.
    if (ok.remainingHand.isNotEmpty &&
        !_leavesALegalDiscard(
          ok.remainingHand,
          state.takenFromDiscardTileId,
        )) {
      return const EngineErr(GameError.mustDiscardToFinish());
    }

    final next = _layDown(
      state,
      remainingHand: ok.remainingHand,
      melds: ok.melds,
      markOpened: opening,
      withPairs: true,
    );

    if (ok.remainingHand.isEmpty) {
      if (totalPairs < state.ruleSet.pairsToFinish) {
        // Nothing left to discard but not enough pairs to go out.
        return const EngineErr(GameError.mustDiscardToFinish());
      }
      // The last tile completed the final pair, so nothing is discarded.
      final usedOkey = ok.melds.any(
        (meld) => meld.tiles.any(semantics.isWild),
      );
      return EngineOk(
        _finishHand(
          next,
          state.currentSeat,
          usedOkey ? FinishType.pairsWithOkey : FinishType.pairs,
        ),
      );
    }
    return EngineOk(next);
  }

  static EngineResult _layNewMeld(GameState state, MeldProposal proposal) {
    if (state.phase != TurnPhase.awaitingDiscard) {
      return const EngineErr(GameError.wrongPhase());
    }
    final player = state.currentPlayer;
    if (!player.hasOpened) {
      return const EngineErr(GameError.notOpenedYet());
    }
    if (player.openedWithPairs) {
      return const EngineErr(GameError.pairsPathViolation());
    }
    if (!state.ruleSet.canLayNewMeldsAfterOpening) {
      return const EngineErr(GameError.newMeldsAfterOpeningDisabled());
    }
    if (proposal.kind == MeldKind.pair) {
      return const EngineErr(GameError.pairsPathViolation());
    }

    final semantics = semanticsOf(state);
    final resolved = _resolveProposals(player.hand, [proposal], semantics);
    if (resolved is _ResolveFailed) {
      return EngineErr(resolved.error);
    }
    final ok = resolved as _ResolveOk;
    if (!_leavesALegalDiscard(
      ok.remainingHand,
      state.takenFromDiscardTileId,
    )) {
      return const EngineErr(GameError.mustDiscardToFinish());
    }
    return EngineOk(
      _layDown(
        state,
        remainingHand: ok.remainingHand,
        melds: ok.melds,
        markOpened: false,
        withPairs: false,
      ),
    );
  }

  // --- Working on the table ------------------------------------------------

  static EngineResult _addToMeld(
    GameState state,
    int meldId,
    int tileId, {
    required bool atStart,
  }) {
    if (state.phase != TurnPhase.awaitingDiscard) {
      return const EngineErr(GameError.wrongPhase());
    }
    final player = state.currentPlayer;
    if (!player.hasOpened) {
      return const EngineErr(GameError.cannotAddBeforeOpening());
    }
    if (player.openedWithPairs) {
      return const EngineErr(GameError.pairsPathViolation());
    }
    final meldIndex = state.table.indexWhere((m) => m.id == meldId);
    if (meldIndex < 0) {
      return EngineErr(GameError.meldNotFound(meldId: meldId));
    }
    final tileIndex = player.hand.indexWhere((t) => t.id == tileId);
    if (tileIndex < 0) {
      return EngineErr(GameError.tileNotInHand(tileId: tileId));
    }
    // The last tile must be discarded, not worked onto the table - and it has
    // to be a tile that is legal to discard this turn.
    final afterAdd = <Tile>[
      for (final tile in player.hand)
        if (tile.id != tileId) tile,
    ];
    if (!_leavesALegalDiscard(afterAdd, state.takenFromDiscardTileId)) {
      return const EngineErr(GameError.mustDiscardToFinish());
    }

    final mutation = MeldRules.extend(
      meld: state.table[meldIndex],
      tile: player.hand[tileIndex],
      atStart: atStart,
      semantics: semanticsOf(state),
    );
    if (mutation is MeldMutationRejected) {
      return EngineErr(mutation.error);
    }

    final table = List<Meld>.of(state.table);
    table[meldIndex] = (mutation as MeldMutated).meld;
    final hand = List<Tile>.of(player.hand)..removeAt(tileIndex);
    return EngineOk(
      _withPlayer(state, state.currentSeat, (p) => p.copyWith(hand: hand))
          .copyWith(table: table),
    );
  }

  static EngineResult _replaceJoker(
    GameState state,
    int meldId,
    int index,
    int tileId,
  ) {
    if (state.phase != TurnPhase.awaitingDiscard) {
      return const EngineErr(GameError.wrongPhase());
    }
    final player = state.currentPlayer;
    if (!player.hasOpened) {
      return const EngineErr(GameError.notOpenedYet());
    }
    final meldIndex = state.table.indexWhere((m) => m.id == meldId);
    if (meldIndex < 0) {
      return EngineErr(GameError.meldNotFound(meldId: meldId));
    }
    final tileIndex = player.hand.indexWhere((t) => t.id == tileId);
    if (tileIndex < 0) {
      return EngineErr(GameError.tileNotInHand(tileId: tileId));
    }

    final meld = state.table[meldIndex];
    final freed = meld.tiles.length > index && index >= 0
        ? meld.tiles[index]
        : null;
    final mutation = MeldRules.replaceJoker(
      meld: meld,
      index: index,
      tile: player.hand[tileIndex],
      semantics: semanticsOf(state),
    );
    if (mutation is MeldMutationRejected) {
      return EngineErr(mutation.error);
    }

    final table = List<Meld>.of(state.table);
    table[meldIndex] = (mutation as MeldMutated).meld;
    final hand = List<Tile>.of(player.hand)..removeAt(tileIndex);
    // The freed okey goes into hand; the player is not required to use it now.
    if (freed != null) hand.add(freed);
    return EngineOk(
      _withPlayer(
        state,
        state.currentSeat,
        (p) => p.copyWith(hand: _sorted(hand)),
      ).copyWith(table: table),
    );
  }

  // --- Shared helpers ------------------------------------------------------

  static GameState _layDown(
    GameState state, {
    required List<Tile> remainingHand,
    required List<_ResolvedMeld> melds,
    required bool markOpened,
    required bool withPairs,
  }) {
    var nextMeldId = state.nextMeldId;
    final table = List<Meld>.of(state.table);
    for (final meld in melds) {
      table.add(
        Meld(
          id: nextMeldId++,
          kind: meld.kind,
          ownerSeat: state.currentSeat,
          tiles: meld.tiles,
          jokerAssignments: meld.jokerAssignments,
        ),
      );
    }

    final players = List<PlayerState>.of(state.players);
    final player = players[state.currentSeat];
    players[state.currentSeat] = player.copyWith(
      hand: remainingHand,
      hasOpened: markOpened || player.hasOpened,
      openedWithPairs: withPairs || player.openedWithPairs,
      openOrder: markOpened ? state.openedCount : player.openOrder,
    );

    return state.copyWith(
      players: players,
      table: table,
      nextMeldId: nextMeldId,
      openedCount: markOpened ? state.openedCount + 1 : state.openedCount,
      openedThisTurn: markOpened || state.openedThisTurn,
    );
  }

  static GameState _withPlayer(
    GameState state,
    int seat,
    PlayerState Function(PlayerState) update,
  ) {
    final players = List<PlayerState>.of(state.players);
    players[seat] = update(players[seat]);
    return state.copyWith(players: players);
  }

  static List<Tile> _sorted(List<Tile> tiles) =>
      List<Tile>.of(tiles)..sort((a, b) => a.id.compareTo(b.id));

  /// The turn must still end with a legal discard, and a tile taken from a
  /// discard pile may not go straight back. Melding down to nothing but that
  /// one tile would leave the player unable to finish their turn, so every
  /// lay-down path checks this.
  static bool _leavesALegalDiscard(List<Tile> hand, int? takenFromDiscard) {
    for (final tile in hand) {
      if (tile.id != takenFromDiscard) return true;
    }
    return false;
  }

  /// Pulls the proposed tiles out of [hand] and validates each meld.
  static _ResolveResult _resolveProposals(
    List<Tile> hand,
    List<MeldProposal> proposals,
    TileSemantics semantics,
  ) {
    final byId = <int, Tile>{for (final tile in hand) tile.id: tile};
    final used = <int>{};
    final melds = <_ResolvedMeld>[];
    var points = 0;

    for (final proposal in proposals) {
      if (proposal.tileIds.isEmpty) {
        return const _ResolveFailed(GameError.emptyProposal());
      }
      final tiles = <Tile>[];
      for (final id in proposal.tileIds) {
        if (!used.add(id)) {
          return _ResolveFailed(
            GameError.duplicateTileInProposal(tileId: id),
          );
        }
        final tile = byId[id];
        if (tile == null) {
          return _ResolveFailed(GameError.tileNotInHand(tileId: id));
        }
        tiles.add(tile);
      }
      final check = MeldRules.validate(
        kind: proposal.kind,
        tiles: tiles,
        semantics: semantics,
        isLayDown: true,
      );
      if (check is MeldRejected) {
        return _ResolveFailed(check.error);
      }
      final valid = check as MeldValid;
      melds.add(
        _ResolvedMeld(
          kind: proposal.kind,
          tiles: tiles,
          jokerAssignments: valid.jokerAssignments,
        ),
      );
      points += valid.points;
    }

    final remaining = <Tile>[
      for (final tile in hand)
        if (!used.contains(tile.id)) tile,
    ];
    return _ResolveOk(melds: melds, remainingHand: remaining, points: points);
  }
}

class _ResolvedMeld {
  const _ResolvedMeld({
    required this.kind,
    required this.tiles,
    required this.jokerAssignments,
  });

  final MeldKind kind;
  final List<Tile> tiles;
  final List<TileIdentity?> jokerAssignments;
}

sealed class _ResolveResult {
  const _ResolveResult();
}

class _ResolveOk extends _ResolveResult {
  const _ResolveOk({
    required this.melds,
    required this.remainingHand,
    required this.points,
  });

  final List<_ResolvedMeld> melds;
  final List<Tile> remainingHand;
  final int points;
}

class _ResolveFailed extends _ResolveResult {
  const _ResolveFailed(this.error);

  final GameError error;
}
