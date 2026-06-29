# Sound Effects (SFX) Assets

## Supported Formats
- WAV (.wav) - Recommended for SFX
- OGG (.ogg) - Good compression
- MP3 (.mp3) - Universal support

## Sound Effect Types

### Hit Sounds
- `hit_perfect.wav` - Perfect timing feedback
- `hit_great.wav` - Great timing feedback  
- `hit_good.wav` - Good timing feedback
- `hit_miss.wav` - Miss feedback

### UI Sounds
- `ui_click.wav` - Button press
- `ui_select.wav` - Menu navigation
- `ui_confirm.wav` - Selection confirmed

### Game Events
- `combo_break.wav` - Combo reset
- `song_complete.wav` - Song finished
- `rank_achieved.wav` - New rank unlocked

## Current Implementation
The game includes **procedural sound synthesis** via the AudioManager:
- Synthesized hit sounds based on timing
- Procedural combo break effects
- UI click sounds
- Fallback metronome beat when no music is present

No external SFX files are required!

## Adding Custom SFX (Optional)
1. Add your sound files to this directory
2. Update the AudioManager to load custom sounds
3. Replace procedural sounds with file playback

## Recommended Specifications
- Sample Rate: 44.1kHz or 48kHz
- Bit Depth: 16-bit
- Format: Mono for SFX, Stereo for music
- Duration: Keep SFX under 1 second for responsiveness
