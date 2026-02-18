import 'package:flutter/material.dart';
import 'package:globus_vermell_app/screens/ThemesScreen.dart';

import 'BuildingList.dart';
import 'CategoriesScreen.dart';
import 'HomeScreen.dart';

class botton_Bar extends StatefulWidget {
  const botton_Bar({super.key});

  @override
  State<botton_Bar> createState() => _botton_BarState();
}

class _botton_BarState extends State<botton_Bar> {
  int _selected_index = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selected_index = index;
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
      body: _widgetOptions[_selected_index],
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
        currentIndex: _selected_index,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
