import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/game_providers.dart';
import '../../application/game_state.dart';
import '../widgets/hud_widget.dart';
import '../widgets/grid_view_widget.dart';
import '../widgets/add_row_button.dart';

class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Level ${state.level.id}')),
      body: Column(
        children: [
          HudWidget(
            secondsLeft: state.secondsLeft,
            remaining: state.remaining,
            phase: state.phase,
            onRestart: () => controller.restart(state.level),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridViewWidget(
                grid: state.grid,
                selected: state.firstSelected,
                onTap: controller.onCellTap,
              ),
            ),
          ),
          AddRowButton(
            enabled: state.phase == GamePhase.playing,
            onPressed: controller.addRow,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
