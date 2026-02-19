import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import 'app_text.dart';

extension LocalizationExtension on BuildContext {
  String translate(String key) {
    final code = watch<LanguageProvider>().currentLocale.languageCode;
    return AppTexts.getText(code, key);
  }
}