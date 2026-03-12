import 'package:flutter/material.dart';
import 'package:globus_vermell_app/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  bool _isHighContrast = false;
  bool _isColorBlind = false;

  bool get isDarkMode => _isDark;
  bool get isHighContrast => _isHighContrast;
  bool get isColorBlind => _isColorBlind;

  ThemeProvider() {
    _loadFromPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', _isDark);
    await prefs.setBool('isHighContrast', _isHighContrast);
    await prefs.setBool('isColorBlind', _isColorBlind);
  }

  /*
  Cuándo un modo esté activo veremos si el tema es blanco o negro y activaremos sus respectivos temas.
   */
  ThemeData get themeData {
    if (_isHighContrast) {
      return _isDark ? AppThemes.darkHighContrastMode : AppThemes.highContrastMode;
    }
    if (_isColorBlind) {
      return _isDark ? AppThemes.darkColorBlindMode : AppThemes.colorBlindMode;
    }
    return _isDark ? AppThemes.darkMode : AppThemes.lightMode;
  }

  void toggleTheme() {
    _isDark = !_isDark;
    _saveToPrefs();
    notifyListeners();
  }

  void toggleHighContrast() {
    _isHighContrast = !_isHighContrast;
    if (_isHighContrast) _isColorBlind = false;
    _saveToPrefs();
    notifyListeners();
  }

  void toggleColorBlind() {
    _isColorBlind = !_isColorBlind;
    if (_isColorBlind) _isHighContrast = false;
    _saveToPrefs();
    notifyListeners();
  }

  void _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? false;
    _isHighContrast = prefs.getBool('isHighContrast') ?? false;
    _isColorBlind = prefs.getBool('isColorBlind') ?? false;
    notifyListeners();
  }
}