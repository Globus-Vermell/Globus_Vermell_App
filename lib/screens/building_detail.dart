import 'package:flutter/material.dart';
import '../models/buildings.dart';

class BuildingDetailScreen extends StatelessWidget {
  final Buildings building;

  const BuildingDetailScreen({super.key, required this.building});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // AppBar con el título
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Detalls del edifici',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        image:
                            (building.images != null &&
                                building.images!.isNotEmpty)
                            ? DecorationImage(
                                image: NetworkImage(building.images!.first),
                                fit: BoxFit.cover,
                              )
                            : null, // Si no hay imagen, no ponemos nada

                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.grey[300]!.withOpacity(0.3),
                            Colors.grey[400]!,
                          ],
                        ),
                      ),
                      child:
                          (building.images == null || building.images!.isEmpty)
                          ? Icon(
                              Icons.image_outlined,
                              color: Colors.grey[500],
                              size: 80,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            // Nombre del edificio
                            Text(
                              building.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Contenido principal
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chip de distancia
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF1F0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Color(0xFFE41E26),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '0.6 km de distància',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFE41E26),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Título "Més informació"
                      Text(
                        'Més informació',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Descripción
                      Text(
                        building.description.isNotEmpty
                            ? building.description
                            : "No hi ha descripció disponible per a aquest edifici.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Botón "Com arribar"
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Acción para navegar
                            print("Navegando a: ");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE41E26),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.navigation, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Com arribar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Información adicional en cards discretas
                      _InfoCard(
                        icon: Icons.location_on_outlined,
                        label: 'Ubicación',
                        value: building.location,
                      ),

                      const SizedBox(height: 12),

                      _InfoCard(
                        icon: Icons.calendar_today_outlined,
                        label: 'Año de construcción',
                        value: '${building.construction_year}',
                      ),

                      const SizedBox(height: 12),

                      // Aquí ira el arquitecto que aún no lo tenemos en el model
                      if (building.surface_area > 0) ...[
                        _InfoCard(
                          icon: Icons.square_foot_outlined,
                          label: 'Superfície',
                          value: '${building.surface_area} m²',
                        ),
                        const SizedBox(height: 12),
                      ],

                      if (building.typologyName != null &&
                          building.typologyName!.isNotEmpty) ...[
                        _InfoCard(
                          icon: Icons.category_outlined,
                          label: 'Tipología',
                          value: building.typologyName!,
                        ),
                        const SizedBox(height: 12),
                      ],

                      if (building.protectionName != null &&
                          building.protectionName!.isNotEmpty) ...[
                        _InfoCard(
                          icon: Icons.shield_outlined,
                          label: 'Protección',
                          value: building.protectionName!,
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Card de información discreta
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
