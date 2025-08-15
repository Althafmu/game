import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/game_providers.dart';
import 'game_page.dart';

class LevelSelectPage extends ConsumerWidget {
  const LevelSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levels = ref.watch(levelListProvider);
    final selected = ref.watch(selectedLevelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Level')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 12,
              children: levels.map((lvl) {
                final isSel = selected == lvl.id;
                return ChoiceChip(
                  label: Text('Level ${lvl.id}'),
                  selected: isSel,
                  onSelected: (_) => ref.read(selectedLevelProvider.notifier).state = lvl.id,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const GamePage()));
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
