import '../models/cell.dart';

class MoveFinder {
  // Determine if two cells are connectable by:
  // horizontal, vertical, diagonal, or across end-of-line to next line,
  // allowing traversal through empty cells.
  static bool connectable(List<List<Cell?>> grid, Cell a, Cell b) {
    // normalize order
    if (a.row > b.row || (a.row == b.row && a.col > b.col)) {
      final tmp = a; a = b; b = tmp;
    }

    // Check row/col/diag straight paths with gaps allowed as long as no blocking unmatched cell lies directly in the path.
    bool pathClear(List<(int r, int c)> points) {
      for (final p in points) {
        final cell = grid[p.$1][p.$2];
        if (cell != null && !cell.matched && !(cell.id == a.id || cell.id == b.id)) {
          return false;
        }
      }
      return true;
    }

    // Same row
    if (a.row == b.row) {
      final points = <(int,int)>[];
      for (int c = a.col + 1; c < b.col; c++) {
        points.add((a.row, c));
      }
      return pathClear(points);
    }

    // Same column
    if (a.col == b.col) {
      final points = <(int,int)>[];
      for (int r = a.row + 1; r < b.row; r++) {
        points.add((r, a.col));
      }
      return pathClear(points);
    }

    // Diagonal (45°)
    if ((b.row - a.row).abs() == (b.col - a.col).abs()) {
      final points = <(int,int)>[];
      final stepR = (b.row > a.row) ? 1 : -1;
      final stepC = (b.col > a.col) ? 1 : -1;
      int r = a.row + stepR;
      int c = a.col + stepC;
      while (r != b.row && c != b.col) {
        points.add((r, c));
        r += stepR; c += stepC;
      }
      return pathClear(points);
    }

    // Across end-of-line to beginning of next lines:
    // We simulate reading order path: (a.row,a.col+1)->(a.row,end),
    // then subsequent rows fully, then (b.row,0)->(b.row,b.col-1).
    if (a.row <= b.row) {
      final points = <(int,int)>[];
      // end of a.row
      for (int c = a.col + 1; c < grid[a.row].length; c++) {
        points.add((a.row, c));
      }
      // middle full rows
      for (int r = a.row + 1; r < b.row; r++) {
        for (int c = 0; c < grid[r].length; c++) {
          points.add((r, c));
        }
      }
      // beginning of b.row
      for (int c = 0; c < b.col; c++) {
        points.add((b.row, c));
      }
      return pathClear(points);
    }

    return false;
  }
}
