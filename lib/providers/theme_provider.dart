import 'package:flutter/material.dart';
import 'package:globus_vermell_app/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  bool _isHighContrast = false;
  bool _isColorBlind = false;

  bool get isDarkMode => _isDark;
  bool get isHighContrast => _isHighContrast;
  bool get isColorBlind => _isColorBlind;

  ThemeData get themeData {
    // 1. Si el modo alto contraste está activo
    if (_isHighContrast) {
      // Devolvemos la versión oscura o clara dependiendo del switch de Dark Mode
      return _isDark ? AppThemes.darkHighContrastMode : AppThemes.highContrastMode;
    }

    // 2. Si el modo daltonismo está activo
    if (_isColorBlind) {
      // Devolvemos la versión oscura o clara dependiendo del switch de Dark Mode
      return _isDark ? AppThemes.darkColorBlindMode : AppThemes.colorBlindMode;
    }

    // 3. En caso de no tener modos de adaptabilidad, elegimos los modos normales
    return _isDark ? AppThemes.darkMode : AppThemes.lightMode;
  }

  void toggleTheme() {
    _isDark = !_isDark;
    // ¡Ojo al dato bb! Ya NO apagamos los otros modos aquí. 
    // Queremos que el modo oscuro se sume a la fiesta, ¡owo! ✨
    notifyListeners();
  }

  void toggleHighContrast() {
    _isHighContrast = !_isHighContrast;
    if (_isHighContrast) {
      // Apagamos el daltonismo para que no choquen entre sí,
      // ¡pero dejamos el Dark Mode tranquilo para que se combinen!
      _isColorBlind = false;
    }
    notifyListeners();
  }

  void toggleColorBlind() {
    _isColorBlind = !_isColorBlind;
    if (_isColorBlind) {
      // Apagamos el alto contraste,
      // ¡pero dejamos el Dark Mode en paz!
      _isHighContrast = false;
    }
    notifyListeners();
  }
}