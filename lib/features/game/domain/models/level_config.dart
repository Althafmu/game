class LevelConfig {
  final int id;
  final int initialRowsFilled; // 3 or 4
  final int columns; // e.g., 9
  final int maxRows; // e.g., 10..12
  final int timeLimitSeconds; // 120
  final int addRowBatchSize; // 1..2
  final int seed;

  const LevelConfig({
    required this.id,
    required this.initialRowsFilled,
    required this.columns,
    required this.maxRows,
    required this.timeLimitSeconds,
    required this.addRowBatchSize,
    required this.seed,
  });
}
