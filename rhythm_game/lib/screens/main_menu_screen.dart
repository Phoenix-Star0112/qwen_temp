import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/game_settings.dart';

/// Main menu screen with beautiful UI
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0A1A),
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              
              // Title
              const Text(
                'RHYTHM\nMASTER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  shadows: [
                    Shadow(
                      color: Color(0xFF00FFFF),
                      blurRadius: 20,
                    ),
                    Shadow(
                      color: Color(0xFFFF00FF),
                      blurRadius: 30,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
              ),
              
              const Spacer(flex: 1),
              
              // Subtitle
              Text(
                'Feel the Beat',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 4,
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Menu buttons
              _buildMenuButton(
                context,
                icon: Icons.play_arrow_rounded,
                label: 'PLAY',
                onPressed: () => Navigator.pushNamed(context, '/game'),
                primaryColor: const Color(0xFF00FFFF),
              ),
              
              const SizedBox(height: 20),
              
              _buildMenuButton(
                context,
                icon: Icons.music_note_rounded,
                label: 'SONGS',
                onPressed: () {},
                primaryColor: const Color(0xFFFF00FF),
              ),
              
              const SizedBox(height: 20),
              
              _buildMenuButton(
                context,
                icon: Icons.settings_rounded,
                label: 'SETTINGS',
                onPressed: () => _showSettingsDialog(context),
                primaryColor: const Color(0xFFFFFF00),
              ),
              
              const SizedBox(height: 20),
              
              _buildMenuButton(
                context,
                icon: Icons.emoji_events,
                label: 'RANKINGS',
                onPressed: () {},
                primaryColor: const Color(0xFFFF6B6B),
              ),
              
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color primaryColor,
  }) {
    return Container(
      width: 280,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.2),
            primaryColor.withOpacity(0.4),
          ],
        ),
        border: Border.all(
          color: primaryColor.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          splashColor: primaryColor.withOpacity(0.3),
          highlightColor: primaryColor.withOpacity(0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: primaryColor,
                size: 28,
              ),
              const SizedBox(width: 15),
              Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Consumer<GameSettings>(
        builder: (context, settings, child) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1A1A2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: const Color(0xFF00FFFF).withOpacity(0.3),
                width: 2,
              ),
            ),
            title: const Text(
              'SETTINGS',
              style: TextStyle(
                color: Color(0xFF00FFFF),
                fontSize: 24,
                letterSpacing: 2,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSliderSetting(
                    'Music Volume',
                    settings.musicVolume,
                    (value) => settings.setMusicVolume(value),
                    Icons.music_note,
                  ),
                  _buildSliderSetting(
                    'SFX Volume',
                    settings.sfxVolume,
                    (value) => settings.setSfxVolume(value),
                    Icons.volume_up,
                  ),
                  _buildSliderSetting(
                    'Scroll Speed',
                    settings.scrollSpeed,
                    (value) => settings.setScrollSpeed(value),
                    Icons.speed,
                    min: 0.5,
                    max: 2.0,
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Hit Effects',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: settings.showHitEffects,
                    onChanged: (_) => settings.toggleHitEffects(),
                    activeColor: const Color(0xFF00FFFF),
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Combo Display',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: settings.showComboDisplay,
                    onChanged: (_) => settings.toggleComboDisplay(),
                    activeColor: const Color(0xFF00FFFF),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  settings.resetToDefaults();
                },
                child: const Text(
                  'Reset to Defaults',
                  style: TextStyle(color: Color(0xFFFF6B6B)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'CLOSE',
                  style: TextStyle(color: Color(0xFF00FFFF)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildSliderSetting(
    String label,
    double value,
    Function(double) onChanged,
    IconData icon, {
    double min = 0.0,
    double max = 1.0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF00FFFF), size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            Text(
              value.toStringAsFixed(2),
              style: const TextStyle(
                color: Color(0xFF00FFFF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFF00FFFF),
            inactiveTrackColor: const Color(0xFF00FFFF).withOpacity(0.3),
            thumbColor: const Color(0xFFFF00FF),
            overlayColor: const Color(0xFFFF00FF).withOpacity(0.2),
            trackHeight: 6,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
