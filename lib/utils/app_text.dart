class AppTexts {
  static const Map<String, Map<String, String>> _localizedValues = {
    'es': {
      'configuracion': 'Configuración',
      'modo_oscuro': 'Modo Oscuro',
      'alto_contraste': 'Alto Contraste',
      'idioma': 'Idioma',
    },
    'en': {
      'configuracion': 'Settings',
      'modo_oscuro': 'Dark Mode',
      'alto_contraste': 'High Contrast',
      'idioma': 'Language',
    },
    'ca': {
      'configuracion': 'Configuració',
      'modo_oscuro': 'Mode Obscur',
      'alto_contraste': 'Alt Contrast',
      'idioma': 'Idioma',
    },
  };

  static String getText(String languageCode, String key) {
    return _localizedValues[languageCode]?[key] ?? key;
  }
}