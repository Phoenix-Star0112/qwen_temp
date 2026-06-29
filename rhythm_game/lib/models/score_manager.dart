import 'package:flutter/foundation.dart';
import '../models/note.dart';
import '../utils/game_constants.dart';

/// Score manager to track player performance
class ScoreManager extends ChangeNotifier {
  int _score = 0;
  int _combo = 0;
  int _maxCombo = 0;
  int _perfectCount = 0;
  int _greatCount = 0;
  int _goodCount = 0;
  int _missCount = 0;
  double _accuracy = 100.0;
  bool _isFullCombo = true;
  
  int get score => _score;
  int get combo => _combo;
  int get maxCombo => _maxCombo;
  int get perfectCount => _perfectCount;
  int get greatCount => _greatCount;
  int get goodCount => _goodCount;
  int get missCount => _missCount;
  double get accuracy => _accuracy;
  bool get isFullCombo => _isFullCombo;
  bool get isAllPerfect => _missCount == 0 && _goodCount == 0 && _greatCount == 0;
  
  /// Register a hit on a note
  void registerHit(HitResult result) {
    switch (result) {
      case HitResult.perfect:
        _score += GameConstants.perfectScore + (_combo * GameConstants.comboMultiplier);
        _combo++;
        _perfectCount++;
        break;
      case HitResult.great:
        _score += GameConstants.greatScore + (_combo * GameConstants.comboMultiplier);
        _combo++;
        _greatCount++;
        break;
      case HitResult.good:
        _score += GameConstants.goodScore + (_combo * GameConstants.comboMultiplier);
        _combo++;
        _goodCount++;
        break;
      case HitResult.miss:
        _combo = 0;
        _missCount++;
        _isFullCombo = false;
        break;
      case HitResult.none:
        break;
    }
    
    if (_combo > _maxCombo) {
      _maxCombo = _combo;
    }
    
    _updateAccuracy();
    notifyListeners();
  }
  
  /// Update accuracy percentage
  void _updateAccuracy() {
    final totalHits = _perfectCount + _greatCount + _goodCount + _missCount;
    if (totalHits > 0) {
      // Weighted accuracy: Perfect=100%, Great=70%, Good=30%, Miss=0%
      final weightedSum = (_perfectCount * 100.0) + 
                         (_greatCount * 70.0) + 
                         (_goodCount * 30.0);
      _accuracy = (weightedSum / totalHits).clamp(0.0, 100.0);
    } else {
      _accuracy = 100.0;
    }
  }
  
  /// Reset score for new game
  void reset() {
    _score = 0;
    _combo = 0;
    _maxCombo = 0;
    _perfectCount = 0;
    _greatCount = 0;
    _goodCount = 0;
    _missCount = 0;
    _accuracy = 100.0;
    _isFullCombo = true;
    notifyListeners();
  }
  
  /// Get rank based on accuracy
  String getRank() {
    if (_accuracy >= 95.0 && _isFullCombo) return 'SS';
    if (_accuracy >= 90.0) return 'S';
    if (_accuracy >= 80.0) return 'A';
    if (_accuracy >= 70.0) return 'B';
    if (_accuracy >= 60.0) return 'C';
    return 'D';
  }
  
  @override
  String toString() {
    return 'Score: $_score | Combo: $_combo | Accuracy: ${_accuracy.toStringAsFixed(2)}%';
  }
}
