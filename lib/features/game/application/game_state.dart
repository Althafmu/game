import 'package:equatable/equatable.dart';
import 'package:game/features/game/domain/models/cell.dart';
import 'package:game/features/game/domain/models/level_config.dart';

enum GamePhase { playing, won, lost }

class GameState extends Equatable {
  final LevelConfig level;
  final List<List<Cell?>> grid;
  final Cell? firstSelected;
  final int remaining; // unmatched count
  final int secondsLeft;
  final GamePhase phase;

  const GameState({
    required this.level,
    required this.grid,
    required this.firstSelected,
    required this.remaining,
    required this.secondsLeft,
    required this.phase,
  });

  GameState copyWith({
    List<List<Cell?>>? grid,
    Cell? firstSelected,
    bool clearFirstSelected = false,
    int? remaining,
    int? secondsLeft,
    GamePhase? phase,
  }) => GameState(
    level: level,
    grid: grid ?? this.grid,
    firstSelected: clearFirstSelected ? null : (firstSelected ?? this.firstSelected),
    remaining: remaining ?? this.remaining,
    secondsLeft: secondsLeft ?? this.secondsLeft,
    phase: phase ?? this.phase,
  );

  @override
  List<Object?> get props => [level, grid, firstSelected?.id, remaining, secondsLeft, phase];
}
