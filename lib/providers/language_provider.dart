import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_constants.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('ca');
  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadFromPrefs();
  }

  void changeLanguage(String languageCode) async {
    _currentLocale = Locale(languageCode);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefsLanguageCode, languageCode);
  }

  void _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString(AppConstants.prefsLanguageCode);
    if (languageCode != null) {
      _currentLocale = Locale(languageCode);
      notifyListeners();
    }
  }
}
