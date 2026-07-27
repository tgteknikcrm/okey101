import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okey101/app/providers.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/core/error_messages.dart';
import 'package:okey101/core/tile_glyphs.dart';
import 'package:okey101/core/wake_lock.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/features/game/game_controller.dart';
import 'package:okey101/features/game/game_session.dart';
import 'package:okey101/features/game/widgets/hand_over_sheet.dart';
import 'package:okey101/features/game/widgets/meld_view.dart';
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
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final game = session.state;

    return Stack(
      children: [
        Column(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
              child: RackWidget(
                slots: session.rackSlots,
                tilesById: {
                  for (final tile in session.human.hand) tile.id: tile,
                },
                selection: session.selection,
                okey: game.okey,
                indicator: game.indicatorIdentity,
                colorblind: settings.colorblind,
                glyphFor: (color) => colorGlyph(l10n, color),
                enabled: session.isHumanTurn,
                animate: settings.animations,
                onLayoutChanged: (slots) => onCommitLayout(session, slots),
                onTapTile: controller.toggleSelection,
                onDragOut: (tileId, _) => onDragOut(session, tileId),
              ),
            ),
          ],
        ),
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
          IconButton(
            tooltip: l10n.commonBack,
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
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  session.isHumanTurn
                      ? l10n.gameYourTurn
                      : l10n.gameThinking(game.currentPlayer.name),
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
      builder: (context) => SafeArea(
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
    );
  }
}

class _OpponentRow extends StatelessWidget {
  const _OpponentRow({required this.session, this.compact = false});

  final GameSession session;
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: OpponentPanel(
                  player: game.players[seat],
                  isCurrent: game.currentSeat == seat && !game.isHandOver,
                  thinking: session.botThinking,
                  okey: game.okey,
                  compact: compact,
                ),
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
                  : const TileWidget(width: 34, faceDown: true),
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
        width: 34,
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
    this.onTap,
  });

  final String label;
  final Widget child;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        // Generous hit area: a touch target you cannot feel needs to be big.
        constraints: const BoxConstraints(minHeight: 64),
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
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
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
  const _EmptySlot();

  @override
  Widget build(BuildContext context) => Container(
        width: 34,
        height: TileWidget.heightFor(34),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0x33FBF5E6)),
        ),
      );
}

class _TableArea extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final game = session.state;
    if (game.table.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            l10n.gameSelectTilesHint,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0x88FBF5E6),
              fontSize: 12,
            ),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final meld in game.table)
            MeldView(
              meld: meld,
              okey: game.okey,
              ownerName: game.players[meld.ownerSeat].name,
              tileWidth: 22,
              colorblind: colorblind,
              glyphFor: (color) => colorGlyph(l10n, color),
              highlighted: focusedMeldId == meld.id,
              onTap: () => onTapMeld(meld.id),
              onTapTile: (index) => onTapMeldTile(meld.id, index),
            ),
        ],
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
  const _ActionBar({required this.session, required this.onSort});

  final GameSession session;
  final VoidCallback onSort;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(gameControllerProvider.notifier);
    final game = session.state;
    final canAct =
        session.isHumanTurn && game.phase == TurnPhase.awaitingDiscard;
    final selectionCount = session.selection.length;

    // A Wrap rather than a horizontal scroller: on a narrow phone the primary
    // action must never end up off the edge where it cannot be found.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 4,
        children: [
          _Action(
            icon: Icons.sort,
            label: l10n.gameSort,
            onPressed: session.isHumanTurn ? onSort : null,
          ),
          _Action(
            icon: Icons.undo,
            label: l10n.commonUndo,
            onPressed: session.canUndo ? controller.undoTurn : null,
          ),
          if (!session.human.hasOpened) ...[
            _Action(
              icon: Icons.playlist_add,
              label: l10n.gameLayMeld,
              onPressed:
                  canAct && selectionCount >= 2 ? controller.stageSelection : null,
            ),
            _Action(
              icon: Icons.lock_open,
              label: session.pendingMelds.isEmpty
                  ? l10n.gameOpenAction
                  : '${l10n.gameOpenAction} (${controller.pendingPoints()})',
              primary: true,
              onPressed: canAct ? controller.openWithPending : null,
            ),
            _Action(
              icon: Icons.filter_2,
              label: l10n.gameLayPairs,
              onPressed: canAct ? controller.layPairs : null,
            ),
          ] else ...[
            _Action(
              icon: Icons.playlist_add,
              label: l10n.gameLayMeld,
              onPressed: canAct && selectionCount >= 2
                  ? controller.laySelectionAsMeld
                  : null,
            ),
            if (session.human.openedWithPairs)
              _Action(
                icon: Icons.filter_2,
                label: l10n.gameLayPairs,
                onPressed: canAct ? controller.layPairs : null,
              ),
          ],
          _Action(
            icon: Icons.south_east,
            label: l10n.gameDiscardPile,
            primary: true,
            onPressed: canAct && selectionCount == 1
                ? () {
                    ref.read(feedbackProvider).light();
                    controller
                      ..discard(session.selection.single)
                      ..clearSelection();
                  }
                : null,
          ),
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
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: primary
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 16),
              label: Text(label),
              style: FilledButton.styleFrom(
                minimumSize: const Size(64, 44),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 16),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(64, 44),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
    );
  }
}
