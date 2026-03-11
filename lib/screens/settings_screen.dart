import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/lang_extensions.dart';
import 'about_app_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _mostrarOpcionesDeIdioma(BuildContext context) {
    final langProvider = context.read<LanguageProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.loc.language,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color : Theme.of(context).colorScheme.onSurface
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildOpcionIdioma(
                          context,
                          context.loc.languageCatalan,
                          'ca',
                          langProvider,
                        ),
                        _buildOpcionIdioma(
                          context,
                          context.loc.languageSpanish,
                          'es',
                          langProvider,
                        ),
                        _buildOpcionIdioma(
                          context,
                          context.loc.languageEnglish,
                          'en',
                          langProvider,
                        ),
                        _buildOpcionIdioma(
                          context,
                          context.loc.languageArabic,
                          'ar',
                          langProvider,
                        ),
                        _buildOpcionIdioma(
                          context,
                          context.loc.languageFrench,
                          'fr',
                          langProvider,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text(context.loc.settings)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSwitch(
              titulo: context.loc.highContrast,
              valor: context.watch<ThemeProvider>().isHighContrast,
              onChanged: (val) {
                context.read<ThemeProvider>().toggleHighContrast();
              },
            ),
            Divider(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
              thickness: 1,
            ),
            _buildSwitch(
              titulo: context.loc.darkMode,
              valor: context.watch<ThemeProvider>().isDarkMode,
              onChanged: (val) {
                context.read<ThemeProvider>().toggleTheme();
              },
            ),
            Divider(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
              thickness: 1,
            ),
            _buildSwitch(
              titulo: context.loc.blindMode,
              valor: context.watch<ThemeProvider>().isColorBlind,
              onChanged: (val) {
                context.read<ThemeProvider>().toggleColorBlind();
              },
            ),
            Divider(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
              thickness: 1,
            ),
            _buildDesplegable(context),
            Divider(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
              thickness: 1,
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 5.0,
              ),
              leading: Icon(Icons.info_outline),
              title: Text(
                context.loc.aboutApp,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutAppScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch({
    required String titulo,
    required bool valor,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.w500)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      trailing: Switch(
        value: valor,
        onChanged: onChanged,
        activeThumbColor: Theme.of(context).colorScheme.primary,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  Widget _buildDesplegable(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 5.0,
      ),
      leading: const Icon(Icons.language),
      title: Text(
        context.loc.language,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        context.loc.actual,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_down,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: () => _mostrarOpcionesDeIdioma(context),
    );
  }

  Widget _buildOpcionIdioma(
    BuildContext context,
    String nombre,
    String codigo,
    LanguageProvider provider,
  ) {
    return ListTile(
      title: Text(nombre),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      onTap: () {
        provider.changeLanguage(codigo);
        Navigator.pop(context);
      },
    );
  }
}
