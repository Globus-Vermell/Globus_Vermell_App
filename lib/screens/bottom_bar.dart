// ignore_for_file: avoid-passing-async-when-sync-expected
import 'package:flutter/material.dart';
import 'package:globus_vermell_app/controller/architect_list_controller.dart';
import 'package:globus_vermell_app/screens/architects_screen.dart';
import 'package:globus_vermell_app/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:isar/isar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:globus_vermell_app/screens/chat_screen.dart';
import '../entity/building_entity.dart';
import '../utils/service_locator.dart';
import 'building_detail_screen.dart';
import '../controller/themes_controller.dart';
import '../providers/theme_provider.dart';
import '../utils/lang_extensions.dart';
import 'building_list_screen.dart';
import 'themes_screen.dart';

final GlobalKey<BottomBarState> bottomBarKey = GlobalKey<BottomBarState>();

class BottomBar extends StatefulWidget {
  BottomBar({Key? key}) : super(key: key ?? bottomBarKey);

  @override
  State<BottomBar> createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _listenToBackgroundEvents();
  }

  void _listenToBackgroundEvents() {
    FlutterBackgroundService().on('open_building').listen((event) async {
      if (event != null && event['id'] != null) {
        final int buildingId = event['id'];
        final isar = getIt<Isar>();
        final building = await isar.buildings.get(buildingId);
        if (building != null && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BuildingDetailScreen(
                building: building,
                location: const LatLng(0, 0),
              ),
            ),
          );
        }
      }
    });
  }

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _widgetOptions => <Widget>[
        ChangeNotifierProvider(
          create: (context) => ArchitectListController(),
          child: const ArchitectsScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemesController(),
          child: const ThemesScreen(),
        ),
        const BuildingsListScreen(),
        const ChatScreen(),
        const SettingsScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isHighContrast = themeProvider.isHighContrast;
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true, // ← fix teclado
      backgroundColor: colores.surface,
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: keyboardVisible
          ? null // ← se oculta cuando el teclado sube
          : BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              backgroundColor: colores.surface,
              elevation: isHighContrast ? 0 : 8,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(Icons.architecture),
                  label: context.loc.architects,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.menu_book),
                  label: context.loc.publications,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.map),
                  label: context.loc.map,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.smart_toy_outlined),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: context.loc.settings,
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor:
                  isHighContrast ? colores.onSurface : colores.primary,
              unselectedItemColor: isHighContrast
                  ? colores.onSurface.withValues(alpha: 0.5)
                  : colores.onSurfaceVariant,
              onTap: changeTab,
            ),
    );
  }
}