/// Game constants for the rhythm game
class GameConstants {
  // Lane configuration
  static const int laneCount = 4;
  static const double laneWidth = 80.0;
  static const double hitLineY = 100.0;
  static const double spawnY = -200.0;
  
  // Note types
  static const int noteTypeTap = 0;
  static const int noteTypeHold = 1;
  static const int noteTypeSlide = 2;
  
  // Timing windows (in milliseconds)
  static const double perfectWindow = 50.0;
  static const double greatWindow = 100.0;
  static const double goodWindow = 150.0;
  static const double missWindow = 200.0;
  
  // Scoring
  static const int perfectScore = 300;
  static const int greatScore = 100;
  static const int goodScore = 50;
  static const int missScore = 0;
  static const int comboMultiplier = 10;
  
  // Speed
  static const double baseScrollSpeed = 400.0;
  static const double maxScrollSpeed = 800.0;
  
  // Audio
  static const double audioLatency = 0.0; // Adjust based on device
  static const String defaultSong = 'assets/music/demo_song.mp3';
}

/// Hit result enumeration
enum HitResult {
  perfect,
  great,
  good,
  miss,
  none,
}

/// Game state enumeration
enum GameState {
  menu,
  playing,
  paused,
  gameOver,
}
