import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okey101/app/providers.dart';
import 'package:okey101/data/models/saved_game.dart';
import 'package:okey101/domain/ai/bot_brain.dart';
import 'package:okey101/domain/ai/bot_utils.dart';
import 'package:okey101/domain/ai/easy_bot.dart';
import 'package:okey101/domain/ai/hard_bot.dart';
import 'package:okey101/domain/ai/medium_bot.dart';
import 'package:okey101/domain/engine/dealer.dart';
import 'package:okey101/domain/engine/engine_result.dart';
import 'package:okey101/domain/engine/game_engine.dart';
import 'package:okey101/domain/engine/match_runner.dart';
import 'package:okey101/domain/engine/player_view_factory.dart';
import 'package:okey101/domain/engine/random_source.dart';
import 'package:okey101/domain/engine/score_calculator.dart';
import 'package:okey101/domain/models/game_action.dart';
import 'package:okey101/domain/models/game_error.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/hand_result.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/player_view.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/meld_solver.dart';
import 'package:okey101/features/game/game_session.dart';

final gameControllerProvider =
    NotifierProvider<GameController, GameSession?>(GameController.new);

/// Drives one match: applies the human's actions, runs the bots on a timer, and
/// keeps the rack layout in step with the hand.
///
/// No game logic lives here. Every decision goes to [GameEngine] or the solver;
/// this class only sequences them and holds presentation state.
class GameController extends Notifier<GameSession?> {
  static const int minThinkMs = 700;
  static const int maxThinkMs = 1800;

  /// Between two actions inside the same bot turn, so a bot that opens and then
  /// works three tiles does not do it all in one frame.
  static const int intraTurnThinkMs = 260;

  late RandomSource _botRng;
  int _generation = 0;
  bool _disposed = false;

  @override
  GameSession? build() {
    // Reset, not just declare: NotifierProvider is not auto-dispose and
    // Riverpod keeps the Notifier instance across rebuilds, so a one-way latch
    // would leave the board permanently dead after a single invalidate.
    _disposed = false;
    ref.onDispose(() {
      _disposed = true;
      _generation++;
    });
    _botRng = RandomSource(1);
    return null;
  }

  // --- Lifecycle -----------------------------------------------------------

  /// Starts a fresh match. [seed] comes from the caller so the domain never
  /// reads the clock.
  void newMatch({
    required int seed,
    required RuleSet ruleSet,
    required List<String> names,
  }) {
    _generation++;
    _botRng = RandomSource(seed ^ MatchRunner.botSeedSalt);
    final game = Dealer.newMatch(
      ruleSet: ruleSet,
      seed: seed,
      names: names,
      humans: const [true, false, false, false],
    );
    state = GameSession(
      state: game,
      rackSlots: RackLayout.fromTiles(game.players[0].hand),
      turnStartState: game,
      turnStartRack: RackLayout.fromTiles(game.players[0].hand),
    );
    _persist();
    _maybeRunBots();
  }

  /// Restores a saved match exactly where it was left.
  void restore(SavedGame saved) {
    _generation++;
    _botRng = RandomSource(
      saved.state.randomState ^ MatchRunner.botSeedSalt,
    );
    final session = GameSession(
      state: saved.state,
      rackSlots: RackLayout.reconcile(
        saved.rackSlots,
        saved.state.players[0].hand,
      ),
      turnStartState: saved.state,
      turnStartRack: saved.rackSlots,
    );
    state = session;
    _maybeRunBots();
  }

  void leave() {
    _generation++;
    _persist();
    state = null;
  }

  // --- Human actions -------------------------------------------------------

  void drawFromPile() => _applyHuman(const GameAction.drawFromPile());

  void drawFromDiscard() => _applyHuman(const GameAction.drawFromDiscard());

  void discard(int tileId) => _applyHuman(GameAction.discard(tileId: tileId));

  void addToMeld(int meldId, int tileId, {bool atStart = false}) => _applyHuman(
        GameAction.addToMeld(
          meldId: meldId,
          tileId: tileId,
          atStart: atStart,
        ),
      );

  void replaceJoker(int meldId, int index, int tileId) => _applyHuman(
        GameAction.replaceJoker(meldId: meldId, index: index, tileId: tileId),
      );

  /// Lays the staged melds. With nothing staged, the solver's best lay-down is
  /// used, which is what the HUD has been showing the player all along.
  void openWithPending() {
    final session = state;
    if (session == null) return;
    if (session.pendingMelds.isNotEmpty) {
      _applyHuman(GameAction.open(melds: session.pendingMelds));
      return;
    }
    final solution = _bestOpening(session);
    if (solution == null) {
      // Nothing stageable and the solver cannot reach the threshold. Say why
      // rather than letting the button do nothing.
      final view = _humanView(session);
      state = session.copyWith(
        lastError: GameError.openThresholdNotMet(
          requiredPoints: view.ruleSet.openThresholdFor(view.openedCount),
          actualPoints: BotUtils.solverFor(view).maximizePoints(view.hand).points,
        ),
      );
      return;
    }
    _applyHuman(GameAction.open(melds: solution.toProposals()));
  }

  /// "Islemek": puts the selected tiles onto melds already on the table.
  ///
  /// Each tile is placed on the first meld that legally takes it, anyone's
  /// included. Tiles that fit nowhere are simply left in hand; only a selection
  /// where NOTHING fits reports an error, because that is the case where the
  /// player pressed the button expecting something to happen.
  void workSelection() {
    final session = state;
    if (session == null || session.selection.isEmpty) return;
    if (!session.human.hasOpened || session.human.openedWithPairs) {
      state = session.copyWith(
        lastError: session.human.openedWithPairs
            ? const GameError.pairsPathViolation()
            : const GameError.cannotAddBeforeOpening(),
      );
      return;
    }

    // Repeat until a pass places nothing. One pass would be order dependent:
    // with 5-6-7 on the table, selecting 9 before 8 would place 8 and strand 9,
    // because 9 only becomes legal once 8 is down.
    var applied = 0;
    final pending = session.selection.toList();
    var progress = true;
    while (progress && pending.isNotEmpty) {
      progress = false;
      for (final tileId in List<int>.of(pending)) {
        final current = state;
        if (current == null) break;
        final option = _bestAddition(current, tileId);
        if (option == null) continue;
        _applyHuman(
          GameAction.addToMeld(
            meldId: option.meldId,
            tileId: option.tileId,
            atStart: option.atStart,
          ),
        );
        pending.remove(tileId);
        applied++;
        progress = true;
      }
    }

    if (applied == 0) {
      final current = state;
      if (current != null) {
        state = current.copyWith(
          lastError: GameError.tileDoesNotExtendMeld(
            meldId: -1,
            tileId: session.selection.first,
          ),
        );
      }
      return;
    }
    clearSelection();
  }

  /// Where a tile should go when several melds would legally take it.
  ///
  /// [BotUtils.tableAdditions] returns options in table order with no
  /// preference, so picking the first would drop the okey onto whichever meld
  /// happened to be laid earliest - usually an opponent's, and only
  /// recoverable through a joker swap. Ordinary tiles go first, and this
  /// player's own melds before anybody else's.
  ({int meldId, int tileId, bool atStart})? _bestAddition(
    GameSession session,
    int tileId,
  ) {
    final view = _humanView(session);
    final semantics = BotUtils.semanticsOf(view);
    final tile = view.hand.where((t) => t.id == tileId).firstOrNull;
    if (tile == null) return null;
    final wild = semantics.isWild(tile);

    final options = BotUtils.tableAdditions(view)
        .where((option) => option.tileId == tileId)
        .toList();
    if (options.isEmpty) return null;
    if (wild) {
      // A wild is worth far more in hand than worked onto a table meld, but the
      // player asked for it; at least keep it on their own meld if possible.
      options.sort((a, b) {
        final aMine = _ownsMeld(view, a.meldId) ? 0 : 1;
        final bMine = _ownsMeld(view, b.meldId) ? 0 : 1;
        return aMine.compareTo(bMine);
      });
    } else {
      options.sort((a, b) {
        final aMine = _ownsMeld(view, a.meldId) ? 0 : 1;
        final bMine = _ownsMeld(view, b.meldId) ? 0 : 1;
        return aMine.compareTo(bMine);
      });
    }
    return options.first;
  }

  bool _ownsMeld(PlayerView view, int meldId) {
    for (final meld in view.table) {
      if (meld.id == meldId) return meld.ownerSeat == view.seat;
    }
    return false;
  }

  /// Works one specific tile onto one specific meld, used when the player taps
  /// a meld on the board rather than pressing the button.
  void workTileOntoMeld(int meldId, int tileId) {
    final session = state;
    if (session == null) return;
    final option = _bestAddition(session, tileId);
    if (option == null || option.meldId != meldId) {
      // Find the option for the meld they actually tapped.
      final exact = BotUtils.tableAdditions(_humanView(session))
          .where((o) => o.tileId == tileId && o.meldId == meldId)
          .toList();
      if (exact.isEmpty) {
        state = session.copyWith(
          lastError:
              GameError.tileDoesNotExtendMeld(meldId: meldId, tileId: tileId),
        );
        return;
      }
      _applyHuman(
        GameAction.addToMeld(
          meldId: meldId,
          tileId: tileId,
          atStart: exact.first.atStart,
        ),
      );
      clearSelection();
      return;
    }
    _applyHuman(
      GameAction.addToMeld(
        meldId: meldId,
        tileId: tileId,
        atStart: option.atStart,
      ),
    );
    clearSelection();
  }

  /// Melds the current selection could legally be worked onto, so the board can
  /// point them out before the player commits.
  Set<int> addableMeldIds() {
    final session = state;
    if (session == null || session.selection.isEmpty) return const <int>{};
    if (!session.isHumanTurn) return const <int>{};
    // Before drawing, nothing may be worked onto the table; highlighting melds
    // then would invite a tap the engine is going to refuse.
    if (session.state.phase != TurnPhase.awaitingDiscard) return const <int>{};
    if (!session.human.hasOpened || session.human.openedWithPairs) {
      return const <int>{};
    }
    return <int>{
      for (final option in BotUtils.tableAdditions(_humanView(session)))
        if (session.selection.contains(option.tileId)) option.meldId,
    };
  }

  /// Lays the current selection as one more meld after opening.
  void laySelectionAsMeld() {
    final session = state;
    if (session == null || session.selection.isEmpty) return;
    final proposal = _proposalFromSelection(session);
    if (proposal == null) return;
    _applyHuman(GameAction.layMeld(meld: proposal));
  }

  /// Lays the pairs the solver finds, opening the pairs path or finishing it.
  void layPairs() {
    final session = state;
    if (session == null) return;
    final view = _humanView(session);
    final pairs = BotUtils.pairsOpeningFor(view) ??
        BotUtils.solverFor(view).bestPairs(view.hand);
    if (pairs.isEmpty) return;
    _applyHuman(
      GameAction.layPairs(pairs: pairs.map((p) => p.toProposal()).toList()),
    );
  }

  void startNextHand() {
    final session = state;
    if (session == null) return;
    final result = GameEngine.apply(
      session.state,
      const GameAction.startNextHand(),
    );
    switch (result) {
      case EngineErr(:final error):
        state = session.copyWith(lastError: error);
      case EngineOk(state: final next):
        state = GameSession(
          state: next,
          rackSlots: RackLayout.fromTiles(next.players[session.humanSeat].hand),
          turnStartState: next,
          turnStartRack:
              RackLayout.fromTiles(next.players[session.humanSeat].hand),
          humanSeat: session.humanSeat,
        );
        _persist();
        _maybeRunBots();
    }
  }

  /// Rolls the turn back to how it started, undoing table placements made this
  /// turn. Only ever available before the discard commits them.
  void undoTurn() {
    final session = state;
    if (session == null || session.turnStartState == null) return;
    state = GameSession(
      state: session.turnStartState!,
      rackSlots: session.turnStartRack ??
          RackLayout.fromTiles(
            session.turnStartState!.players[session.humanSeat].hand,
          ),
      turnStartState: session.turnStartState,
      turnStartRack: session.turnStartRack,
      humanSeat: session.humanSeat,
    );
    _persist();
  }

  // --- Staged lay-down -----------------------------------------------------

  /// Stages the current selection as one meld of an opening lay-down.
  void stageSelection() {
    final session = state;
    if (session == null || session.selection.isEmpty) return;
    final proposal = _proposalFromSelection(session);
    if (proposal == null) return;
    state = session.copyWith(
      pendingMelds: [...session.pendingMelds, proposal],
      selection: const <int>{},
      clearLastError: true,
    );
  }

  void clearPending() {
    final session = state;
    if (session == null) return;
    state = session.copyWith(
      pendingMelds: const <MeldProposal>[],
      clearLastError: true,
    );
  }

  // --- Selection and rack --------------------------------------------------

  void toggleSelection(int tileId) {
    final session = state;
    if (session == null) return;
    final next = Set<int>.of(session.selection);
    if (!next.remove(tileId)) next.add(tileId);
    state = session.copyWith(selection: next, clearLastError: true);
  }

  void clearSelection() {
    final session = state;
    if (session == null) return;
    state = session.copyWith(selection: const <int>{});
  }

  void moveTile(int fromSlot, int toSlot) {
    final session = state;
    if (session == null) return;
    state = session.copyWith(
      rackSlots: RackLayout.move(session.rackSlots, fromSlot, toSlot),
    );
    _persist();
  }

  /// Replaces the whole arrangement. The rack widget reorders on a working copy
  /// while the finger is down and commits once, on release.
  void setRackSlots(List<int?> slots) {
    final session = state;
    if (session == null) return;
    state = session.copyWith(
      rackSlots: RackLayout.reconcile(slots, session.human.hand),
    );
    _persist();
  }

  void sortForRuns() {
    final session = state;
    if (session == null) return;
    state = session.copyWith(
      rackSlots: RackLayout.sortForRuns(
        session.human.hand,
        session.state.indicatorIdentity,
      ),
    );
    _persist();
  }

  void sortForSets() {
    final session = state;
    if (session == null) return;
    state = session.copyWith(
      rackSlots: RackLayout.sortForSets(
        session.human.hand,
        session.state.indicatorIdentity,
      ),
    );
    _persist();
  }

  void dismissError() {
    final session = state;
    if (session == null) return;
    state = session.copyWith(clearLastError: true);
  }

  // --- Read models for the UI ---------------------------------------------

  PlayerView humanView() {
    final session = state;
    if (session == null) {
      throw StateError('humanView called with no active game');
    }
    return _humanView(session);
  }

  /// Points the human would lay down with the best combination in hand, which
  /// is what the live HUD shows.
  int bestOpeningPoints() {
    final session = state;
    if (session == null) return 0;
    final view = _humanView(session);
    if (session.pendingMelds.isNotEmpty) {
      return _pendingPoints(session);
    }
    return BotUtils.solverFor(view).maximizePoints(view.hand).points;
  }

  int pendingPoints() {
    final session = state;
    if (session == null) return 0;
    return _pendingPoints(session);
  }

  int deadwood() {
    final session = state;
    if (session == null) return 0;
    final view = _humanView(session);
    return BotUtils.solverFor(view).minimizeDeadwood(view.hand).deadwood;
  }

  bool canFinishNow() {
    final session = state;
    if (session == null || !session.isHumanTurn) return false;
    if (session.state.phase != TurnPhase.awaitingDiscard) return false;
    final view = _humanView(session);
    return BotUtils.solverFor(view).canFinish(view.hand) != null;
  }

  // --- Internals -----------------------------------------------------------

  PlayerView _humanView(GameSession session) =>
      PlayerViewFactory.forSeat(session.state, session.humanSeat);

  int _pendingPoints(GameSession session) {
    final view = _humanView(session);
    final semantics = BotUtils.semanticsOf(view);
    final byId = <int, Tile>{for (final tile in view.hand) tile.id: tile};
    var total = 0;
    for (final proposal in session.pendingMelds) {
      final tiles = <Tile>[
        for (final id in proposal.tileIds)
          if (byId[id] != null) byId[id]!,
      ];
      if (tiles.length != proposal.tileIds.length) continue;
      for (var i = 0; i < tiles.length; i++) {
        final tile = tiles[i];
        if (semantics.isWild(tile)) {
          // A wild counts as whatever the ordered position demands; deriving it
          // exactly is the rules layer's job, so approximate with the
          // neighbouring tile for the HUD only.
          final neighbour = i > 0 ? tiles[i - 1] : tiles[tiles.length - 1];
          total += semantics.fixedIdentity(neighbour).number;
        } else {
          total += semantics.fixedIdentity(tile).number;
        }
      }
    }
    return total;
  }

  MeldSolution? _bestOpening(GameSession session) =>
      BotUtils.bestOpening(_humanView(session));

  /// Guesses whether the selected tiles are a run, a set or a pair. The engine
  /// still validates; this only picks which validation to ask for.
  MeldProposal? _proposalFromSelection(GameSession session) {
    final selected = <Tile>[
      for (final tile in session.orderedHand)
        if (session.selection.contains(tile.id)) tile,
    ];
    if (selected.isEmpty) return null;
    final view = _humanView(session);
    final semantics = BotUtils.semanticsOf(view);

    final numbers = <int>{
      for (final tile in selected)
        if (!semantics.isWild(tile)) semantics.fixedIdentity(tile).number,
    };
    if (selected.length == 2) {
      return MeldProposal(
        kind: MeldKind.pair,
        tileIds: selected.map((t) => t.id).toList(),
      );
    }
    final kind = numbers.length <= 1 ? MeldKind.set : MeldKind.run;
    final ordered = kind == MeldKind.run
        ? (List<Tile>.of(selected)
          ..sort((a, b) {
            if (semantics.isWild(a)) return 1;
            if (semantics.isWild(b)) return -1;
            return semantics
                .fixedIdentity(a)
                .number
                .compareTo(semantics.fixedIdentity(b).number);
          }))
        : selected;

    // A wild inside a run has to sit where the gap is, so put it back there.
    final tiles = kind == MeldKind.run
        ? _placeWildsInGaps(ordered, semantics.isWild, semantics.fixedIdentity)
        : ordered;

    return MeldProposal(
      kind: kind,
      tileIds: tiles.map((t) => t.id).toList(),
    );
  }

  /// Re-inserts wilds at the numeric gaps of an otherwise ascending run.
  static List<Tile> _placeWildsInGaps(
    List<Tile> ordered,
    bool Function(Tile) isWild,
    TileIdentity Function(Tile) identityOf,
  ) {
    final wilds = <Tile>[for (final t in ordered) if (isWild(t)) t];
    if (wilds.isEmpty) return ordered;
    final reals = <Tile>[for (final t in ordered) if (!isWild(t)) t];
    if (reals.isEmpty) return ordered;

    final out = <Tile>[reals.first];
    var wildIndex = 0;
    for (var i = 1; i < reals.length; i++) {
      final gap = identityOf(reals[i]).number - identityOf(reals[i - 1]).number;
      for (var g = 1; g < gap && wildIndex < wilds.length; g++) {
        out.add(wilds[wildIndex++]);
      }
      out.add(reals[i]);
    }
    // Anything spare extends the top of the run.
    while (wildIndex < wilds.length) {
      out.add(wilds[wildIndex++]);
    }
    return out;
  }

  void _applyHuman(GameAction action) {
    final session = state;
    if (session == null) return;
    if (session.state.currentSeat != session.humanSeat) return;

    final result = GameEngine.apply(session.state, action);
    switch (result) {
      case EngineErr(:final error):
        state = session.copyWith(lastError: error);
      case EngineOk(state: final next):
        final turnEnded = next.currentSeat != session.humanSeat ||
            next.phase == TurnPhase.awaitingDraw ||
            next.isHandOver;
        final rack = RackLayout.reconcile(
          session.rackSlots,
          next.players[session.humanSeat].hand,
        );
        // Selection survives the move, minus whatever the move consumed.
        // Rebuilding the session without it silently deselected everything on
        // every single action - which is why the discard button had to clear
        // the selection by hand, and why working several tiles onto the table
        // in a row felt like the rack was fighting you.
        final stillHeld = <int>{
          for (final tile in next.players[session.humanSeat].hand) tile.id,
        };
        state = GameSession(
          state: next,
          rackSlots: rack,
          selection: <int>{
            for (final id in session.selection)
              if (stillHeld.contains(id)) id,
          },
          pendingMelds: action is OpenWithMelds
              ? const <MeldProposal>[]
              : session.pendingMelds,
          turnStartState: turnEnded ? next : session.turnStartState,
          turnStartRack: turnEnded ? rack : session.turnStartRack,
          humanSeat: session.humanSeat,
        );
        _persist();
        _maybeRunBots();
    }
  }

  void _maybeRunBots() {
    final session = state;
    if (session == null) return;
    if (session.state.isHandOver) return;
    if (session.state.currentSeat == session.humanSeat) return;
    unawaited(_runBots(++_generation));
  }

  Future<void> _runBots(int generation) async {
    final settings = ref.read(settingsProvider);
    final brains = _brainsFor(settings.difficulty);

    state = state?.copyWith(botThinking: true);
    // botThinking gates isHumanTurn, which gates the draw pile, the rack and
    // every button. A single exit that forgets to clear it deadlocks the whole
    // screen, so no exit is allowed to forget: finally does it.
    try {
      await _botLoop(generation, brains, settings.fastMode);
    } finally {
      // Only the loop that still owns the turn may clear the flag: a stale
      // generation clearing it would flicker the "thinking" indicator off
      // under the loop that replaced it.
      if (!_disposed && generation == _generation) {
        state = state?.copyWith(botThinking: false);
      }
    }
  }

  Future<void> _botLoop(
    int generation,
    List<BotBrain> brains,
    bool fastMode,
  ) async {
    while (true) {
      if (_disposed || generation != _generation) return;
      final session = state;
      if (session == null) return;
      final game = session.state;
      if (game.isHandOver || game.currentSeat == session.humanSeat) {
        return;
      }

      final firstOfTurn = game.phase == TurnPhase.awaitingDraw;
      final delayMs = fastMode
          ? 0
          : firstOfTurn
              ? minThinkMs + _botRng.nextInt(maxThinkMs - minThinkMs)
              : intraTurnThinkMs;
      if (delayMs > 0) {
        await Future<void>.delayed(Duration(milliseconds: delayMs));
      }
      if (_disposed || generation != _generation) return;

      final current = state;
      if (current == null) return;
      final seat = current.state.currentSeat;
      final view = PlayerViewFactory.forSeat(current.state, seat);
      final action = brains[seat].decide(view, _botRng);
      final result = GameEngine.apply(current.state, action);

      final next = switch (result) {
        EngineOk(state: final value) => value,
        // A bot should never produce an illegal action; if it somehow does, a
        // guaranteed-legal fallback keeps the game playable rather than
        // freezing the board.
        EngineErr() => _fallback(current.state),
      };
      // Nothing legal left even for the fallback. Returning the state unchanged
      // would put this loop in a permanent spin with botThinking held down -
      // every control on the board disabled, for good. Stopping hands the
      // player a board they can at least leave.
      if (next == null) return;
      state = current.copyWith(
        state: next,
        rackSlots: RackLayout.reconcile(
          current.rackSlots,
          next.players[current.humanSeat].hand,
        ),
        turnStartState: next.currentSeat == current.humanSeat
            ? next
            : current.turnStartState,
        turnStartRack: next.currentSeat == current.humanSeat
            ? RackLayout.reconcile(
                current.rackSlots,
                next.players[current.humanSeat].hand,
              )
            : current.turnStartRack,
      );
      _persist();
    }
  }

  /// A guaranteed-legal move for a bot that produced an illegal one, or null
  /// when even that is refused.
  GameState? _fallback(GameState game) {
    final action = game.phase == TurnPhase.awaitingDraw
        ? const GameAction.drawFromPile()
        : GameAction.discard(
            tileId: game.currentPlayer.hand
                .firstWhere(
                  (t) => t.id != game.takenFromDiscardTileId,
                  orElse: () => game.currentPlayer.hand.first,
                )
                .id,
          );
    final result = GameEngine.apply(game, action);
    return result is EngineOk ? result.state : null;
  }

  List<BotBrain> _brainsFor(BotDifficulty difficulty) {
    final brain = switch (difficulty) {
      BotDifficulty.easy => const EasyBot(),
      BotDifficulty.medium => const MediumBot() as BotBrain,
      BotDifficulty.hard => const HardBot(),
    };
    return <BotBrain>[brain, brain, brain, brain];
  }

  void _persist() {
    final session = state;
    if (session == null) return;
    final store = ref.read(localStoreProvider);
    if (session.state.isMatchOver) {
      _recordMatch(session);
      unawaited(store.clearSavedGame());
      return;
    }
    unawaited(
      store.saveGame(
        SavedGame(
          state: session.state,
          rackSlots: session.rackSlots,
          savedAtMs: ref.read(nowProvider)(),
        ),
      ),
    );
  }

  void _recordMatch(GameSession session) {
    final totals = session.state.players.map((p) => p.score).toList();
    ref.read(historyProvider.notifier).add(
          MatchRecord(
            id: 'm${session.state.seed}-${session.state.handNumber}',
            timestampMs: ref.read(nowProvider)(),
            playerNames: session.state.players.map((p) => p.name).toList(),
            finalScores: totals,
            winnerSeat: ScoreCalculator.matchWinner(totals),
            handsPlayed: session.state.history.length,
            preset: session.state.ruleSet.preset,
          ),
        );
  }
}
