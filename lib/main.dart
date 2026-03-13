import 'package:flutter/material.dart';
import 'package:globus_vermell_app/providers/language_provider.dart';
import 'package:globus_vermell_app/screens/bottom_bar.dart';
import 'package:globus_vermell_app/screens/onboarding_screen.dart';
import 'package:globus_vermell_app/providers/theme_provider.dart';
import 'package:globus_vermell_app/services/building_service.dart';
import 'package:globus_vermell_app/services/publications_service.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:globus_vermell_app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models/building/building_entity.dart';
import 'models/publication/publication_entity.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([
    BuildingSchema,
    PublicationSchema,
  ], directory: dir.path);

  final prefs = await SharedPreferences.getInstance();
  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => BuildingService(isar)),
        Provider(create: (_) => PublicationService(isar)),
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
