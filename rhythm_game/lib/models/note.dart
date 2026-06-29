import 'package:flutter/material.dart';

/// Note model representing a hit object in the rhythm game
class Note {
  final int lane; // 0-3 for 4 lanes
  final double time; // Time in seconds when the note should be hit
  final int type; // 0=tap, 1=hold, 2=slide
  final double? endTime; // For hold notes
  final double spawnY;
  
  bool _hit = false;
  bool _missed = false;
  
  Note({
    required this.lane,
    required this.time,
    this.type = 0,
    this.endTime,
    this.spawnY = -200.0,
  });
  
  bool get isHit => _hit;
  bool get isMissed => _missed;
  bool get isActive => !_hit && !_missed;
  bool get isHoldNote => type == 1;
  bool get isSlideNote => type == 2;
  
  void markHit() {
    _hit = true;
  }
  
  void markMissed() {
    _missed = true;
  }
  
  /// Check if the note is within hittable range
  bool isHittable(double currentTime, double hitWindow) {
    return (currentTime - time).abs() <= hitWindow;
  }
  
  /// Get the Y position based on current time and scroll speed
  double getYPosition(double currentTime, double hitLineY, double scrollSpeed) {
    final timeDiff = time - currentTime;
    return hitLineY + (timeDiff * scrollSpeed);
  }
  
  @override
  String toString() => 'Note(lane: $lane, time: $time, type: $type)';
}

/// Chart model containing all notes for a song
class Chart {
  final String songId;
  final String songTitle;
  final String artist;
  final double duration;
  final List<Note> notes;
  final int difficulty; // 1-10
  
  Chart({
    required this.songId,
    required this.songTitle,
    required this.artist,
    required this.duration,
    required this.notes,
    this.difficulty = 5,
  });
  
  /// Get notes that are currently active (not hit or missed)
  List<Note> getActiveNotes(double currentTime, double window) {
    return notes.where((note) {
      return note.isActive && 
             (note.time - currentTime).abs() <= window;
    }).toList();
  }
  
  /// Get all notes that should be visible on screen
  List<Note> getVisibleNotes(
    double currentTime, 
    double hitLineY, 
    double scrollSpeed,
    double screenHeight,
  ) {
    return notes.where((note) {
      if (!note.isActive) return false;
      final y = note.getYPosition(currentTime, hitLineY, scrollSpeed);
      return y > -100 && y < screenHeight + 100;
    }).toList();
  }
}
