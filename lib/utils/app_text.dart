class AppTexts {
  static const Map<String, Map<String, String>> _localizedValues = {
    'es': {
      'configuracion': 'Configuración',
      'modo_oscuro': 'Modo Oscuro',
      'alto_contraste': 'Alto Contraste',
      'idioma': 'Idioma',
      'mapa': 'Mapa',
      'publicaciones': 'Publicaciones',
      'lista': 'Lista',
    },
    'en': {
      'configuracion': 'Settings',
      'modo_oscuro': 'Dark Mode',
      'alto_contraste': 'High Contrast',
      'idioma': 'Language',
      'mapa': 'Map',
      'publicaciones': 'Publications',
      'lista': 'List',
    },
    'ca': {
      'configuracion': 'Configuració',
      'modo_oscuro': 'Mode Fosc',
      'alto_contraste': 'Alt Contrast',
      'idioma': 'Idioma',
      'mapa': 'Mapa',
      'publicaciones': 'Publicacions',
      'lista': 'Llista',
    },
  };

  static String getText(String languageCode, String key) {
    return _localizedValues[languageCode]?[key] ?? key;
  }
}