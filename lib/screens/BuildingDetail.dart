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

  // LEYENDA
  void _showLegend(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Llegenda d'Icones"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLegendItem(Icons.category, "Tipologia", Colors.blue),
              const SizedBox(height: 8),
              _buildLegendItem(Icons.security, "Protecció", Colors.orange),
              const SizedBox(height: 8),
              _buildLegendItem(
                Icons.calendar_today,
                "Any Const.",
                Colors.purple,
              ),
              const SizedBox(height: 8),
              _buildLegendItem(Icons.square_foot, "Superfície", Colors.green),
              const SizedBox(height: 8),
              _buildLegendItem(Icons.construction, "Reforma", Colors.brown),
              const SizedBox(height: 8),
              _buildLegendItem(Icons.emoji_events, "Premi", Colors.amber[800]!),
              const SizedBox(height: 8),
            ],
          ),
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
                  // 1. TÍTULO
                  Text(
                    building.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2. BADGE DE PUBLICACIÓN
                  if (building.publications.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE41E26).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE41E26).withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_stories,
                            size: 20,
                            color: Color(0xFFE41E26),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Publicat a:",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.red[300],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  building.publications.first,
                                  style: const TextStyle(
                                    color: Color(0xFFB71C1C),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // 3. UBICACIÓN
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
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

                  // 4. CABECERA DE CHIPS + INFO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Fitxa Tècnica",
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

                  // 5. WRAP CON LOS CHIPS
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // DATOS BÁSICOS
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

                      // Reformas (Marrón)
                      ...building.reforms.map(
                        (ref) => _buildInfoChip(
                          Icons.construction,
                          ref,
                          Colors.brown,
                        ),
                      ),

                      // Premios (Ámbar / Oro)
                      ...building.prizes.map(
                        (premio) => _buildInfoChip(
                          Icons.emoji_events,
                          premio,
                          Colors.amber[800]!,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // 6. DESCRIPCIÓN
                  const Text(
                    "Descripció",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  (building.description.isNotEmpty &&
                          building.description != 'Sin descripción')
                      ? Text(
                          building.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            height: 1.6,
                          ),
                        )
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
                                Icons.description_outlined,
                                size: 40,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "No hi ha descripció disponible",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),

                  const SizedBox(height: 24),
                  const Divider(),

                  if (building.architects.isNotEmpty)
                    Theme(
                      // Quitamos las líneas divisorias por defecto
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            238,
                            164,
                            177,
                          ).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color.fromARGB(
                              255,
                              238,
                              164,
                              177,
                            ).withOpacity(0.2),
                          ),
                        ),
                        child: ExpansionTile(
                          iconColor: Color.fromARGB(255, 225, 50, 82),
                          collapsedIconColor: Color.fromARGB(
                            255,
                            238,
                            164,
                            177,
                          ),
                          title: const Text(
                            "Arquitectes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color.fromARGB(255, 225, 50, 82),
                            ),
                          ),
                          leading: const Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 225, 50, 82),
                          ),
                          childrenPadding: const EdgeInsets.only(bottom: 12),
                          children: building.architects.map((arq) {
                            return ListTile(
                              visualDensity: VisualDensity.compact,
                              leading: const Icon(
                                Icons.arrow_right,
                                color: Color.fromARGB(255, 225, 50, 82),
                              ),
                              title: Text(
                                arq,
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 15,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
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

  // WIDGETS AUXILIARES

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
            // Carrusel
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

            // Puntitos
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

            // Chip Distancia
            Positioned(
              bottom: 16,
              left: 16,
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
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.8),
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
