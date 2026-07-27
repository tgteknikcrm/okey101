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
    this.onDragOut,
    this.enabled = true,
    this.animate = true,
  });

  final List<int?> slots;
  final Map<int, Tile> tilesById;
  final Set<int> selection;
  final TileIdentity okey;
  final TileIdentity indicator;

  /// Emitted once, on release, with the whole new arrangement.
  final ValueChanged<List<int?>> onLayoutChanged;
  final ValueChanged<int> onTapTile;

  /// A tile dragged clear of the rack. The screen decides what that means.
  final void Function(int tileId, Offset globalPosition)? onDragOut;

  final bool colorblind;
  final String Function(TileColor)? glyphFor;
  final bool enabled;

  /// Off when the player has turned animations off in Settings.
  final bool animate;

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

  List<int?> get _slots => _working ?? widget.slots;

  Size _cellSize(double maxWidth) {
    final usable = maxWidth - _padding * 2 - _gap * (kRackColumns - 1);
    final width = (usable / kRackColumns).clamp(16.0, 64.0);
    return Size(width, TileWidget.heightFor(width));
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
        final height =
            _padding * 2 + cell.height * kRackRows + _rowGap;

        return SizedBox(
          height: height,
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
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: widget.enabled
                  ? (details) => _handleTap(details.localPosition, cell)
                  : null,
              onPanDown: widget.enabled
                  ? (details) => _handlePanDown(details, cell)
                  : null,
              onPanStart: widget.enabled
                  ? (details) => _handlePanStart(details, cell)
                  : null,
              onPanUpdate: widget.enabled
                  ? (details) => _handlePanUpdate(details, cell)
                  : null,
              onPanEnd: widget.enabled ? (details) => _handlePanEnd() : null,
              onPanCancel: widget.enabled ? _cancelDrag : null,
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

  void _handlePanDown(DragDownDetails details, Size cell) {
    final slot = _slotAt(details.localPosition, cell);
    _downPosition = details.localPosition;
    _pendingSlot = slot != null && _slots[slot] != null ? slot : null;
    if (_pendingSlot != null) {
      _grabOffset = details.localPosition - _originOf(_pendingSlot!, cell);
    }
  }

  void _handlePanStart(DragStartDetails details, Size cell) {
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
    if (_draggingSlot == null) return;
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

    // Dragged clear of the rack: the screen decides what that means.
    final draggedOut = _dragPosition.dy < -8;
    final tileId = working[slot];
    setState(() {
      _draggingSlot = null;
      _working = null;
      _pendingSlot = null;
      _downPosition = null;
    });

    if (draggedOut && tileId != null && widget.onDragOut != null) {
      final box = context.findRenderObject()! as RenderBox;
      widget.onDragOut!(tileId, box.localToGlobal(_dragPosition));
      return;
    }
    if (_movedFar) widget.onLayoutChanged(working);
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
