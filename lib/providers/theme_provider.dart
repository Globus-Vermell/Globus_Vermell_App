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
    // Si el modo alto contraste esta activo, tiene prioridad absoluta
    if(_isHighContrast) {
      return AppThemes.highContrastMode;
    }

    // Modo daltonismo 
    if(_isColorBlind) {
      return AppThemes.colorBlindMode;
    }

    // En caso de no tener modos de adaptavilidad elegimos los modos claro u oscuro
    return _isDark ? AppThemes.darkMode : AppThemes.lightMode;
  }

  void toggleTheme() {
    _isDark = !_isDark;
    // Apagamos los otros modos para que no se peleen entre ellos
    if (_isDark) {
      _isHighContrast = false;
      _isColorBlind = false;
    }
    notifyListeners();
  }

  void toggleHighContrast() {
    _isHighContrast = !_isHighContrast;
    if (_isHighContrast) {
      _isColorBlind = false; 
    }
    notifyListeners();
  }

  void toggleColorBlind() {
    _isColorBlind = !_isColorBlind;
    if (_isColorBlind) {
      _isHighContrast = false; 
      _isDark = false; // Nuestro modo daltonismo está hecho sobre base clarita
    }
    notifyListeners();
  }
}
