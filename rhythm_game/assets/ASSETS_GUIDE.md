# Rhythm Game Assets Guide

## Overview
This rhythm game is designed to work **out of the box** with procedural graphics and audio synthesis. No external assets are required to play!

However, you can enhance the experience by adding your own custom assets.

---

## 🎵 Music Assets (`assets/music/`)

### Adding Music
1. Place MP3, OGG, or WAV files in `assets/music/`
2. Create a chart file defining note patterns
3. Reference the song in your game code

### Demo Mode
When no music file is found, the game generates a procedural beat automatically.

### Free Music Sources
- [Free Music Archive](https://freemusicarchive.org/)
- [Incompetech](Kevin MacLeod)](https://incompetech.com/music/)
- [Bensound](https://www.bensound.com/)
- [OpenGameArt](https://opengameart.org/)

---

## 🖼️ Image Assets (`assets/images/`)

### Current Implementation
The game uses **procedural rendering** with Flutter Canvas:
- ✅ Neon gradient backgrounds
- ✅ Glowing note components  
- ✅ Animated hit effects
- ✅ Dynamic lane dividers

### Optional Customization
You can add:
- Custom backgrounds
- Note skins
- UI elements
- Character sprites

---

## 🔊 Sound Effects (`assets/sounds/` & `assets/sfx/`)

### Current Implementation
The game includes **procedural audio synthesis**:
- ✅ Hit sounds (perfect/great/good/miss)
- ✅ Combo break effects
- ✅ UI click sounds
- ✅ Fallback metronome

### Optional Custom SFX
Add files for:
- `hit_perfect.wav`
- `hit_great.wav`
- `hit_good.wav`
- `hit_miss.wav`
- `ui_click.wav`
- `combo_break.wav`

---

## 📊 Creating Custom Charts

Charts define note patterns for songs. Example:

```dart
Chart(
  songId: 'my_song_001',
  songTitle: 'My Awesome Track',
  artist: 'Artist Name',
  duration: 180.0, // seconds
  notes: [
    Note(lane: 0, time: 2.0, type: 0), // Tap note
    Note(lane: 1, time: 2.5, type: 0),
    Note(lane: 2, time: 3.0, type: 1), // Hold note
    Note(lane: 3, time: 3.5, type: 2), // Slide note
  ],
  difficulty: 5,
)
```

### Note Types
- `type: 0` - Tap (blue)
- `type: 1` - Hold (magenta)
- `type: 2` - Slide (yellow)

---

## 🎮 File Structure

```
rhythm_game/
├── assets/
│   ├── music/          # Background music
│   │   └── README.md
│   ├── images/         # Visual assets (optional)
│   │   └── README.md
│   ├── sounds/         # Sound effects
│   │   └── README.md
│   └── sfx/            # Alternative SFX folder
│       └── README.md
├── lib/
│   ├── audio/          # Audio management
│   ├── components/     # Game components
│   ├── models/         # Data models
│   ├── screens/        # UI screens
│   └── utils/          # Constants & settings
└── pubspec.yaml        # Asset configuration
```

---

## ⚙️ Configuration

### pubspec.yaml
Assets are already configured:
```yaml
flutter:
  assets:
    - assets/music/
    - assets/images/
    - assets/sounds/
    - assets/sfx/
```

### Audio Settings
Adjust in-game via Settings menu:
- Music Volume (0-100%)
- SFX Volume (0-100%)
- Scroll Speed (0.5x - 2.0x)

---

## 🚀 Quick Start

1. **Play immediately** - No assets needed!
2. **Add music** - Drop MP3 files in `assets/music/`
3. **Create charts** - Define note patterns
4. **Customize** - Add images and SFX (optional)

---

## 🛠️ Troubleshooting

### Music not playing?
- Check file format (MP3/OGG/WAV)
- Verify file is in `assets/music/`
- Run `flutter pub get`
- Check volume settings

### Assets not loading?
- Run `flutter clean && flutter pub get`
- Check pubspec.yaml indentation
- Restart the app completely

### Performance issues?
- Use compressed audio (OGG recommended)
- Optimize image sizes
- Reduce scroll speed on slower devices

---

## 📝 License Notes

When adding assets:
- ✅ Use royalty-free music
- ✅ Check Creative Commons licenses
- ✅ Attribute artists when required
- ❌ Don't use copyrighted material without permission

---

Enjoy creating your rhythm game! 🎶✨
