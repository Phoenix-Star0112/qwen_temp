import 'package:flutter/foundation.dart';

/// Game settings managed with Provider
class GameSettings extends ChangeNotifier {
  double _musicVolume = 0.8;
  double _sfxVolume = 0.6;
  double _scrollSpeed = 1.0;
  bool _showHitEffects = true;
  bool _showComboDisplay = true;
  int _selectedSkin = 0;
  
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  double get scrollSpeed => _scrollSpeed;
  bool get showHitEffects => _showHitEffects;
  bool get showComboDisplay => _showComboDisplay;
  int get selectedSkin => _selectedSkin;
  
  void setMusicVolume(double value) {
    _musicVolume = value.clamp(0.0, 1.0);
    notifyListeners();
  }
  
  void setSfxVolume(double value) {
    _sfxVolume = value.clamp(0.0, 1.0);
    notifyListeners();
  }
  
  void setScrollSpeed(double value) {
    _scrollSpeed = value.clamp(0.5, 2.0);
    notifyListeners();
  }
  
  void toggleHitEffects() {
    _showHitEffects = !_showHitEffects;
    notifyListeners();
  }
  
  void toggleComboDisplay() {
    _showComboDisplay = !_showComboDisplay;
    notifyListeners();
  }
  
  void setSelectedSkin(int value) {
    _selectedSkin = value;
    notifyListeners();
  }
  
  void resetToDefaults() {
    _musicVolume = 0.8;
    _sfxVolume = 0.6;
    _scrollSpeed = 1.0;
    _showHitEffects = true;
    _showComboDisplay = true;
    _selectedSkin = 0;
    notifyListeners();
  }
}
