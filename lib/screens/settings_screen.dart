import 'package:flutter/material.dart';
import 'package:globus_vermell_app/theme/theme.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Configuració',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSwitch(
                titulo: "Modo alto contraste",
                valor: context.watch<ThemeProvider>().isHighContrast,
                onChanged: (val) {
                  Provider.of<ThemeProvider>(context, listen: false).toggleHighContrast();
                },
              ),
              const SizedBox(height: 15),
              _buildSwitch(
                titulo: "Modo Oscuro",
                valor: context.watch<ThemeProvider>().isDarkMode,
                onChanged: (val) {
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                },
              ),
              const SizedBox(height: 15),
              _buildDesplegable(),
            ],
          ),
        ),
    );
  }

  Widget _buildSwitch({
    required String titulo,
    required bool valor,
    required ValueChanged<bool> onChanged
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.w500)),
        shape: const Border(),
        onTap: null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
        trailing: Switch(
          value: valor,
          onChanged: onChanged,
          activeThumbColor: Colors.redAccent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
    );
  }

  Widget _buildDesplegable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        shape: const Border(),
        title: const Text("Idioma", style: TextStyle(fontWeight: FontWeight.w500)),
        children: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Wow"),
          ),
        ],
      ),
    );
  }
}