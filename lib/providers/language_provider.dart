import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('ca');

  Locale get currentLocale => _currentLocale;

  void changeLanguage(String languageCode) {
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }
}