import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/level_config.dart';
import 'game_controller.dart';
import 'game_state.dart';

final levelListProvider = Provider<List<LevelConfig>>((ref) => const [
  LevelConfig(id: 1, initialRowsFilled: 3, columns: 9, maxRows: 10, timeLimitSeconds: 120, addRowBatchSize: 1, seed: 101),
  LevelConfig(id: 2, initialRowsFilled: 4, columns: 9, maxRows: 11, timeLimitSeconds: 120, addRowBatchSize: 1, seed: 202),
  LevelConfig(id: 3, initialRowsFilled: 4, columns: 9, maxRows: 12, timeLimitSeconds: 120, addRowBatchSize: 2, seed: 303),
]);

final selectedLevelProvider = StateProvider<int>((ref) => 1);

final levelConfigProvider = Provider<LevelConfig>((ref) {
  final id = ref.watch(selectedLevelProvider);
  final list = ref.watch(levelListProvider);
  return list.firstWhere((e) => e.id == id);
});

final gameControllerProvider = StateNotifierProvider<GameController, GameState>((ref) {
  final level = ref.watch(levelConfigProvider);
  return GameController(level);
});
