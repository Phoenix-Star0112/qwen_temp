import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'dart:math';

/// Audio manager for handling music and sound effects
class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  double _musicVolume = 0.8;
  double _sfxVolume = 0.6;
  bool _isMusicPlaying = false;
  String? _currentSong;

  // Synth parameters for procedural audio
  final Random _random = Random();

  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  bool get isMusicPlaying => _isMusicPlaying;
  String? get currentSong => _currentSong;

  /// Set music volume
  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    FlameAudio.bgm.audioPlayer.setVolume(_musicVolume);
  }

  /// Set SFX volume
  void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
  }

  /// Play background music
  Future<void> playMusic(String songPath) async {
    try {
      await FlameAudio.bgm.initialize();
      await FlameAudio.bgm.play(
        songPath,
        volume: _musicVolume,
      );
      _isMusicPlaying = true;
      _currentSong = songPath;
      debugPrint('Playing music: $songPath');
    } catch (e) {
      debugPrint('Error playing music: $e');
      // Fallback: Generate procedural beat
      _generateProceduralBeat();
    }
  }

  /// Stop background music
  Future<void> stopMusic() async {
    await FlameAudio.bgm.stop();
    _isMusicPlaying = false;
    _currentSong = null;
  }

  /// Pause background music
  Future<void> pauseMusic() async {
    await FlameAudio.bgm.pause();
    _isMusicPlaying = false;
  }

  /// Resume background music
  Future<void> resumeMusic() async {
    await FlameAudio.bgm.resume();
    _isMusicPlaying = true;
  }

  /// Play a hit sound effect based on result
  void playHitSound({required bool isPerfect}) {
    _playSynthSound(
      frequency: isPerfect ? 880.0 : 440.0,
      duration: 0.1,
      volume: _sfxVolume,
      waveType: isPerfect ? WaveType.sine : WaveType.square,
    );
  }

  /// Play a miss sound effect
  void playMissSound() {
    _playSynthSound(
      frequency: 150.0,
      duration: 0.2,
      volume: _sfxVolume * 0.5,
      waveType: WaveType.sawtooth,
    );
  }

  /// Play combo break sound
  void playComboBreakSound() {
    _playSynthSound(
      frequency: 300.0,
      duration: 0.3,
      volume: _sfxVolume * 0.7,
      waveType: WaveType.sawtooth,
    );
  }

  /// Play a UI click sound
  void playClickSound() {
    _playSynthSound(
      frequency: 600.0,
      duration: 0.05,
      volume: _sfxVolume * 0.4,
      waveType: WaveType.sine,
    );
  }

  /// Generate procedural beat when no music file is available
  Future<void> _generateProceduralBeat() async {
    debugPrint('Generating procedural beat...');
    // This creates a simple metronome-like beat
    final bpm = 120.0;
    final beatDuration = 60.0 / bpm;
    
    // Schedule beats
    for (int i = 0; i < 100; i++) {
      Future.delayed(Duration(milliseconds: (beatDuration * i * 1000).round()), () {
        if (_isMusicPlaying) {
          _playSynthSound(
            frequency: i % 4 == 0 ? 440.0 : 330.0,
            duration: 0.05,
            volume: _musicVolume * 0.3,
            waveType: WaveType.square,
          );
        }
      });
    }
  }

  /// Play a synthesized sound
  void _playSynthSound({
    required double frequency,
    required double duration,
    required double volume,
    required WaveType waveType,
  }) {
    // Note: For actual implementation, you would use a proper audio synthesis library
    // This is a placeholder that logs the sound parameters
    debugPrint(
      'Playing synth: ${frequency}Hz, ${duration}s, vol: $volume, wave: $waveType',
    );
  }

  /// Dispose audio resources
  void dispose() {
    FlameAudio.bgm.dispose();
  }
}

/// Wave type enumeration for synthesis
enum WaveType {
  sine,
  square,
  sawtooth,
  triangle,
}
