import 'package:flutter/material.dart';
import 'package:globus_vermell_app/screens/settings_screen.dart';
import 'package:globus_vermell_app/utils/app_keys.dart';
import '../utils/lang_extensions.dart';
import 'building_list_screen.dart';
import 'themes_screen.dart';

class BottonBar extends StatefulWidget {
  const BottonBar({super.key});

  @override
  State<BottonBar> createState() => BottonBarState();
}

class BottonBarState extends State<BottonBar> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = <Widget>[
    const ListaEdificacionesScreen(),
    const ThemesScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.map), label: context.translate(AppKeys.map),),
           BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: context.translate(AppKeys.publications),),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: context.translate(AppKeys.settings)),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
