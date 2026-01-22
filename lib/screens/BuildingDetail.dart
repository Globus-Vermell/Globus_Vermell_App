import 'package:flutter/material.dart';
import '../models/buildings.dart';
import '../controllers/BuildingDetailController.dart';

class BuildingDetailScreen extends StatefulWidget {
  final Buildings building;

  const BuildingDetailScreen({Key? key, required this.building})
    : super(key: key);

  @override
  State<BuildingDetailScreen> createState() => _BuildingDetailScreenState();
}

class _BuildingDetailScreenState extends State<BuildingDetailScreen> {
  late final BuildingDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BuildingDetailController(widget.building);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final building = widget.building;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(building),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título y Ubicación
                  Text(
                    building.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          building.location,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Fichas de información (Tags)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (building.typologyName != null)
                        _buildInfoChip(
                          Icons.category,
                          building.typologyName!,
                          Colors.blue,
                        ),
                      if (building.protectionName != null)
                        _buildInfoChip(
                          Icons.security,
                          building.protectionName!,
                          Colors.orange,
                        ),
                      _buildInfoChip(
                        Icons.calendar_today,
                        '${building.construction_year}',
                        Colors.purple,
                      ),
                      if (building.surface_area > 0)
                        _buildInfoChip(
                          Icons.square_foot,
                          '${building.surface_area} m²',
                          Colors.green,
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // Descripción
                  const Text(
                    "Descripció",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    building.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      // Botón flotante para acción principal (ej. Mapa)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _controller.openMap,
        backgroundColor: const Color(0xFFE41E26),
        icon: const Icon(Icons.map, color: Colors.white),
        label: const Text(
          "Veure al mapa",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // Widget para la barra superior con imagen
  Widget _buildSliverAppBar(Buildings building) {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.8),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Carrusel de Imágenes (Si hay)
            if (building.images != null && building.images!.isNotEmpty)
              PageView.builder(
                itemCount: building.images!.length,
                onPageChanged: _controller.onPageChanged,
                itemBuilder: (context, index) {
                  return Image.network(
                    building.images![index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              )
            else
              Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),

            // Indicador de puntitos para el carrusel
            if (building.images != null && building.images!.length > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ValueListenableBuilder<int>(
                  valueListenable: _controller.currentImageIndex,
                  builder: (context, index, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        building.images!.length,
                        (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para los chips de información
  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
