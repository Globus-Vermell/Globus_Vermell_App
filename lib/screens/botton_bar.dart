import 'package:flutter/material.dart';
import 'package:globus_vermell_app/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../utils/app_text.dart';
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
    final codigoIdioma = context.watch<LanguageProvider>().currentLocale.languageCode;
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.map), label: AppTexts.getText(codigoIdioma, 'mapa'),),
          BottomNavigationBarItem(icon: const Icon(Icons.menu_book), label: AppTexts.getText(codigoIdioma, 'publicaciones'),),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: AppTexts.getText(codigoIdioma, 'configuracion')),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
