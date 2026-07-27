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
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/features/game/game_controller.dart';
import 'package:okey101/features/game/game_session.dart';
import 'package:okey101/features/game/widgets/hand_over_sheet.dart';
import 'package:okey101/features/game/widgets/meld_board.dart';
import 'package:okey101/features/game/widgets/opponent_panel.dart';
import 'package:okey101/features/game/widgets/rack_widget.dart';
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

  /// Dragging a tile clear of the rack discards it, which is the fastest way to
  /// end a turn once the rack is arranged.
  void _handleDragOut(GameSession session, int tileId) {
    if (!session.isHumanTurn) return;
    if (session.state.phase != TurnPhase.awaitingDiscard) return;
    ref.read(feedbackProvider).light();
    ref.read(gameControllerProvider.notifier).discard(tileId);
  }

  void _handleMeldTap(int meldId) {
    final session = ref.read(gameControllerProvider);
    if (session == null || !session.isHumanTurn) return;
    final controller = ref.read(gameControllerProvider.notifier);
    if (session.selection.length == 1) {
      controller
        ..addToMeld(meldId, session.selection.single)
        ..clearSelection();
      return;
    }
    setState(() => _focusedMeldId = _focusedMeldId == meldId ? null : meldId);
  }

  void _handleMeldTileTap(int meldId, int index) {
    final session = ref.read(gameControllerProvider);
    if (session == null || !session.isHumanTurn) return;
    if (session.selection.length != 1) {
      _handleMeldTap(meldId);
      return;
    }
    ref.read(gameControllerProvider.notifier)
      ..replaceJoker(meldId, index, session.selection.single)
      ..clearSelection();
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
  });

  final GameSession session;
  final bool compactOpponents;
  final int? focusedMeldId;
  final VoidCallback onSort;
  final ValueChanged<int> onTapMeld;
  final void Function(int meldId, int index) onTapMeldTile;
  final void Function(GameSession session, List<int?> slots) onCommitLayout;
  final void Function(GameSession session, int tileId) onDragOut;

  /// Width of the rails flanking the table in the landscape board.
  static const double leftRailWidth = 106;
  static const double deckColumnWidth = 62;
  static const double pairsPanelWidth = 72;
  static const double rightRailWidth = 116;

  /// Share of the height the rack may take. The rest is the table.
  static const double rackHeightShare = 0.37;

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

  /// Wide and short. Everything that is not the table moves into a rail, so the
  /// gridded board gets the middle and the rack keeps the full width - the same
  /// arrangement a physical okey table has.
  Widget _landscapeBoard(
    AppSettings settings,
    GameController controller,
    Widget rack,
  ) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: leftRailWidth,
                child: _OpponentRow(
                  session: session,
                  compact: true,
                  vertical: true,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    _Header(session: session, dense: true),
                    Expanded(
                      child: _TableArea(
                        session: session,
                        colorblind: settings.colorblind,
                        focusedMeldId: focusedMeldId,
                        onTapMeld: onTapMeld,
                        onTapMeldTile: onTapMeldTile,
                      ),
                    ),
                    _HudBar(session: session),
                  ],
                ),
              ),
              // Draw pile and indicator stand in a column rather than a strip:
              // vertical space is what the grid board needs most.
              SizedBox(
                width: deckColumnWidth,
                child: _DeckColumn(
                  session: session,
                  colorblind: settings.colorblind,
                  onDrawPile: controller.drawFromPile,
                  onDrawDiscard: controller.drawFromDiscard,
                ),
              ),
              SizedBox(
                width: pairsPanelWidth,
                child: _PairsPanel(
                  session: session,
                  colorblind: settings.colorblind,
                ),
              ),
              SizedBox(
                width: rightRailWidth,
                child: _ActionBar(
                  session: session,
                  onSort: onSort,
                  vertical: true,
                ),
              ),
            ],
          ),
        ),
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
        ),
        Expanded(
          child: _TableArea(
            session: session,
            colorblind: settings.colorblind,
            focusedMeldId: focusedMeldId,
            onTapMeld: onTapMeld,
            onTapMeldTile: onTapMeldTile,
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
      child: RackWidget(
        slots: session.rackSlots,
        tilesById: {for (final tile in session.human.hand) tile.id: tile},
        selection: session.selection,
        okey: game.okey,
        indicator: game.indicatorIdentity,
        colorblind: settings.colorblind,
        glyphFor: (color) => colorGlyph(l10n, color),
        enabled: session.isHumanTurn,
        animate: settings.animations,
        maxHeight: maxHeight,
        onLayoutChanged: (slots) => onCommitLayout(session, slots),
        onTapTile: controller.toggleSelection,
        onDragOut: (tileId, _) => onDragOut(session, tileId),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.session, this.dense = false});

  final GameSession session;

  /// Landscape has little vertical room, so the bar loses its padding and the
  /// icon buttons shrink.
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final game = session.state;
    return Padding(
      padding: dense
          ? const EdgeInsets.fromLTRB(2, 0, 2, 0)
          : const EdgeInsets.fromLTRB(8, 4, 8, 2),
      child: Row(
        children: [
          IconButton(
            tooltip: l10n.commonBack,
            iconSize: dense ? 18 : 24,
            visualDensity: dense ? VisualDensity.compact : null,
            constraints: dense
                ? const BoxConstraints(minWidth: 34, minHeight: 34)
                : null,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ref.read(gameControllerProvider.notifier).leave();
              Navigator.of(context).pop();
            },
          ),
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
                  style: TextStyle(
                    fontSize: dense ? 12 : 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  session.isHumanTurn
                      ? l10n.gameYourTurn
                      : l10n.gameThinking(game.currentPlayer.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: dense ? 10 : 11,
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
            iconSize: dense ? 18 : 24,
            visualDensity: dense ? VisualDensity.compact : null,
            constraints: dense
                ? const BoxConstraints(minWidth: 34, minHeight: 34)
                : null,
            icon: const Icon(Icons.list_alt),
            onPressed: () => _showScoreboard(context, session),
          ),
        ],
      ),
    );
  }

  void _showScoreboard(BuildContext context, GameSession session) {
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
}

class _OpponentRow extends StatelessWidget {
  const _OpponentRow({
    required this.session,
    this.compact = false,
    this.vertical = false,
  });

  final GameSession session;
  final bool compact;

  /// Landscape stacks the three opponents down a side rail instead of across
  /// the top, which is where the width is cheap and the height is not.
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final game = session.state;
    final seats = <int>[
      for (var step = 1; step < kSeatCount; step++)
        (session.humanSeat + step) % kSeatCount,
    ];
    Widget panel(int seat) => OpponentPanel(
          player: game.players[seat],
          isCurrent: game.currentSeat == seat && !game.isHandOver,
          thinking: session.botThinking,
          okey: game.okey,
          compact: compact,
        );

    if (vertical) {
      // Sized by content and scrolled, not divided by Expanded: three equal
      // thirds of the rail are 59.6 logical pixels while a compact panel needs
      // 66, which clips at any text scale above 1.0.
      return Padding(
        padding: const EdgeInsets.fromLTRB(6, 2, 2, 2),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final seat in seats)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: panel(seat),
                ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          for (final seat in seats)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: panel(seat),
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
  });

  final GameSession session;
  final bool colorblind;
  final VoidCallback onDrawPile;
  final VoidCallback onDrawDiscard;

  static const double _tileWidth = 34;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final game = session.state;
    final leftSeat = seatToLeftOf(session.humanSeat);
    final leftTop = game.players[leftSeat].topDiscard;
    final ownTop = game.players[session.humanSeat].topDiscard;
    final canDraw =
        session.isHumanTurn && game.phase == TurnPhase.awaitingDraw;

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
        colorblindGlyph:
            colorblind && tile.color != null ? colorGlyph(l10n, tile.color!) : null,
      );
}

class _Slot extends StatelessWidget {
  const _Slot({
    required this.label,
    required this.child,
    required this.enabled,
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
    final addable =
        ref.read(gameControllerProvider.notifier).addableMeldIds();

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

/// Draw pile, indicator and the two reachable discard piles, stacked.
class _DeckColumn extends StatelessWidget {
  const _DeckColumn({
    required this.session,
    required this.colorblind,
    required this.onDrawPile,
    required this.onDrawDiscard,
  });

  final GameSession session;
  final bool colorblind;
  final VoidCallback onDrawPile;
  final VoidCallback onDrawDiscard;

  static const double tileWidth = 22;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final game = session.state;
    final leftTop = game.players[seatToLeftOf(session.humanSeat)].topDiscard;
    final ownTop = game.players[session.humanSeat].topDiscard;
    final canDraw =
        session.isHumanTurn && game.phase == TurnPhase.awaitingDraw;

    Widget tile(Tile value) => TileWidget(
          width: tileWidth,
          tile: value,
          kind: value.isFalseJoker
              ? TileFaceKind.falseJoker
              : (value.color == game.okey.color &&
                      value.number == game.okey.number)
                  ? TileFaceKind.okey
                  : TileFaceKind.normal,
          colorblindGlyph: colorblind && value.color != null
              ? colorGlyph(l10n, value.color!)
              : null,
        );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0x1AFBF5E6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _Slot(
              label: l10n.gameTakeDiscard,
              enabled: canDraw && leftTop != null,
              compact: true,
              onTap: canDraw && leftTop != null ? onDrawDiscard : null,
              child: leftTop == null
                  ? const _EmptySlot(width: tileWidth)
                  : tile(leftTop),
            ),
            _Slot(
              label: l10n.gameRemainingTiles(game.drawPile.length),
              enabled: canDraw && game.drawPile.isNotEmpty,
              compact: true,
              onTap: canDraw && game.drawPile.isNotEmpty ? onDrawPile : null,
              child: game.drawPile.isEmpty
                  ? const _EmptySlot(width: tileWidth)
                  : const TileWidget(width: tileWidth, faceDown: true),
            ),
            _Slot(
              label: l10n.gameIndicator,
              enabled: false,
              compact: true,
              child: tile(game.indicator),
            ),
            _Slot(
              label: l10n.gameDiscardPile,
              enabled: false,
              compact: true,
              child: ownTop == null
                  ? const _EmptySlot(width: tileWidth)
                  : tile(ownTop),
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
        label: l10n.gamePairsMode,
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
              if (controller.canFinishNow())
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
    this.vertical = false,
  });

  final GameSession session;
  final VoidCallback onSort;

  /// Landscape stacks the actions down the right rail. Vertical space is the
  /// scarce axis there, so the rail scrolls and the two actions that end a turn
  /// are placed first, where they are always reachable.
  final bool vertical;

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
      expand: vertical,
      onPressed: canAct ? controller.openWithPending : null,
    );
    final discard = _Action(
      icon: Icons.south_east,
      label: l10n.gameDiscardPile,
      primary: true,
      expand: vertical,
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
      expand: vertical,
      onPressed: session.isHumanTurn ? onSort : null,
    );
    final undo = _Action(
      icon: Icons.undo,
      label: l10n.commonUndo,
      expand: vertical,
      onPressed: session.canUndo ? controller.undoTurn : null,
    );
    final layMeld = _Action(
      icon: Icons.playlist_add,
      label: l10n.gameLayMeld,
      expand: vertical,
      onPressed: canAct && selectionCount >= 2
          ? (session.human.hasOpened
              ? controller.laySelectionAsMeld
              : controller.stageSelection)
          : null,
    );
    final layPairs = _Action(
      icon: Icons.filter_2,
      label: l10n.gameLayPairs,
      expand: vertical,
      onPressed: canAct ? controller.layPairs : null,
    );
    // "Islemek": the selected tiles go onto melds already on the table. It was
    // previously only reachable by tapping a meld, which nobody finds.
    final canWork = canAct &&
        session.human.hasOpened &&
        !session.human.openedWithPairs &&
        controller.addableMeldIds().isNotEmpty;
    final work = _Action(
      icon: Icons.add_box_outlined,
      label: l10n.gameAddToMeld,
      expand: vertical,
      onPressed: canWork ? controller.workSelection : null,
    );
    final showPairs =
        !session.human.hasOpened || session.human.openedWithPairs;
    final showWork =
        session.human.hasOpened && !session.human.openedWithPairs;

    if (vertical) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(2, 2, 6, 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!session.human.hasOpened) open,
            discard,
            if (showWork) work,
            layMeld,
            if (showPairs) layPairs,
            sort,
            undo,
          ],
        ),
      );
    }

    // A Wrap rather than a horizontal scroller: on a narrow phone the primary
    // action must never end up off the edge where it cannot be found.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 4,
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
    this.expand = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool primary;

  /// Fill the available width, for the stacked landscape rail.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      this.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: expand ? 12 : null),
    );
    // A padded tap target silently floors every button at 48 logical pixels,
    // which puts six stacked actions at 312 in a 240-pixel rail - the last two
    // end up below the fold. shrinkWrap lets the declared height stand.
    final size = expand ? const Size(0, 36) : const Size(64, 44);
    final padding = EdgeInsets.symmetric(horizontal: expand ? 4 : 12);
    final tapTarget =
        expand ? MaterialTapTargetSize.shrinkWrap : MaterialTapTargetSize.padded;

    return Padding(
      padding: expand
          ? const EdgeInsets.symmetric(vertical: 1)
          : const EdgeInsets.symmetric(horizontal: 3),
      child: primary
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: expand ? 14 : 16),
              label: label,
              style: FilledButton.styleFrom(
                minimumSize: size,
                padding: padding,
                tapTargetSize: tapTarget,
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: expand ? 14 : 16),
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
