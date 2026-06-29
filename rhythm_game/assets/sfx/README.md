# SFX Directory (Alternative)

This is an alternative directory for sound effects.
Both `assets/sounds/` and `assets/sfx/` are configured in pubspec.yaml.

## Usage
Use this directory for:
- Short sound effects (< 1 second)
- Looping ambient sounds
- Voice lines or announcements

## File Organization
Organize by category:
```
sfx/
├── hits/
│   ├── perfect.wav
│   ├── great.wav
│   └── good.wav
├── ui/
│   ├── click.wav
│   └── select.wav
└── events/
    ├── combo_break.wav
    └── complete.wav
```

## Current Status
The game uses procedural audio synthesis, so no files are required.
Add your custom SFX here if desired!
