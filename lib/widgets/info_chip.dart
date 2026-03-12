import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isHighContrast = context.watch<ThemeProvider>().isHighContrast;
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final isPureHighContrast = isHighContrast && !isDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isPureHighContrast ? Colors.white : color.withValues(alpha: 0.1), 
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isPureHighContrast ? Colors.black : color.withValues(alpha: 0.2),
          width: isPureHighContrast ? 2.0 : 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon, 
            size: 16, 
            color: isPureHighContrast ? Colors.black : color, 
          ), 
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: isPureHighContrast ? Colors.black : color, 
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}