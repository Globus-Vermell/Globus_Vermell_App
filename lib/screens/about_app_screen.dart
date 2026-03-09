import 'package:flutter/material.dart';
import 'package:globus_vermell_app/utils/lang_extensions.dart';
import 'onboarding_screen.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.loc.aboutApp,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE41E26).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_outlined,
                size: 48,
                color: Color(0xFFE41E26),
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              'Globus Vermell',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(context.loc.appSubtitle, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text("${context.loc.appVersion} 1.0.0"),

            const SizedBox(height: 20),
            Text(context.loc.appDescription1, textAlign: TextAlign.justify),
            const SizedBox(height: 20),
            Text(context.loc.appDescription2, textAlign: TextAlign.justify),
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
                icon: const Icon(Icons.menu_book),
                label: Text(context.loc.viewTutorial),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE41E21),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.grey[300], thickness: 1),
            buildInfoRow("version", "1.0.0"),
            buildInfoRow("prueba", "Denis"),
            const SizedBox(height: 40),
            Text(context.loc.developedWith, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

Widget buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 1.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ],
    ),
  );
}
