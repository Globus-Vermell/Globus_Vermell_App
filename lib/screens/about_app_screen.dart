import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart'; 
import 'package:globus_vermell_app/utils/lang_extensions.dart';
import 'onboarding_screen.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isHighContrast = themeProvider.isHighContrast;

    return Scaffold(
      backgroundColor: colores.surface,
      appBar: AppBar(
        backgroundColor: colores.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colores.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.loc.aboutApp,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colores.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isHighContrast ? colores.surface : colores.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: isHighContrast ? Border.all(color: colores.onSurface, width: 2.0) : null,
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 48,
                  color: isHighContrast ? colores.onSurface : colores.primary,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                'Globus Vermell',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: colores.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.loc.appSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: colores.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              Text(
                "${context.loc.appVersion} 1.0.0",
                style: TextStyle(color: colores.onSurfaceVariant),
              ),

              const SizedBox(height: 20),
              Text(
                context.loc.appDescription1,
                textAlign: TextAlign.justify,
                style: TextStyle(color: colores.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              Text(
                context.loc.appDescription2,
                textAlign: TextAlign.justify,
                style: TextStyle(color: colores.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const OnboardingScreen(fromSettings: true),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.menu_book, 
                    color: isHighContrast ? colores.onSurface : colores.onPrimary, 
                  ),
                  label: Text(context.loc.viewTutorial),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isHighContrast ? colores.surface : colores.primary, 
                    foregroundColor: isHighContrast ? colores.onSurface : colores.onPrimary, 
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: isHighContrast ? BorderSide(color: colores.onSurface, width: 2.0) : BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Divider(
                color: isHighContrast ? colores.onSurface : colores.outline.withValues(alpha: 0.2), 
                thickness: isHighContrast ? 2 : 1, 
              ),
              const SizedBox(height: 20),
              Text(
                context.loc.developedWith,
                textAlign: TextAlign.center,
                style: TextStyle(color: colores.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildInfoRow(String label, String value, ColorScheme colores) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 1.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: colores.onSurfaceVariant),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: colores.onSurface,
          ),
        ),
      ],
    ),
  );
}