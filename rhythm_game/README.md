# Rhythm Master - Flutter Flame Rhythm Game

A high-quality rhythm game built with Flutter and the Flame game engine.

## Features

### Core Gameplay
- **4-Lane Rhythm System**: Classic 4-lane note highway with precise timing
- **Multiple Note Types**: 
  - Tap notes (cyan)
  - Hold notes (magenta)
  - Slide notes (yellow)
- **Precision Timing Windows**:
  - Perfect: ±50ms (300 points)
  - Great: ±100ms (100 points)
  - Good: ±150ms (50 points)
  - Miss: ±200ms (0 points, breaks combo)
- **Combo System**: Build combos for bonus points
- **Accuracy Tracking**: Real-time accuracy calculation

### Visual Features
- **Neon Cyberpunk Aesthetic**: Beautiful gradient backgrounds and glowing effects
- **Dynamic Hit Effects**: Expanding ring effects on successful hits
- **Smooth Animations**: Fluid note scrolling and visual feedback
- **Customizable HUD**: Score, combo, and accuracy displays

### Audio Features
- **Music Volume Control**: Adjustable background music volume
- **SFX Volume Control**: Separate sound effects volume
- **Scroll Speed Adjustment**: Customize note speed (0.5x - 2.0x)

### UI/UX
- **Beautiful Main Menu**: Gradient backgrounds with glowing buttons
- **Settings Panel**: In-game settings with real-time adjustments
- **Pause Menu**: Resume, retry, or quit options
- **Hit Statistics**: Real-time perfect/great/good/miss counters

## Project Structure

```
rhythm_game/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   ├── note.dart                # Note and Chart models
│   │   └── score_manager.dart       # Score tracking logic
│   ├── screens/
│   │   ├── main_menu_screen.dart    # Main menu UI
│   │   ├── game_screen.dart         # Game screen with HUD
│   │   └── rhythm_game.dart         # Flame game implementation
│   └── utils/
│       ├── game_constants.dart      # Game configuration
│       └── game_settings.dart       # User settings
├── assets/
│   ├── music/                       # Background music files
│   ├── images/                      # Image assets
│   └── sounds/                      # Sound effect files
└── pubspec.yaml                     # Dependencies
```

## Getting Started

### Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher

### Installation

1. Clone or navigate to the project directory:
```bash
cd rhythm_game
```

2. Install dependencies:
```bash
flutter pub get
```

3. Add your music files to `assets/music/` directory

4. Run the game:
```bash
flutter run
```

## Dependencies

- **flame**: ^1.18.0 - Game engine for Flutter
- **flame_audio**: ^2.10.2 - Audio support for Flame
- **audioplayers**: ^6.0.0 - Audio playback
- **provider**: ^6.1.2 - State management
- **google_fonts**: ^6.2.1 - Custom fonts

## How to Play

1. **Start the Game**: Press PLAY from the main menu
2. **Watch the Notes**: Notes will scroll from top to bottom
3. **Tap in Time**: Tap the corresponding lane when a note reaches the hit line
4. **Build Combos**: Hit notes consecutively for bonus points
5. **Achieve High Accuracy**: Aim for PERFECT judgments

## Controls

- **Lane 1**: Left side of screen
- **Lane 2**: Center-left
- **Lane 3**: Center-right
- **Lane 4**: Right side of screen

## Scoring System

| Judgment | Timing Window | Base Points | Combo Bonus |
|----------|--------------|-------------|-------------|
| PERFECT  | ±50ms        | 300         | Yes         |
| GREAT    | ±100ms       | 100         | Yes         |
| GOOD     | ±150ms       | 50          | Yes         |
| MISS     | ±200ms       | 0           | No (resets) |

## Rank System

- **SS**: 95%+ accuracy with Full Combo
- **S**: 90%+ accuracy
- **A**: 80%+ accuracy
- **B**: 70%+ accuracy
- **C**: 60%+ accuracy
- **D**: Below 60%

## Customization

Access settings from the main menu to customize:
- Music volume (0-100%)
- SFX volume (0-100%)
- Scroll speed (0.5x - 2.0x)
- Toggle hit effects
- Toggle combo display

## Future Enhancements

Potential features to add:
- Song selection screen with multiple tracks
- Custom song import
- Online leaderboards
- Skin customization
- Additional game modes (2-lane, 6-lane, 8-lane)
- Story mode
- Achievement system
- Replay system

## License

This project is open source and available for educational purposes.

## Credits

Built with ❤️ using Flutter and Flame Engine
