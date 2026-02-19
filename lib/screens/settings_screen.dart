import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_text.dart';

class SettingsScreen extends StatefulWidget {

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    final codigoIdioma = context.watch<LanguageProvider>().currentLocale.languageCode;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppTexts.getText(codigoIdioma, 'configuracion'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSwitch(
                titulo: AppTexts.getText(codigoIdioma, 'alto_contraste'),
                valor: context.watch<ThemeProvider>().isHighContrast,
                onChanged: (val) {
                  context.read<ThemeProvider>().toggleHighContrast();
                },
              ),
              const SizedBox(height: 15),
              _buildSwitch(
                titulo: AppTexts.getText(codigoIdioma, 'modo_oscuro'),
                valor: context.watch<ThemeProvider>().isDarkMode,
                onChanged: (val) {
                  context.read<ThemeProvider>().toggleTheme();
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
    final langProvider = context.read<LanguageProvider>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        shape: const Border(),
        title: Text(AppTexts.getText(langProvider.currentLocale.languageCode, 'idioma'), style: TextStyle(fontWeight: FontWeight.w500)),
        leading: const Icon(Icons.language),
        children: [
          ListTile(
            title: const Text("Español"),
            onTap: () => langProvider.changeLanguage('es'),
          ),
          ListTile(
            title: const Text("English"),
            onTap: () => langProvider.changeLanguage('en'),
          ),
          ListTile(
            title: const Text("Català"),
            onTap: () => langProvider.changeLanguage('ca'),
          ),
        ],
      ),
    );
  }
}