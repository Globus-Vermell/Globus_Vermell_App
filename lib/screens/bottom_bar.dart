import 'package:flutter/material.dart';
import 'package:globus_vermell_app/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import '../controllers/building_list_controller.dart';
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

  final List<Widget> _widgetOptions = <Widget>[
    ChangeNotifierProvider(
      create: (_) => BuildingListController(),
      child: const BuildingsListScreen(),
    ),
    const ThemesScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colores.surface,
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colores.surface,
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
        selectedItemColor: colores.primary,
        unselectedItemColor: colores.onSurfaceVariant,
        onTap: _onItemTapped,
      ),
    );
  }
}
