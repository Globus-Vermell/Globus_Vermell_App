import 'package:flutter/material.dart';
import 'package:globus_vermell_app/screens/ThemesScreen.dart';

import 'BuildingList.dart';
import 'CategoriesScreen.dart';
import 'HomeScreen.dart';

class BottonBar extends StatefulWidget {
  const BottonBar({super.key});

  @override
<<<<<<< HEAD:lib/screens/botton_Bar.dart
  State<botton_Bar> createState() => _botton_BarState();
}

class _botton_BarState extends State<botton_Bar> {
  int _selected_index = 0;
=======
  State<BottonBar> createState() => BottonBarState();

}
class BottonBarState extends State<BottonBar> {
  int _selectedIndex = 0;
>>>>>>> 62ce096f151bd5095341e0a78e3fa2abe677d67b:lib/screens/BottonBar.dart
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = <Widget>[
    const ListaEdificacionesScreen(),
    const ThemesScreen(),
    const CategoriesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Publicacions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categoria',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
