import 'package:flutter/material.dart';
import 'building_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Un color de fondo suavecito
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "¡Bienvenido!", // Título de la Home
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // --- APARTADO 1: EXPLORAR MAPA (Lleva a la Lista) ---
              _MenuButton(
                title: "Explorar Mapa",
                icon: Icons.map_outlined,
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListaEdificacionesScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // --- APARTADO 2: ---
              _MenuButton(
                title: "Segundo Apartado",
                icon: Icons.star_border,
                color: Colors.orangeAccent,
                onTap: () {
                  // Aquí pondremos la navegación del segundo botón que aún no tiene ningún tipo de funcionalidad
                  print("Click en botón 2");
                },
              ),

              const SizedBox(height: 20),

              // --- APARTADO 3: ---
              _MenuButton(
                title: "Tercer Apartado",
                icon: Icons.person_outline,
                color: Colors.greenAccent,
                onTap: () {
                  // Aquí pondremos la navegación del tercer botón que le pasa lo mismo que al segundo
                  print("Click en botón 3");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget personalizado para que los botones se vean iguales y bonitos
class _MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(20), // Bordes redonditos
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
