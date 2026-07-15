import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/score_manager.dart';
import '../utils/game_constants.dart';

/// Main game class for the rhythm game using Flame engine
class RhythmGame extends FlameGame with TapCallbacks, DragCallbacks {
  late Chart chart;
  late ScoreManager scoreManager;
  late double currentTime;
  bool isPlaying = false;
  double _currentTime = 0.0;
  
  @override
  double currentTime() => _currentTime;
  
  // Visual components
  late List<LaneComponent> lanes;
  late HitLineComponent hitLine;
  final List<NoteComponent> activeNotes = [];
  final List<HitEffectComponent> hitEffects = [];
  
  // Configuration
  final double hitLineY = GameConstants.hitLineY;
  final int laneCount = GameConstants.laneCount;
  late double laneWidth;
  late double scrollSpeed;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Calculate lane width based on screen size
    laneWidth = size.x / laneCount;
    scrollSpeed = GameConstants.baseScrollSpeed;
    
    // Create lanes
    lanes = List.generate(
      laneCount,
      (index) => LaneComponent(
        laneIndex: index,
        laneWidth: laneWidth,
        x: index * laneWidth,
        y: 0,
        height: size.y,
      ),
    );
    
    // Add lanes to game
    for (final lane in lanes) {
      add(lane);
    }
    
    // Create hit line
    hitLine = HitLineComponent(
      y: hitLineY,
      width: size.x,
      laneCount: laneCount,
    );
    add(hitLine);
  }
  
  /// Initialize game with a chart and score manager
  void initializeGame(Chart gameChart, ScoreManager manager) {
    chart = gameChart;
    scoreManager = manager;
    scoreManager.reset();
    activeNotes.clear();
    hitEffects.clear();
  }
  
  /// Start the game
  void startGame() {
    isPlaying = true;
  }
  
  /// Pause the game
  void pauseGame() {
    isPlaying = false;
  }
  
  /// Resume the game
  void resumeGame() {
    isPlaying = true;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (!isPlaying) return;
    
    // Update current time
    _currentTime += dt;
    
    // Spawn notes that should appear
    _spawnNotes();
    
    // Update active notes
    _updateNotes(dt);
    
    // Check for missed notes
    _checkMissedNotes();
    
    // Update hit effects
    _updateHitEffects(dt);
    
    // Check if song is complete
    if (_currentTime > chart.duration + 2.0) {
      _endGame();
    }
  }
  
  /// Spawn notes that should be visible
  void _spawnNotes() {
    final spawnThreshold = 2.0; // Seconds before hit time to spawn
    
    for (final note in chart.notes) {
      if (!note.isActive) continue;
      
      // Check if note should be spawned
      if (note.time - _currentTime <= spawnThreshold && 
          !activeNotes.any((n) => n.note == note)) {
        final noteComponent = NoteComponent(
          note: note,
          laneWidth: laneWidth,
          hitLineY: hitLineY,
          scrollSpeed: scrollSpeed,
        );
        activeNotes.add(noteComponent);
        add(noteComponent);
      }
    }
  }
  
  /// Update all active notes
  void _updateNotes(double dt) {
    for (final noteComponent in activeNotes.toList()) {
      noteComponent.updatePosition(_currentTime);
      
      // Remove notes that are off-screen
      if (noteComponent.shouldRemove()) {
        noteComponent.removeFromParent();
        activeNotes.remove(noteComponent);
      }
    }
  }
  
  /// Check for missed notes
  void _checkMissedNotes() {
    final missThreshold = GameConstants.missWindow / 1000.0;
    
    for (final note in chart.notes) {
      if (!note.isActive) continue;
      
      if (_currentTime - note.time > missThreshold) {
        note.markMissed();
        scoreManager.registerHit(HitResult.miss);
        
        // Remove from active notes
        final noteComponent = activeNotes.firstWhere(
          (n) => n.note == note,
          orElse: () => NoteComponent(
            note: note,
            laneWidth: laneWidth,
            hitLineY: hitLineY,
            scrollSpeed: scrollSpeed,
          ),
        );
        if (noteComponent.isMounted) {
          noteComponent.removeFromParent();
        }
        activeNotes.remove(noteComponent);
      }
    }
  }
  
  /// Update hit effects
  void _updateHitEffects(double dt) {
    for (final effect in hitEffects.toList()) {
      effect.update(dt);
      if (effect.shouldRemove()) {
        effect.removeFromParent();
        hitEffects.remove(effect);
      }
    }
  }
  
  /// Handle tap input
  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    
    if (!isPlaying) return;
    
    final tapX = event.eventPosition.x;
    final lane = (tapX / laneWidth).floor().clamp(0, laneCount - 1);
    
    _checkHit(lane);
  }
  
  /// Check if a hit registereds in the given lane
  void _checkHit(int lane) {
    final hitWindow = GameConstants.missWindow / 1000.0;
    
    // Find the closest hittable note in this lane
    Note? closestNote;
    double closestDiff = double.infinity;
    
    for (final note in chart.notes) {
      if (!note.isActive || note.lane != lane) continue;
      
      final diff = (note.time - _currentTime).abs();
      if (diff < hitWindow && diff < closestDiff) {
        closestDiff = diff;
        closestNote = note;
      }
    }
    
    if (closestNote != null) {
      _registerHit(closestNote!, closestDiff);
    }
  }
  
  /// Register a hit on a note
  void _registerHit(Note note, double timeDiff) {
    final msDiff = timeDiff * 1000.0;
    HitResult result;
    
    if (msDiff <= GameConstants.perfectWindow) {
      result = HitResult.perfect;
    } else if (msDiff <= GameConstants.greatWindow) {
      result = HitResult.great;
    } else if (msDiff <= GameConstants.goodWindow) {
      result = HitResult.good;
    } else {
      result = HitResult.miss;
    }
    
    note.markHit();
    scoreManager.registerHit(result);
    
    // Create hit effect
    final effect = HitEffectComponent(
      lane: note.lane,
      laneWidth: laneWidth,
      hitLineY: hitLineY,
      result: result,
    );
    hitEffects.add(effect);
    add(effect);
    
    // Remove note component
    final noteComponent = activeNotes.firstWhere(
      (n) => n.note == note,
      orElse: () => NoteComponent(
        note: note,
        laneWidth: laneWidth,
        hitLineY: hitLineY,
        scrollSpeed: scrollSpeed,
      ),
    );
    if (noteComponent.isMounted) {
      noteComponent.removeFromParent();
    }
    activeNotes.remove(noteComponent);
  }
  
  /// End the game
  void _endGame() {
    isPlaying = false;
    // Signal game over (would navigate to results screen in actual implementation)
    debugPrint('Game Over! Score: ${scoreManager.score}');
  }
  
  @override
  Color backgroundColor() => const Color(0xFF0A0A1A);
}

/// Lane component representing a single track
class LaneComponent extends PositionComponent {
  final int laneIndex;
  final double laneWidth;
  
  LaneComponent({
    required this.laneIndex,
    required this.laneWidth,
    required double x,
    required double y,
    required double height,
  }) : super(
    position: Vector2(x, y),
    size: Vector2(laneWidth, height),
  );
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw lane background with alternating colors
    final paint = Paint()
      ..color = (laneIndex % 2 == 0) 
        ? const Color(0xFF1A1A2E).withOpacity(0.5)
        : const Color(0xFF16213E).withOpacity(0.5);
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
    
    // Draw lane divider
    final dividerPaint = Paint()
      ..color = const Color(0xFF00FFFF).withOpacity(0.3)
      ..strokeWidth = 2.0;
    
    canvas.drawLine(
      Offset(size.x, 0),
      Offset(size.x, size.y),
      dividerPaint,
    );
  }
}

/// Hit line component showing where to hit notes
class HitLineComponent extends PositionComponent {
  final double y;
  final double width;
  final int laneCount;
  
  HitLineComponent({
    required this.y,
    required this.width,
    required this.laneCount,
  }) : super(
    position: Vector2(0, y),
    size: Vector2(width, 4),
  );
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw hit line
    final paint = Paint()
      ..color = const Color(0xFF00FFFF)
      ..strokeWidth = 4.0;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
    
    // Draw glow effect
    final glowPaint = Paint()
      ..color = const Color(0xFF00FFFF).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0);
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), glowPaint);
  }
}

/// Note component representing a hit object
class NoteComponent extends PositionComponent {
  final Note note;
  final double laneWidth;
  final double hitLineY;
  final double scrollSpeed;
  
  NoteComponent({
    required this.note,
    required this.laneWidth,
    required this.hitLineY,
    required this.scrollSpeed,
  }) : super(
    position: Vector2(
      note.lane * laneWidth + (laneWidth - 60) / 2,
      -100,
    ),
    size: Vector2(60, 20),
  );
  
  void updatePosition(double currentTime) {
    final y = note.getYPosition(currentTime, hitLineY, scrollSpeed);
    position.y = y - size.y / 2;
  }
  
  bool shouldRemove() {
    return position.y > hitLineY + 200;
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Different colors for different note types
    Color noteColor;
    switch (note.type) {
      case 1: // Hold note
        noteColor = const Color(0xFFFF00FF);
        break;
      case 2: // Slide note
        noteColor = const Color(0xFFFFFF00);
        break;
      default: // Tap note
        noteColor = const Color(0xFF00FFFF);
    }
    
    // Draw note body
    final paint = Paint()..color = noteColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(10.0),
      ),
      paint,
    );
    
    // Draw border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(10.0),
      ),
      borderPaint,
    );
    
    // Inner glow
    final glowPaint = Paint()
      ..color = noteColor.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2, 2, size.x - 4, size.y - 4),
        const Radius.circular(8.0),
      ),
      glowPaint,
    );
  }
}

/// Hit effect component for visual feedback
class HitEffectComponent extends PositionComponent {
  final int lane;
  final double laneWidth;
  final double hitLineY;
  final HitResult result;
  double _lifetime = 0.0;
  final double _maxLifetime = 0.3;
  
  HitEffectComponent({
    required this.lane,
    required this.laneWidth,
    required this.hitLineY,
    required this.result,
  }) : super(
    position: Vector2(
      lane * laneWidth + (laneWidth - 80) / 2,
      hitLineY - 40,
    ),
    size: Vector2(80, 80),
  );
  
  void update(double dt) {
    _lifetime += dt;
  }
  
  bool shouldRemove() {
    return _lifetime >= _maxLifetime;
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final alpha = 1.0 - (_lifetime / _maxLifetime);
    
    // Color based on hit result
    Color effectColor;
    switch (result) {
      case HitResult.perfect:
        effectColor = const Color(0xFF00FFFF);
        break;
      case HitResult.great:
        effectColor = const Color(0xFF00FF00);
        break;
      case HitResult.good:
        effectColor = const Color(0xFFFFFF00);
        break;
      default:
        effectColor = const Color(0xFFFF0000);
    }
    
    // Draw expanding ring
    final expansion = _lifetime / _maxLifetime;
    final radius = 30.0 + (expansion * 50.0);
    
    final paint = Paint()
      ..color = effectColor.withOpacity(alpha * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      radius,
      paint,
    );
    
    // Draw center flash
    final flashPaint = Paint()
      ..color = effectColor.withOpacity(alpha * 0.8);
    
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      radius * 0.3,
      flashPaint,
    );
  }
}
