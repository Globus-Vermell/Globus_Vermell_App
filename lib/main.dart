import 'package:flutter/material.dart';
import 'package:globus_vermell_app/providers/language_provider.dart';
import 'package:globus_vermell_app/screens/bottom_bar.dart';
import 'package:globus_vermell_app/screens/onboarding_screen.dart';
import 'package:globus_vermell_app/providers/theme_provider.dart';
import 'package:globus_vermell_app/services/push_notifications_service.dart';
import 'package:globus_vermell_app/utils/app_constants.dart';
import 'package:globus_vermell_app/utils/service_locator.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:globus_vermell_app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/building/building_entity.dart';
import 'models/publication/publication_entity.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PushNotificationService.initializeApp();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([
    BuildingSchema,
    PublicationSchema,
  ], directory: dir.path);

  setupServiceLocator(isar);
  final prefs = await SharedPreferences.getInstance();
  final bool isFirstTime = prefs.getBool(AppConstants.prefsIsFirstTime) ?? true;

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
