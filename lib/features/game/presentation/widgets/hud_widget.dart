import 'package:flutter/material.dart';
import '../../application/game_state.dart';

class HudWidget extends StatelessWidget {
  final int secondsLeft;
  final int remaining;
  final GamePhase phase;
  final VoidCallback onRestart;

  const HudWidget({
    super.key,
    required this.secondsLeft,
    required this.remaining,
    required this.phase,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    String mm = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    String ss = (secondsLeft % 60).toString().padLeft(2, '0');
    final status = switch (phase) {
      GamePhase.playing => 'Playing',
      GamePhase.won => 'You Win!',
      GamePhase.lost => 'Time Up!',
    };

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Remaining: $remaining',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: onRestart,
                child: const Text('Restart'),
              ),
            ],
          ),
          Text(
            'Time: $mm:$ss',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 16,
              color: phase == GamePhase.playing
                  ? Colors.black87
                  : Colors.indigo,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
