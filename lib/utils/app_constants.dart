import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppConstants {
  // Coordenadas por defecto del Centro de Barcelona si no se encuentra la ubicación
  static const LatLng defaultLocation = LatLng(41.3879, 2.16992);

  // Niveles de zoom del mapa
  static const double defaultMapZoom = 14.0;
  static const double detailMapZoom = 17.0;

  // Rutas de assets para el mapa oscuro
  static const String mapStyleDarkPath = 'assets/map_styles/dark_mode.json';

  // Claves de SharedPreferences
  static const String prefsIsFirstTime = 'isFirstTime';
  static const String prefsIsDark = 'isDark';
  static const String prefsIsHighContrast = 'isHighContrast';
  static const String prefsIsColorBlind = 'isColorBlind';
  static const String prefsLanguageCode = 'languageCode';
}
