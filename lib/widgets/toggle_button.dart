import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const ToggleButton({
    super.key,
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ¡Nuestro atajito de colores! ✨
    final colores = Theme.of(context).colorScheme;

    return Material(
      // Pedacito 2: Fondos adaptables
      color: isSelected ? colores.primary : colores.surface,
      elevation: isSelected ? 0 : 2,
      borderRadius: BorderRadius.circular(8),
      // Pedacito 3: Sombrita mágica
      shadowColor: colores.shadow.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                // Pedacito 4: Color blanco si está activo, gris inteligente si no
                color: isSelected ? Colors.white : colores.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 8),
              //Hacemos flexible el texto para evitar romper la pantalla traduciendo
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    // Pedacito 4: Color blanco si está activo, gris inteligente si no
                    color: isSelected ? Colors.white : colores.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}