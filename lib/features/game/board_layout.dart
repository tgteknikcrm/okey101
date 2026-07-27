import 'package:okey101/domain/models/meld.dart';

/// Where one meld sits on the gridded table.
class BoardPlacement {
  const BoardPlacement({
    required this.meldId,
    required this.half,
    required this.row,
    required this.column,
    required this.length,
  });

  final int meldId;

  /// Which 13-column half of the board. Zero on a narrow screen, which shows
  /// only one half.
  final int half;
  final int row;

  /// First column within [half].
  final int column;
  final int length;

  @override
  String toString() =>
      'meld $meldId @ half $half row $row col $column len $length';
}

/// Lays melds out on a grid of tile-sized cells, the way a real okey table
/// works: a meld is a run of consecutive cells in ONE row and never wraps.
///
/// Placement is first-fit, left to right and top to bottom, with a one-cell gap
/// between melds sharing a row. It is a pure function of the meld list, so the
/// same table always draws the same way.
abstract final class BoardLayout {
  /// Columns in one half of the board.
  ///
  /// Thirteen is not arbitrary: the longest possible run is 1..13, so every
  /// legal meld is guaranteed to fit on a single row.
  static const int columnsPerHalf = 13;

  /// Columns in the pairs panel. Two means one pair to a row, which keeps the
  /// panel a narrow strip down the edge instead of a second table.
  static const int pairColumns = 2;

  /// Gap between two melds sharing a row, in cells.
  static const int gapCells = 1;

  /// Places the runs and sets. Pairs are laid out separately by [placePairs].
  static List<BoardPlacement> place(
    List<Meld> melds, {
    required int halves,
  }) {
    final placements = <BoardPlacement>[];
    // cursors[half][row] = first free column in that row.
    final cursors = List<List<int>>.generate(halves, (_) => <int>[]);

    for (final meld in melds) {
      if (meld.kind == MeldKind.pair) continue;
      final length = meld.tiles.length;
      if (length <= 0) continue;

      var placed = false;
      // First fit, scanning rows top to bottom and halves left to right, so a
      // meld drops into the first gap that takes it.
      final deepest =
          cursors.fold<int>(0, (m, c) => c.length > m ? c.length : m);
      for (var row = 0; row <= deepest && !placed; row++) {
        for (var half = 0; half < halves && !placed; half++) {
          if (row >= cursors[half].length) {
            cursors[half].add(0);
          }
          final cursor = cursors[half][row];
          if (cursor + length > columnsPerHalf) continue;
          placements.add(
            BoardPlacement(
              meldId: meld.id,
              half: half,
              row: row,
              column: cursor,
              length: length,
            ),
          );
          cursors[half][row] = cursor + length + gapCells;
          placed = true;
        }
      }

      if (!placed) {
        // Every existing row is full, so open a fresh one. The failed scan
        // above created row `deepest` in every half, so the next free row is
        // `deepest` itself when it is still empty and `deepest + 1` otherwise -
        // taking cursors[0].length here would leave a blank row behind.
        final row = cursors[0].isEmpty
            ? 0
            : (cursors[0].last == 0 ? cursors[0].length - 1 : cursors[0].length);
        for (final cursor in cursors) {
          while (cursor.length <= row) {
            cursor.add(0);
          }
        }
        // A meld longer than a half cannot be drawn without covering the
        // divider, so it is clamped rather than allowed to overlap its
        // neighbour. Only reachable if a table run is extended past 13, which
        // needs allowCircularRuns.
        final drawn = length > columnsPerHalf ? columnsPerHalf : length;
        placements.add(
          BoardPlacement(
            meldId: meld.id,
            half: 0,
            row: row,
            column: 0,
            length: drawn,
          ),
        );
        cursors[0][row] = drawn + gapCells;
      }
    }
    return placements;
  }

  /// Pairs go on their own panel: two tiles each, [pairColumns] / 2 to a row.
  static List<BoardPlacement> placePairs(List<Meld> melds) {
    final placements = <BoardPlacement>[];
    var index = 0;
    for (final meld in melds) {
      if (meld.kind != MeldKind.pair) continue;
      const perRow = pairColumns ~/ 2;
      placements.add(
        BoardPlacement(
          meldId: meld.id,
          half: 0,
          row: index ~/ perRow,
          column: (index % perRow) * 2,
          length: meld.tiles.length,
        ),
      );
      index++;
    }
    return placements;
  }

  /// Rows the placements actually occupy.
  static int rowsUsed(List<BoardPlacement> placements) {
    var rows = 0;
    for (final placement in placements) {
      if (placement.row + 1 > rows) rows = placement.row + 1;
    }
    return rows;
  }
}
