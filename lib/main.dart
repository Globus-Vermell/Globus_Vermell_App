import 'package:flutter/material.dart';
import 'package:globus_vermell_app/providers/language_provider.dart';
import 'package:globus_vermell_app/screens/bottom_bar.dart';
import 'package:globus_vermell_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MisEdificiosApp(),
    ),
  );
}

class MisEdificiosApp extends StatelessWidget {
  const MisEdificiosApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();

    return MaterialApp(
      title: 'Gestor de Edificios',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      locale: langProvider.currentLocale,
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
        Locale('ca'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const BottomBar(),
    );
  }
}