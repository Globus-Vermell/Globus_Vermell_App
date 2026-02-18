import 'package:flutter/material.dart';
import 'package:globus_vermell_app/screens/settings_screen.dart';
import 'BuildingList.dart';
import 'ThemesScreen.dart';

class BottonBar extends StatefulWidget {
  const BottonBar({super.key});

  @override
  State<BottonBar> createState() => BottonBarState();
}

class BottonBarState extends State<BottonBar> {
  int _selectedIndex = 2;
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Publicacions',),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configuració',),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
