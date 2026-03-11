import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  // --- CONFIGURACIÓN DE TEXTO ---
  static final TextTheme _textTheme = GoogleFonts.montserratTextTheme();

  static final AppBarTheme _appBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
    titleTextStyle: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );

  // --- 1. MODO CLARO (Estándar) ---
  static final ThemeData lightMode = ThemeData(
    useMaterial3: true,
    textTheme: _textTheme,
    appBarTheme: _appBarTheme.copyWith(
      // ¡Nuevo rojo más suavecito y pastel! (Hex: #EF5350)
      backgroundColor: const Color(0xFFEF5350), 
      foregroundColor: const Color.fromARGB(255, 242, 242, 242),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xffd8c2be)),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFEF5350),         // Tu NUEVO rojo suavecito y elegante ✨
      onPrimary: Colors.white,
      secondary: Color(0xff775651),       
      onSecondary: Colors.white,
      surface: Color(0xfffbfbfb),         
      onSurface: Color(0xff231918),       
      onSurfaceVariant: Color(0xff534341), 
      outline: Color(0xff857370),          
      error: Color(0xffba1a1a),
    ),
  );

  // --- 2. MODO OSCURO ---
  static final ThemeData darkMode = ThemeData(
    useMaterial3: true,
    textTheme: _textTheme,
    appBarTheme: _appBarTheme.copyWith(
      backgroundColor: const Color(0xff1a1110),
      foregroundColor: const Color(0xffffb4a8),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xff534341)),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xffffb4a8),         
      onPrimary: Color(0xff561e16),
      secondary: Color(0xffe7bdb6),
      onSecondary: Color(0xff442925),
      surface: Color.fromARGB(255, 53, 53, 53),         
      onSurface: Color(0xfff1dfdc),       
      onSurfaceVariant: Color(0xffd8c2be), 
      outline: Color(0xffa08c89),
      error: Color(0xffffb4ab),
    ),
  );

  // --- 3. ALTO CONTRASTE (Modo Claro) ---
  static final ThemeData highContrastMode = ThemeData(
    useMaterial3: true,
    textTheme: _textTheme,
    appBarTheme: _appBarTheme.copyWith(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.highContrastLight(
      primary: Color(0xff511a13),         
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,            
      onSurfaceVariant: Colors.black,
      outline: Colors.black,
    ),
  );

  // --- 4. MODO DALTONISMO (Modo Claro) ---
  static final ThemeData colorBlindMode = ThemeData(
    useMaterial3: true,
    textTheme: _textTheme,
    appBarTheme: _appBarTheme.copyWith(
      backgroundColor: const Color(0xff005faf), 
      foregroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xff005faf),
      onPrimary: Colors.white,
      secondary: Color(0xff004a87),
      surface: Color(0xfff0f7ff),
      onSurface: Color(0xff001d33),
      onSurfaceVariant: Color(0xff40474f),
      outline: Color(0xff70777f),
    ),
  );

  // --- 5. MODO OSCURO + DALTONISMO ---
  static final ThemeData darkColorBlindMode = ThemeData(
    useMaterial3: true,
    textTheme: _textTheme,
    appBarTheme: _appBarTheme.copyWith(
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      foregroundColor: const Color(0xff80c8ff), // Azul clarito
    ),
    dividerTheme: const DividerThemeData(color: Color(0xff534341)),
    colorScheme: const ColorScheme.dark(
      // Usamos un azul más brillante (#66b2ff) para que resalte en el fondo oscuro
      primary: Color(0xff66b2ff),         
      onPrimary: Color(0xff003366),
      secondary: Color(0xff4a90e2),
      onSecondary: Colors.white,
      surface: Color.fromARGB(255, 53, 53, 53), // El fondo gris oscuro que elegiste         
      onSurface: Color(0xffe6f2ff),       // Texto blanco-azulado
      onSurfaceVariant: Color(0xffb3d9ff), // Texto secundario azuladito
      outline: Color(0xff8099b3),
      error: Color(0xffffb4ab),
    ),
  );

  // --- 6. MODO OSCURO + ALTO CONTRASTE ---
  static final ThemeData darkHighContrastMode = ThemeData(
    useMaterial3: true,
    textTheme: _textTheme,
    appBarTheme: _appBarTheme.copyWith(
      backgroundColor: Colors.black,
      foregroundColor: const Color(0xffff5555), // Rojo súper brillante
    ),
    colorScheme: const ColorScheme.highContrastDark(
      // Un rojo muy neón/brillante para que destaque al máximo sobre el negro puro
      primary: Color(0xffff5555),         
      onPrimary: Colors.black,
      surface: Colors.black,              // Fondo negro 100% puro
      onSurface: Colors.white,            // Texto blanco puro
      onSurfaceVariant: Colors.white,     // Todo el texto blanco puro
      outline: Colors.white,              // Bordes blancos puros
      error: Color(0xffff5555),
    ),
  );
}