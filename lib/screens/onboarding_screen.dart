import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../providers/theme_provider.dart'; 
import 'package:globus_vermell_app/screens/bottom_bar.dart';
import '../utils/lang_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  final bool fromSettings;

  const OnboardingScreen({super.key, this.fromSettings = false});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.domain_rounded,
      'title': context.loc.onboardingTitle1,
      'description': context.loc.onboardingDesc1,
    },
    {
      'icon': Icons.filter_alt_outlined,
      'title': context.loc.onboardingTitle2,
      'description': context.loc.onboardingDesc2,
    },
    {
      'icon': Icons.location_on_outlined,
      'title': context.loc.onboardingTitle3,
      'description': context.loc.onboardingDesc3,
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    if (widget.fromSettings) {
      Navigator.pop(context);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstTime', false);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomBar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isPureHighContrast = themeProvider.isHighContrast && !themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: colores.surface,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => _finishOnboarding(),
                style: TextButton.styleFrom(
                  foregroundColor: isPureHighContrast ? Colors.black : colores.onSurfaceVariant,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  context.loc.skip,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isPureHighContrast ? Colors.white : colores.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: isPureHighContrast ? Border.all(color: Colors.black, width: 2.0) : null,
                          ),
                          child: Icon(
                            _pages[index]['icon'],
                            size: 48,
                            color: isPureHighContrast ? Colors.black : colores.primary,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          _pages[index]['title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isPureHighContrast ? Colors.black : colores.onSurface,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _pages[index]['description'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: isPureHighContrast ? Colors.black : colores.onSurface,
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? (isPureHighContrast ? Colors.black : colores.primary)
                        : (isPureHighContrast ? Colors.transparent : colores.outline.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(4),
                    border: isPureHighContrast ? Border.all(color: Colors.black, width: 1.5) : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: TextButton.icon(
                        onPressed: _previousPage,
                        icon: const Icon(Icons.chevron_left, size: 20),
                        label: Text(context.loc.back),
                        style: TextButton.styleFrom(
                          foregroundColor: isPureHighContrast ? Colors.black : colores.onSurfaceVariant,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: _currentPage == 0 ? 0 : 1,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPureHighContrast ? Colors.white : colores.primary,
                        foregroundColor: isPureHighContrast ? Colors.black : colores.onPrimary,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: _currentPage == 0 ? 64 : 0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: isPureHighContrast ? const BorderSide(color: Colors.black, width: 2.0) : BorderSide.none,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentPage == _pages.length - 1
                                ? context.loc.start
                                : context.loc.next,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isPureHighContrast ? Colors.black : colores.onPrimary,
                            ),
                          ),
                          if (_currentPage < _pages.length - 1) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right, 
                              size: 20, 
                              color: isPureHighContrast ? Colors.black : colores.onPrimary,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (_currentPage == 0) const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}