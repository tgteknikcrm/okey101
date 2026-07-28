import 'package:flutter/material.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/features/game/board_layout.dart';
import 'package:okey101/features/game/widgets/tile_widget.dart';

/// Paints the empty grid the melds sit in: one cell per tile, with a divider
/// between halves. Drawn once for the whole board rather than as widgets, so an
/// empty table costs nothing.
class _GridPainter extends CustomPainter {
  const _GridPainter({
    required this.cell,
    required this.rowPitch,
    required this.rows,
    required this.halves,
    required this.columns,
    this.halfGap = 0,
  });

  final Size cell;
  final double rowPitch;
  final int rows;
  final int halves;

  /// Columns in ONE half. Taken as a parameter rather than read off
  /// BoardLayout: the pairs panel is two columns wide, and painting the main
  /// board's thirteen there spilled empty cells clean across the seat rail
  /// beside it. A CustomPaint does not clip, so nothing caught it.
  final int columns;
  final double halfGap;

  @override
  void paint(Canvas canvas, Size size) {
    final slot = Paint()..color = const Color(0x14FBF5E6);
    final radius = Radius.circular(cell.width * 0.14);
    final halfWidth = cell.width * columns;

    for (var half = 0; half < halves; half++) {
      final originX = half * (halfWidth + halfGap);
      for (var row = 0; row < rows; row++) {
        for (var column = 0; column < columns; column++) {
          final rect = Rect.fromLTWH(
            originX + column * cell.width + 1,
            row * rowPitch + 1,
            cell.width - 2,
            cell.height - 2,
          );
          canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), slot);
        }
      }
      if (half > 0) {
        final x = originX - halfGap / 2;
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, rows * rowPitch),
          Paint()
            ..color = const Color(0x33FBF5E6)
            ..strokeWidth = 1,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) =>
      old.cell != cell ||
      old.rows != rows ||
      old.halves != halves ||
      old.columns != columns ||
      old.rowPitch != rowPitch;
}

/// The table: a grid of tile-sized cells with the melds snapped into it.
///
/// A meld always occupies consecutive cells of a single row and never crosses
/// the divider between halves, which is what keeps a long run readable.
class MeldBoard extends StatelessWidget {
  const MeldBoard({
    required this.melds,
    required this.okey,
    required this.indicatorIdentity,
    required this.ownerColorOf,
    super.key,
    this.colorblind = false,
    this.glyphFor,
    this.focusedMeldId,
    this.addableMeldIds = const <int>{},
    this.onTapMeld,
    this.onTapMeldTile,
    this.emptyHint,
  });

  final List<Meld> melds;
  final TileIdentity okey;
  final TileIdentity indicatorIdentity;

  /// A thin bar in the owner's colour under each meld, since there is no room
  /// for a name label inside a grid cell.
  final Color Function(int seat) ownerColorOf;

  final bool colorblind;
  final String Function(TileColor)? glyphFor;
  final int? focusedMeldId;

  /// Melds the current selection could legally be worked onto. Outlined so the
  /// player can see where a tile will go before committing to it.
  final Set<int> addableMeldIds;

  final ValueChanged<int>? onTapMeld;
  final void Function(int meldId, int index)? onTapMeldTile;
  final Widget? emptyHint;

  static const double _minCell = 13;
  static const double _maxCell = 34;
  static const double _rowGap = 4;
  static const double _halfGap = 10;

  /// Rows the board always keeps room for.
  static const int _rows = 5;

  /// Cells are drawn a tenth smaller than the width alone would allow, which
  /// buys back a row of laying space without touching the readable minimum.
  static const double _cellScale = 0.9;

  bool _isOkey(Tile tile) =>
      !tile.isFalseJoker &&
      tile.color == okey.color &&
      tile.number == okey.number;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Show a second half only when it can be done without shrinking the
        // tiles below the readable minimum.
        final widthForTwo =
            (constraints.maxWidth - _halfGap) / (BoardLayout.columnsPerHalf * 2);
        final halves = widthForTwo >= _minCell ? 2 : 1;

        final available = halves == 2
            ? constraints.maxWidth - _halfGap
            : constraints.maxWidth;
        // Height has a say as well as width. Sizing on width alone left the
        // cells tall enough that only four rows fitted, so the fifth was there
        // but cut off at the fold - a board that scrolls to show half a row of
        // empty cells looks broken rather than roomy.
        final fromWidth =
            available / (BoardLayout.columnsPerHalf * halves) * _cellScale;
        final fromHeight =
            (constraints.maxHeight / _rows - _rowGap) / TileWidget.aspectRatio;
        final cellWidth = (fromWidth < fromHeight ? fromWidth : fromHeight)
            .clamp(_minCell, _maxCell);
        final cell = Size(cellWidth, TileWidget.heightFor(cellWidth));
        final rowPitch = cell.height + _rowGap;

        final placements = BoardLayout.place(melds, halves: halves);
        final rowsUsed = BoardLayout.rowsUsed(placements);
        final rowsThatFit = (constraints.maxHeight / rowPitch).floor();
        final rows = [
          _rows,
          rowsUsed,
          rowsThatFit,
        ].reduce((a, b) => a > b ? a : b);

        final byId = <int, Meld>{for (final meld in melds) meld.id: meld};
        final halfWidth = cell.width * BoardLayout.columnsPerHalf;
        final boardWidth = halfWidth * halves + _halfGap * (halves - 1);

        final grid = SizedBox(
          width: boardWidth,
          height: rows * rowPitch,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _GridPainter(
                    cell: cell,
                    rowPitch: rowPitch,
                    rows: rows,
                    halves: halves,
                    columns: BoardLayout.columnsPerHalf,
                    halfGap: _halfGap,
                  ),
                ),
              ),
              if (placements.isEmpty && emptyHint != null)
                Positioned.fill(child: Center(child: emptyHint)),
              for (final placement in placements)
                if (byId[placement.meldId] != null)
                  _positioned(
                    byId[placement.meldId]!,
                    placement,
                    cell,
                    rowPitch,
                    halfWidth,
                  ),
            ],
          ),
        );

        // Below the readable minimum the cell stops shrinking, so on a very
        // small viewport the board can be wider than the space it was given.
        // Scroll it sideways rather than clipping columns away silently.
        final overflows = boardWidth > constraints.maxWidth + 0.5;

        return SingleChildScrollView(
          child: overflows
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: grid,
                )
              : Center(child: grid),
        );
      },
    );
  }

  Widget _positioned(
    Meld meld,
    BoardPlacement placement,
    Size cell,
    double rowPitch,
    double halfWidth,
  ) {
    final left = placement.half * (halfWidth + _halfGap) +
        placement.column * cell.width;
    final focused = focusedMeldId == meld.id;
    final addable = addableMeldIds.contains(meld.id);
    final outline = focused
        ? OkeyPalette.brass
        : addable
            ? OkeyPalette.success
            : null;

    return Positioned(
      left: left,
      top: placement.row * rowPitch,
      width: cell.width * placement.length,
      height: cell.height,
      child: GestureDetector(
        onTap: onTapMeld == null ? null : () => onTapMeld!(meld.id),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: outline?.withValues(alpha: 0.18) ?? Colors.transparent,
            borderRadius: BorderRadius.circular(cell.width * 0.16),
            border: outline == null
                ? null
                : Border.all(color: outline, width: 1.5),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  for (var i = 0; i < meld.tiles.length; i++)
                    SizedBox(
                      width: cell.width,
                      height: cell.height,
                      child: GestureDetector(
                        onTap: onTapMeldTile == null
                            ? null
                            : () => onTapMeldTile!(meld.id, i),
                        child: Padding(
                          padding: const EdgeInsets.all(0.5),
                          child: TileWidget(
                            width: cell.width - 1,
                            tile: meld.tiles[i],
                            kind: meld.tiles[i].isFalseJoker
                                ? TileFaceKind.falseJoker
                                : _isOkey(meld.tiles[i])
                                    ? TileFaceKind.okey
                                    : TileFaceKind.normal,
                            colorblindGlyph:
                                colorblind && meld.tiles[i].color != null
                                    ? glyphFor?.call(meld.tiles[i].color!)
                                    : null,
                            highlighted: meld.jokerAssignments[i] != null,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // Owner stripe: who laid this meld, in the space a name label
              // could never fit into.
              Positioned(
                left: 2,
                right: 2,
                bottom: 0,
                height: 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: ownerColorOf(meld.ownerSeat),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The narrow panel to the right of the table, for pairs.
///
/// Pairs live apart from the runs and sets because a player on the pairs path
/// lays five to eleven of them, and mixed into the main grid they would swamp
/// it.
class PairsBoard extends StatelessWidget {
  const PairsBoard({
    required this.melds,
    required this.okey,
    required this.ownerColorOf,
    super.key,
    this.colorblind = false,
    this.glyphFor,
  });

  final List<Meld> melds;
  final TileIdentity okey;
  final Color Function(int seat) ownerColorOf;
  final bool colorblind;
  final String Function(TileColor)? glyphFor;

  static const double _minCell = 13;
  static const double _maxCell = 28;
  static const double _rowGap = 4;
  static const int _minRows = 3;

  bool _isOkey(Tile tile) =>
      !tile.isFalseJoker &&
      tile.color == okey.color &&
      tile.number == okey.number;

  @override
  Widget build(BuildContext context) {
    final pairs = melds.where((m) => m.kind == MeldKind.pair).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = (constraints.maxWidth / BoardLayout.pairColumns)
            .clamp(_minCell, _maxCell);
        final cell = Size(cellWidth, TileWidget.heightFor(cellWidth));
        final rowPitch = cell.height + _rowGap;

        final placements = BoardLayout.placePairs(pairs);
        final rowsUsed = BoardLayout.rowsUsed(placements);
        final byId = <int, Meld>{for (final meld in pairs) meld.id: meld};
        final width = cell.width * BoardLayout.pairColumns;

        return Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, gridConstraints) {
                  final gridRows = [
                    _minRows,
                    rowsUsed,
                    (gridConstraints.maxHeight / rowPitch).floor(),
                  ].reduce((a, b) => a > b ? a : b);
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: width,
                      height: gridRows * rowPitch,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _GridPainter(
                                cell: cell,
                                rowPitch: rowPitch,
                                rows: gridRows,
                                halves: 1,
                                columns: BoardLayout.pairColumns,
                              ),
                            ),
                          ),
                          for (final placement in placements)
                            if (byId[placement.meldId] != null)
                              Positioned(
                                left: placement.column * cell.width,
                                top: placement.row * rowPitch,
                                width: cell.width * 2,
                                height: cell.height,
                                child: Row(
                                  children: [
                                    for (final tile
                                        in byId[placement.meldId]!.tiles)
                                      Padding(
                                        padding: const EdgeInsets.all(0.5),
                                        child: TileWidget(
                                          width: cell.width - 1,
                                          tile: tile,
                                          kind: tile.isFalseJoker
                                              ? TileFaceKind.falseJoker
                                              : _isOkey(tile)
                                                  ? TileFaceKind.okey
                                                  : TileFaceKind.normal,
                                          colorblindGlyph:
                                              colorblind && tile.color != null
                                                  ? glyphFor?.call(tile.color!)
                                                  : null,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
