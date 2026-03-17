import 'package:flutter/material.dart';
import 'package:globus_vermell_app/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_constants.dart';

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
    await prefs.setBool(AppConstants.prefsIsDark, _isDark);
    await prefs.setBool(AppConstants.prefsIsHighContrast, _isHighContrast);
    await prefs.setBool(AppConstants.prefsIsColorBlind, _isColorBlind);
  }

  /*
  Cuándo un modo esté activo veremos si el tema es blanco o negro y activaremos sus respectivos temas.
   */
  ThemeData get themeData {
    if (_isHighContrast) {
      return _isDark
          ? AppThemes.darkHighContrastMode
          : AppThemes.highContrastMode;
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
    _isDark = prefs.getBool(AppConstants.prefsIsDark) ?? false;
    _isHighContrast = prefs.getBool(AppConstants.prefsIsHighContrast) ?? false;
    _isColorBlind = prefs.getBool(AppConstants.prefsIsColorBlind) ?? false;
    notifyListeners();
  }
}
