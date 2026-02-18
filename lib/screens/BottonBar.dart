import 'package:flutter/material.dart';

import 'BuildingList.dart';
import 'CategoriesScreen.dart';
import 'HomeScreen.dart';

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
    const HomeScreen(),
    const CategoriesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem( icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem( icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem( icon: Icon(Icons.category), label: 'Categoria'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      )
    );
}
}