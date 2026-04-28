// ignore_for_file: avoid-passing-async-when-sync-expected

import 'package:flutter/material.dart';
import 'package:globus_vermell_app/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:isar/isar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../entity/building_entity.dart';
import '../utils/service_locator.dart';
import 'building_detail_screen.dart';
import '../controller/themes_controller.dart';
import '../providers/theme_provider.dart';
import '../controller/building_list_controller.dart';
import '../utils/lang_extensions.dart';
import 'building_list_screen.dart';
import 'themes_screen.dart';

// ✨ ¡NUESTRA LLAVE MÁGICA PARA MOVER LA APP! UwU ✨
final GlobalKey<BottomBarState> bottomBarKey = GlobalKey<BottomBarState>();

class BottomBar extends StatefulWidget {
  // Le pasamos la llave mágica al constructor por defecto OwO
  BottomBar({Key? key}) : super(key: key ?? bottomBarKey);
  
  @override
  State<BottomBar> createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

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

  // ✨ Le quitamos el "_" para poder llamarla desde otras pantallas UwU ✨
  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _widgetOptions => <Widget>[
    const BuildingsListScreen(),
    ChangeNotifierProvider(
      create: (context) => ThemesController(),
      child: const ThemesScreen(),
    ),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isHighContrast = themeProvider.isHighContrast;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colores.surface,
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colores.surface,
        elevation: isHighContrast ? 0 : 8,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: context.loc.map,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book),
            label: context.loc.publications,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: context.loc.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: isHighContrast ? colores.onSurface : colores.primary,
        unselectedItemColor: isHighContrast
            ? colores.onSurface.withValues(alpha: 0.5)
            : colores.onSurfaceVariant,
        onTap: changeTab, // ✨ ¡Usamos nuestra nueva función aquí!
      ),
    );
  }
}