import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okey101/app/providers.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/core/error_messages.dart';
import 'package:okey101/core/tile_glyphs.dart';
import 'package:okey101/core/wake_lock.dart';
import 'package:okey101/data/models/app_settings.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/features/game/game_controller.dart';
import 'package:okey101/features/game/game_session.dart';
import 'package:okey101/features/game/widgets/hand_over_sheet.dart';
import 'package:okey101/features/game/widgets/meld_board.dart';
import 'package:okey101/features/game/widgets/rack_widget.dart';
import 'package:okey101/features/game/widgets/seat_chip.dart';
import 'package:okey101/features/game/widgets/tile_widget.dart';
import 'package:okey101/l10n/generated/app_localizations.dart';

/// The okey table.
///
/// Contains no game logic: every decision is asked of the controller, which
/// asks the engine. Widgets here only lay things out and report taps.
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  int? _focusedMeldId;

  /// The player's own discard pile, so a tile dragged off the rack can be
  /// checked against where it was actually dropped.
  final GlobalKey _discardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // A long hand would otherwise let the phone screen sleep. Silently a no-op
    // where the API does not exist, which is most of WebKit.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ref.read(settingsProvider).keepScreenAwake) {
        unawaited(WakeLock.enable());
      }
    });
  }

  @override
  void dispose() {
    unawaited(WakeLock.disable());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(gameControllerProvider);

    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    ref.listen(gameControllerProvider, (previous, next) {
      final error = next?.lastError;
      if (error == null || error == previous?.lastError) return;
      ref.read(feedbackProvider).error();
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(messageForError(l10n, error)),
            duration: const Duration(seconds: 3),
          ),
        );
      ref.read(gameControllerProvider.notifier).dismissError();
    });

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Landscape on a phone leaves very little vertical room, so the
            // opponent strip drops its discard tile there. On a tablet or a
            // desktop window the table is capped so the rack never stretches to
            // an unusable width.
            final compactOpponents = constraints.maxHeight < 560;
            final landscape = constraints.maxWidth > constraints.maxHeight;
            return Center(
              child: ConstrainedBox(
                // Landscape spends its width on the table, so the cap is looser
                // there; portrait keeps the narrower, more readable column.
                constraints: BoxConstraints(maxWidth: landscape ? 1100 : 760),
                child: _Board(
                  session: session,
                  compactOpponents: compactOpponents,
                  focusedMeldId: _focusedMeldId,
                  onSort: _showSortMenu,
                  onTapMeld: _handleMeldTap,
                  onTapMeldTile: _handleMeldTileTap,
                  onCommitLayout: _commitLayout,
                  onDragOut: _handleDragOut,
                  discardKey: _discardKey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _commitLayout(GameSession session, List<int?> slots) {
    ref.read(feedbackProvider).light();
    ref.read(gameControllerProvider.notifier).setRackSlots(slots);
  }

  /// A tile dragged off the rack and dropped on the discard pile is thrown.
  ///
  /// This is the gesture the game is played with, and taking it away left the
  /// discard button as the only way out - which is not where a hand goes. It
  /// only fires over the pile itself, generously padded, so the accidental
  /// throws that made it worth removing cannot come back.
  void _handleDragOut(GameSession session, int tileId, Offset globalPosition) {
    final box = _discardKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final origin = box.localToGlobal(Offset.zero);
    final target = Rect.fromLTWH(
      origin.dx,
      origin.dy,
      box.size.width,
      box.size.height,
    ).inflate(28);
    if (!target.contains(globalPosition)) return;
    ref.read(feedbackProvider).light();
    ref.read(gameControllerProvider.notifier)
      ..discard(tileId)
      ..clearSelection();
  }

  void _handleMeldTap(int meldId) {
    final session = ref.read(gameControllerProvider);
    if (session == null) return;
    // No turn check. Highlighting a meld is just looking at it, and working a
    // tile onto one goes through the controller, which refuses out of turn and
    // says so. Returning here did neither.
    if (session.selection.length == 1) {
      // "Islemek": work the selected tile onto this meld, at whichever end it
      // actually fits.
      ref
          .read(gameControllerProvider.notifier)
          .workTileOntoMeld(meldId, session.selection.single);
      return;
    }
    setState(() => _focusedMeldId = _focusedMeldId == meldId ? null : meldId);
  }

  /// A tap lands on one tile of a meld, never on the meld's background: every
  /// tile paints itself and absorbs the hit. So the tapped POSITION decides
  /// what the tap means - a wild standing on the table is a swap, anything else
  /// is working a tile onto that meld.
  void _handleMeldTileTap(int meldId, int index) {
    final session = ref.read(gameControllerProvider);
    if (session == null) return;
    if (session.selection.length != 1) {
      _handleMeldTap(meldId);
      return;
    }
    final meld = session.state.table.where((m) => m.id == meldId).firstOrNull;
    final tappedIsWild =
        meld != null &&
        index >= 0 &&
        index < meld.jokerAssignments.length &&
        meld.jokerAssignments[index] != null;
    if (!tappedIsWild) {
      _handleMeldTap(meldId);
      return;
    }
    ref
        .read(gameControllerProvider.notifier)
        .replaceJoker(meldId, index, session.selection.single);
  }

  Future<void> _showSortMenu() async {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(gameControllerProvider.notifier);
    final choice = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: OkeyPalette.felt,
      // A landscape phone is 390 tall and the default sheet is capped at 9/16
      // of that, which is not enough for two list tiles plus the safe area.
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.linear_scale),
              title: Text(l10n.gameSortRuns),
              onTap: () => Navigator.of(context).pop(0),
            ),
            ListTile(
              leading: const Icon(Icons.grid_view),
              title: Text(l10n.gameSortSets),
              onTap: () => Navigator.of(context).pop(1),
            ),
          ],
        ),
      ),
    );
    if (choice == 0) controller.sortForRuns();
    if (choice == 1) controller.sortForSets();
  }
}

/// Where a dragged tile is being pulled from.
enum _DrawSource { pile, discard }

/// What the turn indicator should read.
///
/// "Your turn" alone is a trap on the hand you deal first: that seat starts
/// with 22 tiles and the game opens in awaitingDiscard, so the deck is
/// legitimately dead and every tap on it does nothing. It happens on two or
/// three hands of every match, and nothing on screen said why.
String turnLine(AppLocalizations l10n, GameSession session) {
  if (!session.isHumanTurn) {
    return l10n.gameThinking(session.state.currentPlayer.name);
  }
  return session.state.phase == TurnPhase.awaitingDiscard
      ? l10n.gameYourTurnDiscard
      : l10n.gameYourTurn;
}

class _Board extends ConsumerWidget {
  const _Board({
    required this.session,
    required this.compactOpponents,
    required this.focusedMeldId,
    required this.onSort,
    required this.onTapMeld,
    required this.onTapMeldTile,
    required this.onCommitLayout,
    required this.onDragOut,
    required this.discardKey,
  });

  final GameSession session;
  final bool compactOpponents;
  final int? focusedMeldId;
  final VoidCallback onSort;
  final ValueChanged<int> onTapMeld;
  final void Function(int meldId, int index) onTapMeldTile;
  final void Function(GameSession session, List<int?> slots) onCommitLayout;
  final void Function(GameSession session, int tileId, Offset globalPosition)
  onDragOut;
  final GlobalKey discardKey;

  /// Width of the rails flanking the table in the landscape board.
  ///
  /// A rail now carries one thing: that opponent, as a small circle with their
  /// name, and their discard pile at their own edge of the table - which is
  /// where the tiles sit on a real one. Everything the rails used to hold moved
  /// out, and the width they gave up went to the grid in the middle.
  static const double sideRailWidth = 70;
  static const double deckColumnWidth = 54;
  static const double pairsPanelWidth = 46;

  /// Share of the height the rack may take. The rest is the table.
  static const double rackHeightShare = 0.30;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final game = session.state;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Landscape is the intended shape of the game; portrait is the
        // fallback for a narrow desktop window, since handsets are rotated into
        // landscape by ForceLandscape before they ever get here.
        final landscape = constraints.maxWidth > constraints.maxHeight;
        final rack = _rack(
          context,
          ref,
          maxHeight: constraints.maxHeight * rackHeightShare,
        );

        return Stack(
          children: [
            if (landscape)
              _landscapeBoard(settings, controller, rack)
            else
              _portraitBoard(settings, controller, rack),
            if (game.isHandOver)
              HandOverSheet(
                session: session,
                onNextHand: controller.startNextHand,
                onLeave: () {
                  controller.leave();
                  Navigator.of(context).pop();
                },
              ),
          ],
        );
      },
    );
  }

  /// Wide and short, seated the way a real okey table is: one opponent at each
  /// edge with their discards in front of them, the gridded board in the
  /// middle, and the player's own rack across the bottom with the actions
  /// immediately above it, within a thumb's reach of the tiles they act on.
  Widget _landscapeBoard(
    AppSettings settings,
    GameController controller,
    Widget rack,
  ) {
    final leftSeat = seatToLeftOf(session.humanSeat);
    final acrossSeat = (session.humanSeat + 2) % kSeatCount;
    final rightSeat = (session.humanSeat + 1) % kSeatCount;

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: sideRailWidth,
                child: _SeatRail(
                  session: session,
                  seat: leftSeat,
                  // The seat across throws to the seat on the left, so its pile
                  // sits under that circle; the left seat throws to the player,
                  // so its pile sits below that again - nearest the rack, which
                  // is the only pile anyone may take from.
                  piles: [acrossSeat, leftSeat],
                  drawableSeat: leftSeat,
                  onDraw: controller.drawFromDiscard,
                  colorblind: settings.colorblind,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    _TopStrip(
                      session: session,
                      seat: acrossSeat,
                      pileSeat: rightSeat,
                      colorblind: settings.colorblind,
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _TableArea(
                              session: session,
                              colorblind: settings.colorblind,
                              focusedMeldId: focusedMeldId,
                              onTapMeld: onTapMeld,
                              onTapMeldTile: onTapMeldTile,
                            ),
                          ),
                          // Draw pile and indicator stand in a column rather
                          // than a strip: vertical space is what the grid board
                          // needs most.
                          SizedBox(
                            width: deckColumnWidth,
                            child: _DeckColumn(
                              session: session,
                              colorblind: settings.colorblind,
                              onDrawPile: controller.drawFromPile,
                            ),
                          ),
                          SizedBox(
                            width: pairsPanelWidth,
                            child: _PairsPanel(
                              session: session,
                              colorblind: settings.colorblind,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: sideRailWidth,
                child: _SeatRail(
                  session: session,
                  seat: rightSeat,
                  // The player throws to the seat on their right, so their own
                  // pile lives under that circle - which is also where a tile
                  // dragged off the rack has to be dropped to be thrown.
                  piles: [session.humanSeat],
                  discardKey: discardKey,
                  colorblind: settings.colorblind,
                ),
              ),
            ],
          ),
        ),
        _ActionBar(session: session, onSort: onSort, dense: true),
        rack,
      ],
    );
  }

  Widget _portraitBoard(
    AppSettings settings,
    GameController controller,
    Widget rack,
  ) {
    return Column(
      children: [
        _Header(session: session),
        _OpponentRow(session: session, compact: compactOpponents),
        _CentreStrip(
          session: session,
          colorblind: settings.colorblind,
          onDrawPile: controller.drawFromPile,
          onDrawDiscard: controller.drawFromDiscard,
          discardKey: discardKey,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _TableArea(
                  session: session,
                  colorblind: settings.colorblind,
                  focusedMeldId: focusedMeldId,
                  onTapMeld: onTapMeld,
                  onTapMeldTile: onTapMeldTile,
                ),
              ),
              // Pairs live on their own panel here too. Without it a pairs
              // player's five to eleven pairs would be laid and then shown
              // nowhere, because the main grid deliberately skips them.
              if (session.state.table.any((m) => m.kind == MeldKind.pair))
                SizedBox(
                  width: pairsPanelWidth,
                  child: _PairsPanel(
                    session: session,
                    colorblind: settings.colorblind,
                  ),
                ),
            ],
          ),
        ),
        _HudBar(session: session),
        _ActionBar(session: session, onSort: onSort),
        rack,
      ],
    );
  }

  Widget _rack(
    BuildContext context,
    WidgetRef ref, {
    required double maxHeight,
  }) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final game = session.state;

    // The rack is where a tile pulled off a pile is dropped, which is how the
    // game is actually played: take hold of the tile and bring it home.
    return DragTarget<_DrawSource>(
      onAcceptWithDetails: (details) {
        ref.read(feedbackProvider).light();
        switch (details.data) {
          case _DrawSource.pile:
            controller.drawFromPile();
          case _DrawSource.discard:
            controller.drawFromDiscard();
        }
      },
      builder: (context, candidate, rejected) => AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.fromLTRB(6, 0, 6, 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: candidate.isEmpty ? Colors.transparent : OkeyPalette.brass,
            width: 2,
          ),
        ),
        child: RackWidget(
          slots: session.rackSlots,
          tilesById: {for (final tile in session.human.hand) tile.id: tile},
          selection: session.selection,
          okey: game.okey,
          indicator: game.indicatorIdentity,
          colorblind: settings.colorblind,
          glyphFor: (color) => colorGlyph(l10n, color),
          animate: settings.animations,
          maxHeight: maxHeight,
          onLayoutChanged: (slots) => onCommitLayout(session, slots),
          onTapTile: controller.toggleSelection,
          onDragOut: (tileId, position) => onDragOut(session, tileId, position),
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.session});

  final GameSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final game = session.state;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
      child: Row(
        children: [
          _BackButton(session: session),
          Expanded(
            child: Column(
              children: [
                Text(
                  l10n.gameHandNumber(
                    game.handNumber,
                    game.ruleSet.handsPerMatch,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  turnLine(l10n, session),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: session.isHumanTurn
                        ? OkeyPalette.brass
                        : OkeyPalette.ivoryShade,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.scoreboard,
            icon: const Icon(Icons.list_alt),
            onPressed: () => showScoreboard(context, session),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends ConsumerWidget {
  const _BackButton({required this.session, this.dense = false});

  final GameSession session;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return IconButton(
      tooltip: l10n.commonBack,
      iconSize: dense ? 18 : 24,
      visualDensity: dense ? VisualDensity.compact : null,
      constraints: dense
          ? const BoxConstraints(minWidth: 32, minHeight: 32)
          : null,
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        ref.read(gameControllerProvider.notifier).leave();
        Navigator.of(context).pop();
      },
    );
  }
}

/// The running score for all four seats.
void showScoreboard(BuildContext context, GameSession session) {
  final l10n = AppLocalizations.of(context);
  unawaited(
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: OkeyPalette.felt,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.scoreboard,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                for (final player in session.state.players)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(player.name)),
                        Text(
                          '${player.score}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: player.score <= 0
                                ? OkeyPalette.success
                                : OkeyPalette.ivory,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// One opponent at their edge of the table: a small circle with their name,
/// and under it the pile they draw from.
///
/// A discard pile belongs BETWEEN two players on a real table - the one who
/// threw the tile and the one entitled to take it - and okey passes to the
/// right, so the pile under a player is always the previous seat's. That makes
/// the whole table one rotation: your throws land under the player on your
/// right, theirs land at the top, the top seat's land on your left, and the
/// pile you may take sits nearest you.
class _SeatRail extends StatelessWidget {
  const _SeatRail({
    required this.session,
    required this.seat,
    required this.piles,
    required this.colorblind,
    this.drawableSeat,
    this.onDraw,
    this.discardKey,
  });

  final GameSession session;

  /// Whose circle and name this rail shows.
  final int seat;

  /// Discard piles stacked under the circle, by seat, top to bottom.
  final List<int> piles;

  final bool colorblind;

  /// The one pile the rules let the player take from.
  final int? drawableSeat;
  final VoidCallback? onDraw;

  /// Marks the player's own pile, which is where a tile dragged off the rack
  /// has to land to be thrown.
  final GlobalKey? discardKey;

  static const double tileWidth = 26;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final game = session.state;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      // Centred while it fits, scrolled when it does not, rather than divided
      // by Expanded: a fixed share of the rail clips as soon as the text scale
      // goes above 1.0.
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SeatChip(
                player: game.players[seat],
                isCurrent: game.currentSeat == seat && !game.isHandOver,
                thinking: session.botThinking,
              ),
              for (final pileSeat in piles)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: _Pile(
                    session: session,
                    seat: pileSeat,
                    colorblind: colorblind,
                    width: tileWidth,
                    drawable: pileSeat == drawableSeat,
                    onDraw: pileSeat == drawableSeat ? onDraw : null,
                    slotKey: pileSeat == session.humanSeat ? discardKey : null,
                    label: pileSeat == drawableSeat
                        ? l10n.gameTakeDiscard
                        : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One discard pile, wherever it sits on the table.
class _Pile extends StatelessWidget {
  const _Pile({
    required this.session,
    required this.seat,
    required this.colorblind,
    required this.width,
    this.drawable = false,
    this.onDraw,
    this.slotKey,
    this.label,
    this.minTouchSize = 46,
  });

  final GameSession session;
  final int seat;
  final bool colorblind;
  final double width;
  final bool drawable;
  final VoidCallback? onDraw;
  final GlobalKey? slotKey;
  final String? label;
  final double minTouchSize;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final game = session.state;
    final top = game.players[seat].topDiscard;
    final canDraw = drawable &&
        session.isHumanTurn &&
        game.phase == TurnPhase.awaitingDraw &&
        top != null;

    final spot = DiscardSpot(
      key: slotKey,
      tile: top,
      okey: game.okey,
      width: width,
      enabled: canDraw,
      // Tappable whenever the pile is drawable at all, not only when it is
      // drawable right now: the engine refuses and says why, where a control
      // that does nothing just reads as a broken game.
      onTap: drawable ? onDraw : null,
      label: label,
      minTouchSize: minTouchSize,
      colorblindGlyph:
          colorblind && top?.color != null ? colorGlyph(l10n, top!.color!) : null,
    );

    if (!drawable) return spot;
    return _DraggableSource(
      source: _DrawSource.discard,
      feedback: top == null
          ? const SizedBox.shrink()
          : TileWidget(width: width, tile: top),
      child: spot,
    );
  }
}

/// Wraps a pile so a tile can be pulled off it with a finger.
///
/// Tapping still works - this only adds the gesture the game is actually
/// played with, which is to take hold of a tile and drag it to the rack.
class _DraggableSource extends StatelessWidget {
  const _DraggableSource({
    required this.source,
    required this.feedback,
    required this.child,
  });

  final _DrawSource source;
  final Widget feedback;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Draggable<_DrawSource>(
      data: source,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Transform.translate(
        // Centred under the finger rather than hanging off it, so the tile
        // being carried is the thing you are actually looking at.
        offset: const Offset(-18, -26),
        child: Material(
          color: Colors.transparent,
          child: Transform.scale(scale: 1.15, child: feedback),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: child),
      child: child,
    );
  }
}

/// The top edge: the seat across the table, with the pile it draws from under
/// it, and the way back tucked into the corner.
class _TopStrip extends ConsumerWidget {
  const _TopStrip({
    required this.session,
    required this.seat,
    required this.pileSeat,
    required this.colorblind,
  });

  final GameSession session;
  final int seat;

  /// Whose discards sit under that circle. Always the seat before it: a pile
  /// belongs between the player who threw the tile and the one who may take it.
  final int pileSeat;

  final bool colorblind;

  static const double height = 68;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final game = session.state;
    final controller = ref.read(gameControllerProvider.notifier);

    final String openLine;
    if (session.human.hasOpened) {
      openLine = l10n.gameHudOpened;
    } else {
      openLine = l10n.gameHudOpenTarget(
        game.ruleSet.openThresholdFor(game.openedCount),
        controller.bestOpeningPoints(),
      );
    }

    return SizedBox(
      height: height,
      child: Row(
        children: [
          _BackButton(session: session, dense: true),
          // Whose turn it is and how far off opening the rack is, in the corner
          // as plain text. It used to be a panel of its own across the bottom,
          // which is a row the table wanted more.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  turnLine(l10n, session),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: session.isHumanTurn
                        ? OkeyPalette.brass
                        : OkeyPalette.ivoryShade,
                  ),
                ),
                Text(
                  openLine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.2,
                    color: OkeyPalette.ivoryShade,
                  ),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            // Stacked, like the side rails: the pile a player draws from sits
            // in front of them, which from this side of the table means under
            // their circle.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SeatChip(
                  player: game.players[seat],
                  isCurrent: game.currentSeat == seat && !game.isHandOver,
                  thinking: session.botThinking,
                  axis: Axis.horizontal,
                ),
                _Pile(
                  session: session,
                  seat: pileSeat,
                  colorblind: colorblind,
                  width: 20,
                  minTouchSize: 28,
                ),
              ],
            ),
          ),
          // Balances the back button so the seat opposite sits centred.
          const SizedBox(width: 32),
        ],
      ),
    );
  }
}

/// The three opponents across the top, for the portrait fallback layout.
class _OpponentRow extends StatelessWidget {
  const _OpponentRow({required this.session, this.compact = false});

  final GameSession session;

  /// Drops the discard tile, for a viewport with no vertical room to spare.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final game = session.state;
    final seats = <int>[
      for (var step = 1; step < kSeatCount; step++)
        (session.humanSeat + step) % kSeatCount,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          for (final seat in seats)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SeatChip(
                    player: game.players[seat],
                    isCurrent: game.currentSeat == seat && !game.isHandOver,
                    thinking: session.botThinking,
                  ),
                  if (!compact)
                    DiscardSpot(
                      tile: game.players[seat].topDiscard,
                      okey: game.okey,
                      width: 26,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CentreStrip extends ConsumerWidget {
  const _CentreStrip({
    required this.session,
    required this.colorblind,
    required this.onDrawPile,
    required this.onDrawDiscard,
    required this.discardKey,
  });

  final GameSession session;
  final bool colorblind;
  final VoidCallback onDrawPile;
  final VoidCallback onDrawDiscard;
  final GlobalKey discardKey;

  static const double _tileWidth = 34;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final game = session.state;
    final leftSeat = seatToLeftOf(session.humanSeat);
    final leftTop = game.players[leftSeat].topDiscard;
    final ownTop = game.players[session.humanSeat].topDiscard;
    final canDraw = session.isHumanTurn && game.phase == TurnPhase.awaitingDraw;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x1AFBF5E6),
        borderRadius: BorderRadius.circular(12),
      ),
      // Four equal columns, so a long Turkish label can never push the strip
      // wider than the screen.
      child: Row(
        children: [
          Expanded(
            child: _Slot(
              label: l10n.gameTakeDiscard,
              enabled: canDraw && leftTop != null,
              onTap: canDraw && leftTop != null ? onDrawDiscard : null,
              child: leftTop == null
                  ? const _EmptySlot()
                  : _tile(l10n, leftTop, game.okey),
            ),
          ),
          Expanded(
            child: _Slot(
              label: l10n.gameRemainingTiles(game.drawPile.length),
              enabled: canDraw && game.drawPile.isNotEmpty,
              onTap: canDraw && game.drawPile.isNotEmpty ? onDrawPile : null,
              child: game.drawPile.isEmpty
                  ? const _EmptySlot()
                  : const TileWidget(width: _tileWidth, faceDown: true),
            ),
          ),
          Expanded(
            child: _Slot(
              label: l10n.gameIndicator,
              enabled: false,
              child: _tile(l10n, game.indicator, game.okey),
            ),
          ),
          Expanded(
            child: _Slot(
              key: discardKey,
              label: l10n.gameDiscardPile,
              enabled: false,
              child: ownTop == null
                  ? const _EmptySlot()
                  : _tile(l10n, ownTop, game.okey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(AppLocalizations l10n, Tile tile, TileIdentity okey) =>
      TileWidget(
        width: _tileWidth,
        tile: tile,
        kind: tile.isFalseJoker
            ? TileFaceKind.falseJoker
            : (tile.color == okey.color && tile.number == okey.number)
            ? TileFaceKind.okey
            : TileFaceKind.normal,
        colorblindGlyph: colorblind && tile.color != null
            ? colorGlyph(l10n, tile.color!)
            : null,
      );
}

class _Slot extends StatelessWidget {
  const _Slot({
    required this.label,
    required this.child,
    required this.enabled,
    super.key,
    this.compact = false,
    this.onTap,
  });

  final String label;
  final Widget child;
  final bool enabled;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        // Generous hit area: a touch target you cannot feel needs to be big.
        constraints: BoxConstraints(minHeight: compact ? 50 : 64),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled ? OkeyPalette.brass : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            const SizedBox(height: 1),
            Text(
              label,
              textAlign: TextAlign.center,
              // The deck column is narrow, so its labels wrap rather than being
              // cut off mid-word.
              maxLines: compact ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: compact ? 8 : 9,
                height: 1.1,
                color: enabled ? OkeyPalette.brass : OkeyPalette.ivoryShade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySlot extends StatelessWidget {
  const _EmptySlot({this.width = 34});

  final double width;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: TileWidget.heightFor(width),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: const Color(0x33FBF5E6)),
    ),
  );
}

class _TableArea extends ConsumerWidget {
  const _TableArea({
    required this.session,
    required this.colorblind,
    required this.focusedMeldId,
    required this.onTapMeld,
    required this.onTapMeldTile,
  });

  final GameSession session;
  final bool colorblind;
  final int? focusedMeldId;
  final ValueChanged<int> onTapMeld;
  final void Function(int meldId, int index) onTapMeldTile;

  /// Each seat gets a colour so a meld can say who laid it in the two pixels a
  /// grid cell can spare.
  static Color ownerColor(int seat) => switch (seat % 4) {
    0 => OkeyPalette.brass,
    1 => OkeyPalette.tileBlue,
    2 => OkeyPalette.tileRed,
    _ => OkeyPalette.success,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final game = session.state;
    final addable = ref.read(gameControllerProvider.notifier).addableMeldIds();

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
      child: MeldBoard(
        melds: game.table,
        okey: game.okey,
        indicatorIdentity: game.indicatorIdentity,
        ownerColorOf: ownerColor,
        colorblind: colorblind,
        glyphFor: (color) => colorGlyph(l10n, color),
        focusedMeldId: focusedMeldId,
        addableMeldIds: addable,
        onTapMeld: onTapMeld,
        onTapMeldTile: onTapMeldTile,
        emptyHint: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            l10n.gameSelectTilesHint,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0x88FBF5E6), fontSize: 11),
          ),
        ),
      ),
    );
  }
}

/// The middle of the table: the face-down draw pile with the indicator under
/// it, which is where the indicator sits on a real table.
///
/// The discard piles are not here. Each one lives at its own edge, under the
/// player entitled to take it.
class _DeckColumn extends StatelessWidget {
  const _DeckColumn({
    required this.session,
    required this.colorblind,
    required this.onDrawPile,
  });

  final GameSession session;
  final bool colorblind;
  final VoidCallback onDrawPile;

  static const double tileWidth = 30;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final game = session.state;
    final canDraw = session.isHumanTurn &&
        game.phase == TurnPhase.awaitingDraw &&
        game.drawPile.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // The deck must be hittable on the first try every single turn, so it
          // is never inside anything that can scroll. It used to sit in a
          // scroll view with two other slots: on any landscape phone shorter
          // than 390 logical pixels the column overflowed and the deck was
          // clipped to a fraction of its height, with no scrollbar to explain
          // why tapping it did nothing.
          _DraggableSource(
            source: _DrawSource.pile,
            feedback: const TileWidget(width: tileWidth, faceDown: true),
            child: _DrawPile(
              count: game.drawPile.length,
              width: tileWidth,
              enabled: canDraw,
              onTap: onDrawPile,
              label: l10n.gameRemainingTiles(game.drawPile.length),
            ),
          ),
          // The indicator is a reading, so it is the one that gives way when
          // the rail is short.
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _Slot(
                  label: l10n.gameIndicator,
                  enabled: false,
                  compact: true,
                  child: TileWidget(
                    width: tileWidth,
                    tile: game.indicator,
                    kind: game.indicator.isFalseJoker
                        ? TileFaceKind.falseJoker
                        : TileFaceKind.normal,
                    colorblindGlyph: colorblind && game.indicator.color != null
                        ? colorGlyph(l10n, game.indicator.color!)
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawPile extends StatelessWidget {
  const _DrawPile({
    required this.count,
    required this.width,
    required this.enabled,
    required this.label,
    this.onTap,
  });

  final int count;
  final double width;
  final bool enabled;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 72),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: enabled
              ? OkeyPalette.brass.withValues(alpha: 0.16)
              : const Color(0x14FBF5E6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled ? OkeyPalette.brass : const Color(0x22FBF5E6),
            width: enabled ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (count == 0)
              _EmptySlot(width: width)
            else
              // Two offset backs, so the deck reads as a stack of tiles at a
              // glance and not as one more single tile.
              SizedBox(
                width: width + 3,
                height: TileWidget.heightFor(width) + 3,
                child: Stack(
                  children: [
                    Positioned(
                      left: 3,
                      top: 3,
                      child: TileWidget(width: width, faceDown: true),
                    ),
                    TileWidget(width: width, faceDown: true),
                  ],
                ),
              ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 8,
                height: 1.1,
                fontWeight: enabled ? FontWeight.w700 : FontWeight.normal,
                color: enabled ? OkeyPalette.brass : OkeyPalette.ivoryShade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The pairs panel, kept apart from the main grid.
class _PairsPanel extends StatelessWidget {
  const _PairsPanel({required this.session, required this.colorblind});

  final GameSession session;
  final bool colorblind;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final game = session.state;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0x14FBF5E6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: PairsBoard(
        melds: game.table,
        okey: game.okey,
        ownerColorOf: _TableArea.ownerColor,
        colorblind: colorblind,
        glyphFor: (color) => colorGlyph(l10n, color),
        label: l10n.gamePairsShort,
      ),
    );
  }
}

class _HudBar extends ConsumerWidget {
  const _HudBar({required this.session});

  final GameSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(gameControllerProvider.notifier);
    final game = session.state;

    final String line;
    if (session.human.hasOpened) {
      line = l10n.gameHudOpened;
    } else {
      final target = game.ruleSet.openThresholdFor(game.openedCount);
      line = l10n.gameHudOpenTarget(target, controller.bestOpeningPoints());
    }
    final canFinish = controller.canFinishNow();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(8, 2, 8, 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x1AFBF5E6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            line,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Flexible(
                child: Text(
                  l10n.gameHudDeadwood(controller.deadwood()),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: OkeyPalette.ivoryShade,
                  ),
                ),
              ),
              const Spacer(),
              if (canFinish)
                Text(
                  l10n.gameHudCanFinish,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: OkeyPalette.success,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends ConsumerWidget {
  const _ActionBar({
    required this.session,
    required this.onSort,
    this.dense = false,
  });

  final GameSession session;
  final VoidCallback onSort;

  /// Landscape shows the same row, shorter. The actions sit directly above the
  /// rack in both shapes: they act on the tiles in it, so they belong beside
  /// them and not off in a rail on the far side of the table.
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(gameControllerProvider.notifier);
    final game = session.state;
    final canAct =
        session.isHumanTurn && game.phase == TurnPhase.awaitingDiscard;
    final selectionCount = session.selection.length;

    final open = _Action(
      icon: Icons.lock_open,
      label: session.pendingMelds.isEmpty
          ? l10n.gameOpenAction
          : '${l10n.gameOpenAction} (${controller.pendingPoints()})',
      primary: true,
      dense: dense,
      onPressed: canAct ? controller.openWithPending : null,
    );
    final discard = _Action(
      icon: Icons.south_east,
      label: l10n.gameDiscardPile,
      primary: true,
      dense: dense,
      onPressed: canAct && selectionCount == 1
          ? () {
              ref.read(feedbackProvider).light();
              controller
                ..discard(session.selection.single)
                ..clearSelection();
            }
          : null,
    );
    final sort = _Action(
      icon: Icons.sort,
      label: l10n.gameSort,
      dense: dense,
      // Sorting only rearranges the rack, so it is available whoever's turn it
      // is - tidying the tiles while the bots play is most of what a player
      // does with the waiting.
      onPressed: onSort,
    );
    final undo = _Action(
      icon: Icons.undo,
      label: l10n.commonUndo,
      dense: dense,
      onPressed: session.canUndo ? controller.undoTurn : null,
    );
    final layMeld = _Action(
      icon: Icons.playlist_add,
      label: l10n.gameLayMeld,
      dense: dense,
      onPressed: canAct && selectionCount >= 2
          ? (session.human.hasOpened
                ? controller.laySelectionAsMeld
                : controller.stageSelection)
          : null,
    );
    final layPairs = _Action(
      icon: Icons.filter_2,
      label: l10n.gameLayPairs,
      dense: dense,
      onPressed: canAct ? controller.layPairs : null,
    );
    // "Islemek": the selected tiles go onto melds already on the table. It was
    // previously only reachable by tapping a meld, which nobody finds.
    final canWork =
        canAct &&
        session.human.hasOpened &&
        !session.human.openedWithPairs &&
        controller.addableMeldIds().isNotEmpty;
    final work = _Action(
      icon: Icons.add_box_outlined,
      label: l10n.gameAddToMeld,
      dense: dense,
      onPressed: canWork ? controller.workSelection : null,
    );
    final showPairs = !session.human.hasOpened || session.human.openedWithPairs;
    final showWork = session.human.hasOpened && !session.human.openedWithPairs;

    // A Wrap rather than a horizontal scroller: on a narrow phone the primary
    // action must never end up off the edge where it cannot be found. It sits
    // in a Column whose table area is Expanded, so a second run steals height
    // from the grid instead of overflowing.
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: dense ? 1 : 2),
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: dense ? 2 : 4,
        children: [
          sort,
          undo,
          if (showWork) work,
          layMeld,
          if (!session.human.hasOpened) open,
          if (showPairs) layPairs,
          discard,
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.primary = false,
    this.dense = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool primary;

  /// Shorter and tighter, for the landscape strip above the rack.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      this.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: dense ? 11 : null),
    );
    // A padded tap target silently floors every button at 48 logical pixels,
    // which is a third of the height a landscape phone has left under the
    // table. shrinkWrap lets the declared height stand.
    final size = dense ? const Size(0, 34) : const Size(64, 44);
    final padding = EdgeInsets.symmetric(horizontal: dense ? 8 : 12);
    final tapTarget = dense
        ? MaterialTapTargetSize.shrinkWrap
        : MaterialTapTargetSize.padded;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dense ? 2 : 3),
      child: primary
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: dense ? 14 : 16),
              label: label,
              style: FilledButton.styleFrom(
                minimumSize: size,
                padding: padding,
                tapTargetSize: tapTarget,
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: dense ? 14 : 16),
              label: label,
              style: OutlinedButton.styleFrom(
                minimumSize: size,
                padding: padding,
                tapTargetSize: tapTarget,
              ),
            ),
    );
  }
}
