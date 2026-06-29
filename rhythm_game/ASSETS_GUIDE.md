# 🎵 Asset Guide for Rhythm Master

This guide explains how to add your own assets to enhance the rhythm game experience.

## Directory Structure

```
assets/
├── music/          # Background music tracks
├── images/         # Visual sprites and backgrounds
├── sounds/         # Sound effects (SFX)
└── sfx/            # Alternative SFX directory
```

---

## 🎼 Adding Music

### Supported Formats
- `.mp3` (recommended)
- `.ogg` (better compression)
- `.wav` (uncompressed, larger files)

### How to Add
1. Place your music file in `assets/music/`
2. Name it descriptively (e.g., `electronic_beat.mp3`, `piano_sonata.ogg`)
3. Update the chart data in your code to reference the new track

### Recommended BPM Range
- Easy: 80-120 BPM
- Normal: 120-150 BPM
- Hard: 150-180+ BPM

---

## 🖼️ Adding Images

### Required Dimensions
| Asset | Recommended Size | Format |
|-------|-----------------|--------|
| background.png | 1920x1080 | PNG |
| lane_bg.png | 200x1920 | PNG |
| hit_line.png | 800x10 | PNG |
| note_hit.png | 100x100 | PNG |
| menu_background.png | 1920x1080 | PNG |

### Optional Assets
- `note_tap.png` - Tap note sprite
- `note_hold.png` - Hold note sprite
- `note_slide.png` - Slide note sprite
- `combo_effect.png` - Combo burst effect
- `rank_SS.png` through `rank_D.png` - Rank icons

### Transparency
All PNG images should have transparent backgrounds where appropriate.

---

## 🔊 Adding Sound Effects

### Essential SFX
| File Name | Description | Duration |
|-----------|-------------|----------|
| tap.mp3 | Basic note hit | 0.1-0.2s |
| perfect.mp3 | Perfect timing bonus | 0.2-0.3s |
| combo_break.mp3 | Combo reset sound | 0.3-0.5s |
| menu_select.mp3 | Menu navigation | 0.1s |
| menu_confirm.mp3 | Menu selection confirm | 0.15s |

### Audio Specifications
- Sample Rate: 44.1kHz or 48kHz
- Bit Depth: 16-bit
- Channels: Mono or Stereo
- Format: MP3 (128kbps+) or OGG

---

## 🎹 Creating Custom Charts

Charts define when notes appear. The game uses a JSON-based chart system.

### Chart Format Example
```json
{
  "songName": "My Awesome Track",
  "artist": "Your Name",
  "bpm": 128,
  "offset": 0.5,
  "notes": [
    {"time": 1.0, "lane": 0, "type": "tap"},
    {"time": 1.5, "lane": 1, "type": "tap"},
    {"time": 2.0, "lane": 2, "type": "hold", "duration": 0.5},
    {"time": 2.5, "lane": 3, "type": "slide"}
  ]
}
```

### Lane Mapping
- Lane 0: Leftmost (D key)
- Lane 1: Center-left (F key)
- Lane 2: Center-right (J key)
- Lane 3: Rightmost (K key)

### Note Types
- `tap`: Single tap note
- `hold`: Hold/sustain note
- `slide`: Slide/move note

---

## 🛠️ Testing Your Assets

1. Add your asset files to the appropriate directory
2. Run `flutter pub get` to register new assets
3. Hot reload or restart the app
4. Test in-game to verify timing and quality

---

## 💡 Pro Tips

1. **Music Sync**: Use audio editing software (Audacity, FL Studio) to determine exact BPM and offset
2. **Optimization**: Compress images with tools like TinyPNG before adding
3. **Audio Levels**: Normalize SFX to -6dB to -3dB for consistent volume
4. **Testing**: Test on actual devices, not just emulators, for accurate timing
5. **Fallbacks**: The game works without custom assets using procedural generation

---

## 📦 Free Asset Resources

### Music (Royalty-Free)
- [OpenGameArt](https://opengameart.org/)
- [Incompetech](https://incompetech.com/)
- [Bensound](https://www.bensound.com/)

### Sound Effects
- [Freesound](https://freesound.org/)
- [Kenney.nl SFX](https://kenney.nl/assets/category:Audio)
- [BFXR](https://www.bfxr.net/) (generate 8-bit SFX)

### Images
- [Kenney.nl](https://kenney.nl/)
- [OpenGameArt](https://opengameart.org/)
- [Itch.io Game Assets](https://itch.io/game-assets)

---

## 🐛 Troubleshooting

**Assets not loading?**
- Run `flutter clean && flutter pub get`
- Check file paths are correct in pubspec.yaml
- Ensure file names match exactly (case-sensitive)

**Audio out of sync?**
- Adjust the `offset` value in your chart data
- Check that BPM is accurate
- Try converting to OGG format for better timing

**Images too large?**
- Resize to recommended dimensions
- Use PNG compression tools
- Consider using texture atlases for multiple sprites

---

Enjoy creating your rhythm game masterpiece! 🎮🎵
