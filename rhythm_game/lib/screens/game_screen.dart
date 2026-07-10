import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import '../screens/rhythm_game.dart';
import '../models/note.dart';
import '../models/score_manager.dart';
import '../utils/game_settings.dart';

/// Game screen with HUD and Flame game widget
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late RhythmGame game;
  late ScoreManager scoreManager;
  
  @override
  void initState() {
    super.initState();
    game = RhythmGame();
    scoreManager = ScoreManager();
    
    // Create a demo chart
    final demoChart = _createDemoChart();
    game.initializeGame(demoChart, scoreManager);
    
    // Start the game after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        game.startGame();
      }
    });
  }
  
  Chart _createDemoChart() {
    final notes = <Note>[];
    
    // Create a simple pattern for demonstration
    for (int i = 0; i < 50; i++) {
      final time = 2.0 + (i * 0.5); // Notes every 0.5 seconds
      final lane = (i % 4); // Cycle through lanes
      final type = (i % 3 == 0) ? 1 : 0; // Every 3rd note is a hold note
      
      notes.add(Note(
        lane: lane,
        time: time,
        type: type,
        endTime: type == 1 ? time + 0.5 : null,
      ));
    }
    
    return Chart(
      songId: 'demo_001',
      songTitle: 'Demo Track',
      artist: 'Rhythm Master',
      duration: 30.0,
      notes: notes,
      difficulty: 3,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Flame game widget
          GameWidget(
            game: game,
          ),
          
          // HUD overlay
          SafeArea(
            child: Column(
              children: [
                // Top HUD
                _buildTopHUD(),
                
                const Spacer(),
                
                // Bottom controls
                _buildBottomControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTopHUD() {
    return Consumer<ScoreManager>(
      builder: (context, score, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Score
              _buildHUDItem(
                icon: Icons.star_rounded,
                label: 'SCORE',
                value: score.score.toString().padLeft(7, '0'),
                color: const Color(0xFF00FFFF),
              ),
              
              // Combo
              _buildHUDItem(
                icon: Icons.flash_on_rounded,
                label: 'COMBO',
                value: '${score.combo}x',
                color: const Color(0xFFFF00FF),
                showMax: true,
                maxValue: score.maxCombo,
              ),
              
              // Accuracy
              _buildHUDItem(
                icon: Icons.percent,
                label: 'ACCURACY',
                value: '${score.accuracy.toStringAsFixed(2)}%',
                color: const Color(0xFFFFFF00),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildHUDItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool showMax = false,
    int? maxValue,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.7),
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          if (showMax && maxValue != null && maxValue > 0) ...[
            Text(
              '(MAX: ${maxValue}x)',
              style: TextStyle(
                color: color.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pause button
          IconButton(
            onPressed: () {
              if (game.isPlaying) {
                game.pauseGame();
                _showPauseMenu();
              } else {
                game.resumeGame();
                Navigator.pop(context);
              }
            },
            icon: Icon(
              game.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 32,
            ),
            color: Colors.white,
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(15),
            ),
          ),
          
          const SizedBox(width: 20),
          
          // Hit statistics
          Consumer<ScoreManager>(
            builder: (context, score, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHitStat('PERFECT', score.perfectCount, const Color(0xFF00FFFF)),
                    const SizedBox(width: 15),
                    _buildHitStat('GREAT', score.greatCount, const Color(0xFF00FF00)),
                    const SizedBox(width: 15),
                    _buildHitStat('GOOD', score.goodCount, const Color(0xFFFFFF00)),
                    const SizedBox(width: 15),
                    _buildHitStat('MISS', score.missCount, const Color(0xFFFF0000)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildHitStat(String label, int count, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count.toString().padLeft(3, '0'),
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.7),
            fontSize: 8,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
  
  void _showPauseMenu() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: const Color(0xFF00FFFF).withOpacity(0.3),
            width: 2,
          ),
        ),
        title: const Text(
          'PAUSED',
          style: TextStyle(
            color: Color(0xFF00FFFF),
            fontSize: 32,
            letterSpacing: 5,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPauseButton(
              icon: Icons.play_arrow_rounded,
              label: 'RESUME',
              color: const Color(0xFF00FFFF),
              onPressed: () {
                game.resumeGame();
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10),
            _buildPauseButton(
              icon: Icons.replay_rounded,
              label: 'RETRY',
              color: const Color(0xFFFF00FF),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  game = RhythmGame();
                  scoreManager = ScoreManager();
                  final demoChart = _createDemoChart();
                  game.initializeGame(demoChart, scoreManager);
                });
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    game.startGame();
                  }
                });
              },
            ),
            const SizedBox(height: 10),
            _buildPauseButton(
              icon: Icons.exit_to_app_rounded,
              label: 'QUIT',
              color: const Color(0xFFFF6B6B),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPauseButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.4),
          ],
        ),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    game.dispose();
    super.dispose();
  }
}
