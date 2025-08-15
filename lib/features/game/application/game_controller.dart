import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/features/game/domain/models/cell.dart';
import 'package:game/features/game/domain/models/level_config.dart';
import 'package:game/features/game/domain/services/move_finder.dart';
import 'package:game/features/game/domain/services/rule_engine.dart';
import 'game_state.dart';

class GameController extends StateNotifier<GameState> {
  GameController(LevelConfig level) : super(_initial(level)) {
    _startTimer();
  }

  static GameState _initial(LevelConfig level) {
    final grid = _generateInitialGrid(level);
    final remaining = _countUnmatched(grid);
    return GameState(
      level: level,
      grid: grid,
      firstSelected: null,
      remaining: remaining,
      secondsLeft: level.timeLimitSeconds,
      phase: GamePhase.playing,
    );
  }

  static int _idSeq = 0;
  static List<List<Cell?>> _generateInitialGrid(LevelConfig level) {
    final cols = level.columns;
    final rows = level.maxRows;
    final rng = Random(level.seed);
    final grid = List.generate(rows, (r) => List<Cell?>.filled(cols, null, growable: false));

    final initialRows = level.initialRowsFilled;
    for (int r = 0; r < initialRows; r++) {
      for (int c = 0; c < cols; c++) {
        final val = 1 + rng.nextInt(9);
        grid[r][c] = Cell(id: _idSeq++, value: val, row: r, col: c);
      }
    }
    return grid;
  }

  static int _countUnmatched(List<List<Cell?>> grid) {
    int cnt = 0;
    for (final row in grid) {
      for (final cell in row) {
        if (cell != null && !cell.matched) cnt++;
      }
    }
    return cnt;
  }

  void onCellTap(Cell cell) {
    if (state.phase != GamePhase.playing) return;
    if (cell.matched) return;

    final first = state.firstSelected;
    if (first == null) {
      state = state.copyWith(firstSelected: cell);
      return;
    }
    if (first.id == cell.id) {
      // deselect
      state = state.copyWith(clearFirstSelected: true);
      return;
    }

    final canConnect = MoveFinder.connectable(state.grid, first, cell);
    final validPair = RuleEngine.isPairValid(first, cell);

    if (canConnect && validPair) {
      _applyMatch(first, cell);
    } else {
      // trigger invalid feedback via UI flags if desired
      state = state.copyWith(clearFirstSelected: true);
    }
  }

  void _applyMatch(Cell a, Cell b) {
    final g = state.grid.map((row) => row.toList()).toList();
    g[a.row][a.col] = a.copyWith(matched: true);
    g[b.row][b.col] = b.copyWith(matched: true);

    final remaining = state.remaining - 2;
    final phase = remaining == 0 ? GamePhase.won : GamePhase.playing;

    state = state.copyWith(grid: g, remaining: remaining, clearFirstSelected: true, phase: phase);
  }

  void addRow() {
    if (state.phase != GamePhase.playing) return;
    final g = state.grid.map((row) => row.toList()).toList();
    final rng = Random(state.level.seed + state.secondsLeft);
    int added = 0;

    for (int k = 0; k < state.level.addRowBatchSize; k++) {
      final inserted = _appendRow(g, rng);
      if (!inserted) break;
      added++;
    }
    if (added > 0) {
      state = state.copyWith(grid: g, remaining: _countUnmatched(g));
    }
  }

  bool _appendRow(List<List<Cell?>> grid, Random rng) {
    // Find the first completely empty row from bottom to place numbers?
    // We will add a new row after the last non-null row if within maxRows.
    // Shift is not required; we just fill the next empty row index.
    int targetRow = -1;
    for (int r = 0; r < grid.length; r++) {
      final row = grid[r];
      final any = row.any((e) => e != null);
      if (!any) { targetRow = r; break; }
    }
    if (targetRow == -1) return false;

    for (int c = 0; c < grid[targetRow].length; c++) {
      final val = 1 + rng.nextInt(9);
      grid[targetRow][c] = Cell(id: _idSeq++, value: val, row: targetRow, col: c);
    }
    return true;
  }

  void _startTimer() async {
    // simple ticker
    while (mounted && state.phase == GamePhase.playing && state.secondsLeft > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) break;
      if (state.phase != GamePhase.playing) break;
      final next = state.secondsLeft - 1;
      final nextPhase = next <= 0 && state.remaining > 0 ? GamePhase.lost : state.phase;
      state = state.copyWith(secondsLeft: next, phase: nextPhase);
    }
  }

  void restart(LevelConfig level) {
    state = _initial(level);
    _startTimer();
  }
}
