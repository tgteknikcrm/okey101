import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/features/game/game_session.dart';
import 'package:okey101/features/game/widgets/tile_widget.dart';

/// The player's rack: two rows of thirteen slots, like the physical istaka.
///
/// Tiles are absolutely positioned so a drag can move one anywhere without the
/// layout reflowing underneath it. Reordering happens on a working copy while
/// the finger is down and is committed once, on release.
///
/// It is ALWAYS live, whoever's turn it is. Arranging the rack is not a move -
/// the engine never learns about slots, and none of the controller's layout or
/// selection methods look at the turn. Locking it while the three bots played
/// meant the player could not touch their own tiles for most of the hand,
/// which is the whole of what you do while waiting.
class RackWidget extends StatefulWidget {
  const RackWidget({
    required this.slots,
    required this.tilesById,
    required this.selection,
    required this.okey,
    required this.indicator,
    required this.onLayoutChanged,
    required this.onTapTile,
    super.key,
    this.onDragOut,
    this.colorblind = false,
    this.glyphFor,
    this.maxHeight,
  });

  final List<int?> slots;
  final Map<int, Tile> tilesById;
  final Set<int> selection;
  final TileIdentity okey;
  final TileIdentity indicator;

  /// Emitted once, on release, with the whole new arrangement.
  final ValueChanged<List<int?>> onLayoutChanged;
  final ValueChanged<int> onTapTile;

  /// A tile was dragged clear of the rack and released, with the finger's
  /// global position.
  ///
  /// The rack does NOT decide what that means. It used to: releasing eight
  /// pixels above the top edge discarded the tile, which fired by accident
  /// every time a tile was moved from the bottom row to the top one. Now it
  /// reports the position and the board checks it against the discard pile,
  /// so the throw only happens where the player aimed it.
  final void Function(int tileId, Offset globalPosition)? onDragOut;


  final bool colorblind;
  final String Function(TileColor)? glyphFor;

  /// Ceiling on the rack's own height.
  ///
  /// Sizing on width alone is fine in portrait, but a landscape phone is wide
  /// and short: thirteen columns across 844 logical pixels would give 61-pixel
  /// tiles and a rack 192 pixels tall, half the screen. With a ceiling the
  /// tiles shrink to fit instead of eating the table.
  final double? maxHeight;

  @override
  State<RackWidget> createState() => _RackWidgetState();
}

class _RackWidgetState extends State<RackWidget> {
  static const double _gap = 3;
  static const double _rowGap = 6;
  static const double _padding = 6;

  /// The slot the tile was picked up from. It does NOT change while the finger
  /// moves: nothing on the rack is rearranged until the tile is put down.
  int? _draggingSlot;
  Offset _dragPosition = Offset.zero;
  Offset _grabOffset = Offset.zero;
  bool _movedFar = false;

  /// Captured on pointer-down rather than on drag-start. By the time a pan is
  /// recognised the pointer has already travelled, and with a coarse event
  /// stream it can be off the rack entirely - which used to lose the drag.
  Offset? _downPosition;
  int? _pendingSlot;

  /// The finger that owns the drag, tracked from the raw pointer stream.
  ///
  /// One PanGestureRecognizer covers the whole rack, and it only reports
  /// onPanEnd when the LAST finger lifts. A thumb resting on the rack - the
  /// normal way to hold a phone in landscape, where the rack is the band under
  /// your hands - therefore leaves the lifted finger's tile stuck in mid-air,
  /// following the resting thumb, until every finger comes off. Raw pointer
  /// events arrive per finger and before the arena resolves, which is the only
  /// place that can tell the two apart.
  int? _dragPointer;
  bool _extraPointer = false;

  /// Where the owning finger last actually was, in global coordinates.
  ///
  /// Taken from the raw pointer stream rather than from the gesture callbacks:
  /// the drag updates lag a fast flick badly. A tile carried across the rack
  /// and released on the fourth slot was landing on the eighth - roughly the
  /// midpoint of the swipe, which is how far behind the gesture layer was.
  Offset? _lastPointerGlobal;

  /// How far the tiles are inset inside this widget's own box.
  ///
  /// The gesture callbacks report positions relative to the padded child, but
  /// globalToLocal on this State's render object reports them relative to the
  /// whole band - and the rack is centred in that band whenever it is narrower,
  /// which it is as soon as the height cap bites. Forgetting the difference put
  /// a tile released on the fourth slot down on the eighth.
  double _insetX = 0;

  /// Chrome the rack adds around the rows of tiles: the outer padding plus one
  /// gap between each pair of rows.
  static const double _chromeHeight =
      _padding * 2 + _rowGap * (kRackRows - 1);

  Size _cellSize(double maxWidth) {
    final usable = maxWidth - _padding * 2 - _gap * (kRackColumns - 1);
    var width = usable / kRackColumns;

    final budget = widget.maxHeight;
    if (budget != null) {
      final fromHeight =
          (budget - _chromeHeight) / (kRackRows * TileWidget.aspectRatio);
      width = math.min(width, fromHeight);
    }

    final clamped = width.clamp(14.0, 64.0);
    return Size(clamped, TileWidget.heightFor(clamped));
  }

  Offset _originOf(int slot, Size cell) {
    final row = slot ~/ kRackColumns;
    final column = slot % kRackColumns;
    return Offset(
      _padding + column * (cell.width + _gap),
      _padding + row * (cell.height + _rowGap),
    );
  }

  int? _slotAt(Offset local, Size cell) {
    final column =
        ((local.dx - _padding) / (cell.width + _gap)).floor();
    final row = ((local.dy - _padding) / (cell.height + _rowGap)).floor();
    if (column < 0 || column >= kRackColumns) return null;
    if (row < 0 || row >= kRackRows) return null;
    return row * kRackColumns + column;
  }

  /// Nearest slot, so a drag that lands in a gap still has somewhere to go.
  int _nearestSlot(Offset local, Size cell) {
    final column = ((local.dx - _padding) / (cell.width + _gap))
        .round()
        .clamp(0, kRackColumns - 1);
    final row = ((local.dy - _padding) / (cell.height + _rowGap))
        .round()
        .clamp(0, kRackRows - 1);
    return row * kRackColumns + column;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cell = _cellSize(constraints.maxWidth);
        final height = _chromeHeight + cell.height * kRackRows;
        // Centred, so a rack narrower than the viewport (height-capped in
        // landscape) sits in the middle rather than hugging the left edge.
        final inset = (constraints.maxWidth -
                (_padding * 2 +
                    cell.width * kRackColumns +
                    _gap * (kRackColumns - 1))) /
            2;
        _insetX = inset > 0 ? inset : 0;

        return SizedBox(
          height: height,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: inset > 0 ? inset : 0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [OkeyPalette.rackLight, OkeyPalette.rack],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x55000000),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Listener(
                onPointerDown: (event) => _handlePointerDown(event, cell),
                onPointerMove: _handlePointerMove,
                onPointerUp: (event) => _handlePointerRelease(event, cell),
                onPointerCancel: (event) =>
                    _handlePointerRelease(event, cell),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) =>
                      _handleTap(details.localPosition, cell),
                  onPanDown: (details) => _handlePanDown(details, cell),
                  onPanStart: (details) => _handlePanStart(details, cell),
                  onPanUpdate: (details) => _handlePanUpdate(details, cell),
                  onPanEnd: (details) =>
                      _handlePanEnd(details.globalPosition, cell),
                  onPanCancel: _cancelDrag,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      for (var slot = 0; slot < kRackSlots; slot++)
                        _slotFrame(slot, cell),
                      for (var slot = 0; slot < kRackSlots; slot++)
                        if (widget.slots[slot] != null && slot != _draggingSlot)
                          _positionedTile(slot, cell),
                      if (_draggingSlot != null) _draggedTile(cell),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _slotFrame(int slot, Size cell) {
    final origin = _originOf(slot, cell);
    return Positioned(
      left: origin.dx,
      top: origin.dy,
      width: cell.width,
      height: cell.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0x22000000),
          borderRadius: BorderRadius.circular(cell.width * 0.16),
        ),
      ),
    );
  }

  Widget _positionedTile(int slot, Size cell) {
    final id = widget.slots[slot]!;
    final tile = widget.tilesById[id];
    if (tile == null) return const SizedBox.shrink();
    final origin = _originOf(slot, cell);
    // Plain Positioned, not animated. A tile moves when the player moves it and
    // at no other time: gliding tiles around after the fact is the rack acting
    // on its own, which is exactly what a physical istaka never does.
    return Positioned(
      key: ValueKey<int>(id),
      left: origin.dx,
      top: origin.dy,
      width: cell.width,
      height: cell.height,
      child: _tileFace(tile, cell.width),
    );
  }

  Widget _draggedTile(Size cell) {
    final id = widget.slots[_draggingSlot!];
    if (id == null) return const SizedBox.shrink();
    final tile = widget.tilesById[id];
    if (tile == null) return const SizedBox.shrink();
    return Positioned(
      key: const ValueKey<String>('dragged'),
      left: _dragPosition.dx - _grabOffset.dx,
      top: _dragPosition.dy - _grabOffset.dy,
      width: cell.width,
      height: cell.height,
      child: Transform.scale(
        scale: 1.22,
        child: _tileFace(tile, cell.width),
      ),
    );
  }

  Widget _tileFace(Tile tile, double width) {
    final isOkey = !tile.isFalseJoker &&
        tile.color == widget.okey.color &&
        tile.number == widget.okey.number;
    return TileWidget(
      width: width,
      tile: tile,
      kind: tile.isFalseJoker
          ? TileFaceKind.falseJoker
          : isOkey
              ? TileFaceKind.okey
              : TileFaceKind.normal,
      colorblindGlyph: widget.colorblind && tile.color != null
          ? widget.glyphFor?.call(tile.color!)
          : null,
      selected: widget.selection.contains(tile.id),
    );
  }

  void _handleTap(Offset local, Size cell) {
    final slot = _slotAt(local, cell);
    if (slot == null) return;
    final id = widget.slots[slot];
    if (id == null) return;
    widget.onTapTile(id);
  }

  void _handlePointerDown(PointerDownEvent event, Size cell) {
    _lastPointerGlobal = event.position;
    if (_dragPointer == null) {
      _dragPointer = event.pointer;
      _extraPointer = false;
      return;
    }
    // A second finger landed. Freeze the drag and commit what it has done so
    // far, rather than letting the tile follow whichever finger the recogniser
    // happens to average out to.
    _extraPointer = true;
    if (_draggingSlot != null) _handlePanEnd(event.position, cell);
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (event.pointer == _dragPointer) _lastPointerGlobal = event.position;
  }

  void _handlePointerRelease(PointerEvent event, Size cell) {
    if (event.pointer != _dragPointer) return;
    _dragPointer = null;
    _extraPointer = false;
    // The finger that started the drag is up, so the drag is over - whatever
    // else is still touching the rack.
    if (_draggingSlot != null) _handlePanEnd(event.position, cell);
  }

  void _handlePanDown(DragDownDetails details, Size cell) {
    final slot = _slotAt(details.localPosition, cell);
    _downPosition = details.localPosition;
    _pendingSlot = slot != null && widget.slots[slot] != null ? slot : null;
    if (_pendingSlot != null) {
      _grabOffset = details.localPosition - _originOf(_pendingSlot!, cell);
    }
  }

  void _handlePanStart(DragStartDetails details, Size cell) {
    if (_extraPointer) return;
    final slot = _pendingSlot;
    if (slot == null || widget.slots[slot] == null) return;
    setState(() {
      _draggingSlot = slot;
      _dragPosition = details.localPosition;
      _movedFar = false;
    });
    _updateDrag(details.localPosition);
  }

  void _handlePanUpdate(DragUpdateDetails details, Size cell) {
    if (_extraPointer || _draggingSlot == null) return;
    _updateDrag(details.localPosition);
  }

  /// Only the carried tile moves. The rack underneath is left exactly as it
  /// was until the finger lifts - tiles jumping aside as you pass over them,
  /// some of them dropping to the other row, is what made arranging a rack
  /// feel like fighting it.
  void _updateDrag(Offset local) {
    setState(() {
      _dragPosition = local;
      final from = _downPosition;
      if (from != null && (local - from).distance > 8) _movedFar = true;
    });
  }

  /// Puts the tile down where the finger actually is.
  void _handlePanEnd(Offset reported, Size cell) {
    // The raw stream wins over whatever the gesture layer reports.
    final globalPosition = _lastPointerGlobal ?? reported;
    final source = _draggingSlot;
    if (source == null) {
      _cancelDrag();
      return;
    }

    final tileId = widget.slots[source];
    final movedFar = _movedFar;
    setState(() {
      _draggingSlot = null;
      _pendingSlot = null;
      _downPosition = null;
    });
    _lastPointerGlobal = null;
    if (tileId == null) return;

    if (!movedFar) {
      // The pan won the arena but the finger barely moved, so the player meant
      // a tap. Without this the touch is swallowed: the tap recogniser already
      // lost and nothing at all happens, which reads as the rack ignoring you.
      widget.onTapTile(tileId);
      return;
    }

    if (!_insideRack(globalPosition)) {
      // Off the rack entirely. The board decides whether that lands on the
      // discard pile; either way the arrangement is left alone, so a throw
      // that misses does not also scramble the rack.
      widget.onDragOut?.call(tileId, globalPosition);
      return;
    }

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(globalPosition) - Offset(_insetX, 0);
    final target = _nearestSlot(local, cell);
    if (target == source) return;
    // RackLayout.move slides the tiles in between out of the way, which is the
    // one from the left and one from the right that a player pushes apart to
    // drop a tile into the middle.
    widget.onLayoutChanged(RackLayout.move(widget.slots, source, target));
  }

  /// Whether the finger is still over the rack itself.
  ///
  /// Generous on the sides and the bottom, tight at the top: the table is up
  /// there and that is the only direction a deliberate throw comes from.
  bool _insideRack(Offset global) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return true;
    final local = box.globalToLocal(global);
    final size = box.size;
    return local.dx >= -40 &&
        local.dx <= size.width + 40 &&
        local.dy >= -24 &&
        local.dy <= size.height + 40;
  }

  void _cancelDrag() {
    setState(() {
      _draggingSlot = null;
      _pendingSlot = null;
      _downPosition = null;
    });
  }
}
