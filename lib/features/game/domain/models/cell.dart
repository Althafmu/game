class Cell {
  final int id;
  final int value; // 1..9
  final int row;
  final int col;
  final bool matched;

  Cell({
    required this.id,
    required this.value,
    required this.row,
    required this.col,
    this.matched = false,
  });

  Cell copyWith({bool? matched, int? row, int? col}) => Cell(
    id: id,
    value: value,
    row: row ?? this.row,
    col: col ?? this.col,
    matched: matched ?? this.matched,
  );
}
