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
      backgroundColor: const Color.fromARGB(255, 230, 39, 39),
      foregroundColor: const Color.fromARGB(255, 242, 242, 242),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xffd8c2be)),
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 230, 39, 39),         // Tu rojo corporativo
      onPrimary: Colors.white,
      secondary: Color(0xff775651),       // Iconos y elementos secundarios
      onSecondary: Colors.white,
      surface: Color(0xfffbfbfb),         // Fondos
      onSurface: Color(0xff231918),       // Texto principal
      onSurfaceVariant: Color(0xff534341), // Texto gris oscuro (el que pedías)
      outline: Color(0xff857370),          // Bordes de tarjetas
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
      primary: Color(0xffffb4a8),         // Coral suave para no cansar la vista
      onPrimary: Color(0xff561e16),
      secondary: Color(0xffe7bdb6),
      onSecondary: Color(0xff442925),
      surface: Color(0xff1a1110),         // Fondo oscuro
      onSurface: Color(0xfff1dfdc),       // Texto claro
      onSurfaceVariant: Color(0xffd8c2be), // Gris claro para modo oscuro
      outline: Color(0xffa08c89),
      error: Color(0xffffb4ab),
    ),
  );

  // --- 3. ALTO CONTRASTE ---
  static final ThemeData highContrastMode = ThemeData(
    useMaterial3: true,
    textTheme: _textTheme,
    appBarTheme: _appBarTheme.copyWith(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    colorScheme: const ColorScheme.highContrastLight(
      primary: Color(0xff511a13),         // Rojo muy oscuro
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,            // Negro puro para lectura fácil
      onSurfaceVariant: Colors.black,
      outline: Colors.black,
    ),
  );

  // --- 4. MODO DALTONISMO (Protanopia/Deuteranopia) ---
  static final ThemeData colorBlindMode = ThemeData(
    useMaterial3: true,
    textTheme: _textTheme,
    appBarTheme: _appBarTheme.copyWith(
      backgroundColor: const Color(0xff005faf), // Azul cobalto (seguro para daltónicos)
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
}