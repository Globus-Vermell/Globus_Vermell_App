import 'package:flutter/material.dart';
import 'package:globus_vermell_app/providers/language_provider.dart';
import 'package:globus_vermell_app/screens/bottom_bar.dart';
import 'package:globus_vermell_app/screens/onboarding_screen.dart';
import 'package:globus_vermell_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:globus_vermell_app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const url = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  if (url.isEmpty || anonKey.isEmpty) {
    throw Exception('Faltan Credenciales de Supabase');
  }

  await Supabase.initialize(url: url, anonKey: anonKey);
  final prefs = await SharedPreferences.getInstance();
  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: MisEdificiosApp(isFirstTime: isFirstTime),
    ),
  );
}

class MisEdificiosApp extends StatelessWidget {
  final bool isFirstTime;

  const MisEdificiosApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();

    return MaterialApp(
      title: 'Gestor de Edificios',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      locale: langProvider.currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: isFirstTime ? const OnboardingScreen() : const BottomBar(),
    );
  }
}
