import 'package:flutter/material.dart';
import 'features/game/presentation/pages/level_select_page.dart';
import 'core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Match',
      theme: AppTheme.light,
      home: const LevelSelectPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
