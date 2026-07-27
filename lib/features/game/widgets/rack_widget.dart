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
    this.colorblind = false,
    this.glyphFor,
    this.enabled = true,
    this.animate = true,
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


  final bool colorblind;
  final String Function(TileColor)? glyphFor;
  final bool enabled;

  /// Off when the player has turned animations off in Settings.
  final bool animate;

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

  List<int?>? _working;
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

  List<int?> get _slots => _working ?? widget.slots;

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
                onPointerDown: _handlePointerDown,
                onPointerUp: _handlePointerRelease,
                onPointerCancel: _handlePointerRelease,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) {
                    if (widget.enabled) _handleTap(details.localPosition, cell);
                  },
                  onPanDown: (details) {
                    if (widget.enabled) _handlePanDown(details, cell);
                  },
                  onPanStart: (details) {
                    if (widget.enabled) _handlePanStart(details, cell);
                  },
                  onPanUpdate: (details) {
                    if (widget.enabled) _handlePanUpdate(details, cell);
                  },
                  // Never null, even when the rack is disabled. A
                  // GestureDetector drops the recogniser entirely once every
                  // pan callback is null, and disposing it mid-drag clears its
                  // tracked pointers WITHOUT calling either terminal callback -
                  // so a tile caught by the turn changing was stranded on
                  // screen for good.
                  onPanEnd: (_) => _handlePanEnd(),
                  onPanCancel: _cancelDrag,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      for (var slot = 0; slot < kRackSlots; slot++)
                        _slotFrame(slot, cell),
                      for (var slot = 0; slot < kRackSlots; slot++)
                        if (_slots[slot] != null && slot != _draggingSlot)
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
    final id = _slots[slot]!;
    final tile = widget.tilesById[id];
    if (tile == null) return const SizedBox.shrink();
    final origin = _originOf(slot, cell);
    return AnimatedPositioned(
      key: ValueKey<int>(id),
      duration:
          Duration(milliseconds: widget.animate ? 160 : 0),
      curve: Curves.easeOutCubic,
      left: origin.dx,
      top: origin.dy,
      width: cell.width,
      height: cell.height,
      child: _tileFace(tile, cell.width),
    );
  }

  Widget _draggedTile(Size cell) {
    final id = _slots[_draggingSlot!];
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
    final id = _slots[slot];
    if (id == null) return;
    widget.onTapTile(id);
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (_dragPointer == null) {
      _dragPointer = event.pointer;
      _extraPointer = false;
      return;
    }
    // A second finger landed. Freeze the drag and commit what it has done so
    // far, rather than letting the tile follow whichever finger the recogniser
    // happens to average out to.
    _extraPointer = true;
    if (_draggingSlot != null) _handlePanEnd();
  }

  void _handlePointerRelease(PointerEvent event) {
    if (event.pointer != _dragPointer) return;
    _dragPointer = null;
    _extraPointer = false;
    // The finger that started the drag is up, so the drag is over - whatever
    // else is still touching the rack.
    if (_draggingSlot != null) _handlePanEnd();
  }

  void _handlePanDown(DragDownDetails details, Size cell) {
    final slot = _slotAt(details.localPosition, cell);
    _downPosition = details.localPosition;
    _pendingSlot = slot != null && _slots[slot] != null ? slot : null;
    if (_pendingSlot != null) {
      _grabOffset = details.localPosition - _originOf(_pendingSlot!, cell);
    }
  }

  void _handlePanStart(DragStartDetails details, Size cell) {
    if (_extraPointer) return;
    final slot = _pendingSlot;
    if (slot == null || _slots[slot] == null) return;
    setState(() {
      _working = List<int?>.of(widget.slots);
      _draggingSlot = slot;
      _dragPosition = details.localPosition;
      _movedFar = false;
    });
    // The pan may already have travelled before it was recognised, so treat the
    // start position as a first update.
    _updateDrag(details.localPosition, cell);
  }

  void _handlePanUpdate(DragUpdateDetails details, Size cell) {
    if (_extraPointer || _draggingSlot == null) return;
    _updateDrag(details.localPosition, cell);
  }

  void _updateDrag(Offset local, Size cell) {
    final target = _nearestSlot(local, cell);
    setState(() {
      _dragPosition = local;
      final from = _downPosition;
      if (from != null && (local - from).distance > 8) _movedFar = true;
      if (target != _draggingSlot) {
        _working = RackLayout.move(_slots, _draggingSlot!, target);
        _draggingSlot = target;
      }
    });
  }

  void _handlePanEnd() {
    final slot = _draggingSlot;
    final working = _working;
    if (slot == null || working == null) {
      _cancelDrag();
      return;
    }

    final tileId = working[slot];
    final movedFar = _movedFar;
    setState(() {
      _draggingSlot = null;
      _working = null;
      _pendingSlot = null;
      _downPosition = null;
    });

    if (movedFar) {
      widget.onLayoutChanged(working);
      return;
    }
    // The pan won the arena but the finger barely moved, so the player meant a
    // tap. Without this the touch is swallowed: the tap recogniser already lost
    // and nothing at all happens, which reads as the rack ignoring you.
    if (tileId != null) widget.onTapTile(tileId);
  }

  void _cancelDrag() {
    setState(() {
      _draggingSlot = null;
      _working = null;
      _pendingSlot = null;
      _downPosition = null;
    });
  }
}
