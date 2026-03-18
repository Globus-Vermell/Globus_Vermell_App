import 'package:flutter/material.dart';
import 'package:globus_vermell_app/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import '../controller/themes_controller.dart';
import '../providers/theme_provider.dart';
import '../controller/building_list_controller.dart';
import '../utils/lang_extensions.dart';
import 'building_list_screen.dart';
import 'themes_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _widgetOptions => <Widget>[
    ChangeNotifierProvider(
      create: (context) => BuildingListController(),
      child: const BuildingsListScreen(),
    ),
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
        onTap: _onItemTapped,
      ),
    );
  }
}
