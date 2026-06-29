# Image Assets

## Supported Formats
- PNG (.png) - Recommended with transparency
- JPG (.jpg) - For backgrounds
- SVG (.svg) - Vector graphics (requires flutter_svg)

## Asset Types

### Backgrounds
Place background images for different songs or themes.
Recommended size: 1080x1920 (portrait) or 1920x1080 (landscape)

### Note Skins
Custom note appearances (optional - game uses procedural rendering).
Recommended size: 64x64 pixels per note

### UI Elements
Custom buttons, icons, and decorations.

## File Naming Convention
- `background_songtitle.png`
- `note_skin_neon.png`
- `ui_button_play.png`

## Current Implementation
The game uses **procedural graphics** rendered with Flutter's Canvas API:
- Neon gradient backgrounds
- Glowing note components
- Animated hit effects
- Dynamic lane dividers

No image assets are required for the base game!

## Adding Custom Graphics (Optional)
1. Add your images to this directory
2. Update pubspec.yaml if needed
3. Modify the render methods in component files
