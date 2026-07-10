# Game Components

This directory contains reusable Flame game components.

## Current Components (in screens/rhythm_game.dart)

The following components are defined in `rhythm_game.dart`:

### LaneComponent
Renders individual lanes with alternating colors and dividers.

### HitLineComponent  
Draws the glowing hit line where notes should be tapped.

### NoteComponent
Visual representation of notes with:
- Color coding by type (cyan=tap, magenta=hold, yellow=slide)
- Rounded rectangle shape
- Glow effects
- Position updating based on scroll speed

### HitEffectComponent
Animated hit feedback with:
- Expanding ring animation
- Color based on hit quality
- Fade-out effect
- Center flash

## Adding Custom Components

Create new component files here that extend Flame's classes:

```dart
import 'package:flame/components.dart';

class MyCustomComponent extends PositionComponent {
  @override
  void render(Canvas canvas) {
    // Custom rendering
  }
  
  @override
  void update(double dt) {
    // Custom logic
  }
}
```

## Component Organization

Consider organizing by type:
- `background_component.dart`
- `note_components.dart`
- `effect_components.dart`
- `ui_components.dart`
