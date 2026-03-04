import 'package:flutter/material.dart';
import 'package:globus_vermell_app/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  bool _isHighContrast = false;

  bool get isDarkMode => _isDark;
  bool get isHighContrast => _isHighContrast;

  ThemeData get themeData {
    return _isDark
        ? _isHighContrast
              ? highContrastDarkMode
              : darkMode
        : _isHighContrast
        ? highContrastLightMode
        : lightMode;
  }

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void toggleHighContrast() {
    _isHighContrast = !_isHighContrast;
    notifyListeners();
  }
}
