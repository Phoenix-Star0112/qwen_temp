import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/game_screen.dart';
import 'screens/main_menu_screen.dart';
import 'utils/game_constants.dart';
import 'utils/game_settings.dart';

void main() {
  runApp(const RhythmGameApp());
}

class RhythmGameApp extends StatelessWidget {
  const RhythmGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameSettings()),
        ChangeNotifierProvider(create: (_) => ScoreManager()),
      ],
      child: MaterialApp(
        title: 'Rhythm Master',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: const Color(0xFF00FFFF),
          scaffoldBackgroundColor: const Color(0xFF0A0A1A),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00FFFF),
            secondary: Color(0xFFFF00FF),
            surface: Color(0xFF1A1A2E),
          ),
        ),
        home: const MainMenuScreen(),
        routes: {
          '/game': (context) => const GameScreen(),
        },
      ),
    );
  }
}
