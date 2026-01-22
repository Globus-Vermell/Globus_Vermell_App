import 'package:flutter/material.dart';
import '../models/buildings.dart';
import '../controllers/BuildingDetailController.dart'; // Asegúrate de que este import sea correcto (minúsculas)

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

  // --- 1. FUNCIÓN PARA MOSTRAR LA LEYENDA (POPUP) ---
  void _showLegend(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Llegenda d'Icones"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegendItem(
              Icons.category,
              "Tipologia Arquitectònica",
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildLegendItem(
              Icons.security,
              "Nivell de Protecció",
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildLegendItem(
              Icons.calendar_today,
              "Any de Construcció",
              Colors.purple,
            ),
            const SizedBox(height: 12),
            _buildLegendItem(
              Icons.square_foot,
              "Superfície Total",
              Colors.green,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Entesos",
              style: TextStyle(color: Color(0xFFE41E26)),
            ),
          ),
        ],
      ),
    );
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
                  // Título
                  Text(
                    building.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Ubicación
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

                  // --- 2. CABECERA CON BOTÓN DE INFO ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Dades Tècniques",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                        ),
                        onPressed: () => _showLegend(context),
                        tooltip: "Veure llegenda",
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

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

                  // Título de la sección
                  const Text(
                    "Descripció",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Si tiene descripción y no está vacía, la mostramos
                  (building.description.isNotEmpty)
                      ? Text(
                          building.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            height: 1.6,
                          ),
                        )
                      // Si NO tiene descripción, mostramos este aviso bonito
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 40,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "No hi ha descripció disponible",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Estem treballant per afegir més informació aviat.",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      // Botón flotante para acción principal
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

  // Widget para la barra superior con imagen y chip de distancia
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
            // Carrusel de Imágenes
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

            // Indicador de puntitos
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

            // --- 3. CHIP DE DISTANCIA 0.6KM ---
            Positioned(
              bottom: 16, // Altura desde abajo
              left: 16, // Distancia desde la izquierda
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.navigation, color: Colors.grey[600], size: 14),
                    const SizedBox(width: 4),
                    Text(
                      "0.6 km",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para cada ítem de la leyenda
  Widget _buildLegendItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
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
