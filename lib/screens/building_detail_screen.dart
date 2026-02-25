import 'package:flutter/material.dart';
import 'package:globus_vermell_app/utils/get_distancia.dart';
import 'package:latlong2/latlong.dart';
import '../models/building_model.dart';
import '../controllers/building_detail_controller.dart';
import '../services/publications_service.dart';
import 'publication_detail_screen.dart'; 

class BuildingDetailScreen extends StatefulWidget {
  final Buildings building;
  final LatLng? miUbicacion;

  const BuildingDetailScreen({
    super.key,
    required this.building,
    this.miUbicacion,
  });

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

  Future<void> _openPublication(String title) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFE41E26)),
      ),
    );

    try {
      final publications = await PublicationService().getPublications();
      
      if (!mounted) return;
      
      Navigator.pop(context);

      final publication = publications.firstWhere(
        (p) => p.title.trim().toLowerCase() == title.trim().toLowerCase(),
        orElse: () => throw Exception('Publicació no trobada'),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PublicationDetailScreen(publication: publication),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No s\'ha pogut trobar aquesta publicació.'),
          backgroundColor: Color(0xFFE41E26),
        ),
      );
    }
  }

  void _showLegend(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Llegenda d'Icones"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLegendItem(
                Icons.auto_stories_rounded,
                "Publicació",
                const Color(0xFFE41E26),
              ),
              const SizedBox(height: 12),
              _buildLegendItem(Icons.category, "Tipologia", Colors.blue),
              const SizedBox(height: 12),
              _buildLegendItem(Icons.security, "Protecció", Colors.orange),
              const SizedBox(height: 12),
              _buildLegendItem(
                Icons.calendar_today,
                "Any Const.",
                Colors.purple,
              ),
              const SizedBox(height: 12),
              _buildLegendItem(Icons.square_foot, "Superfície", Colors.green),
              const SizedBox(height: 12),
              _buildLegendItem(Icons.construction, "Reforma", Colors.brown),
              const SizedBox(height: 12),
              _buildLegendItem(Icons.emoji_events, "Premi", Colors.amber[800]!),
              const SizedBox(height: 12),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Entesos",
              style: TextStyle(
                color: Color(0xFFE41E26),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final building = widget.building;
    final ubicacion = widget.miUbicacion;

    String distanciaPorDefecto = getDistancia(ubicacion, building, context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(building, distanciaPorDefecto),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    building.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          building.location,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  if (building.publications.isNotEmpty)
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => _openPublication(building.publications.first),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE41E26).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_stories_rounded,
                              size: 18,
                              color: Color(0xFFE41E26),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                building.publications.first,
                                style: const TextStyle(
                                  color: Color(0xFFE41E26),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 32),
                  Divider(color: Colors.grey[200], thickness: 1),
                  const SizedBox(height: 32),

                  _buildSectionHeader(
                    "FITXA TÈCNICA",
                    onInfo: () => _showLegend(context),
                  ),
                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
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
                        '${building.constructionYear}',
                        Colors.purple,
                      ),
                      if (building.surfaceArea > 0)
                        _buildInfoChip(
                          Icons.square_foot,
                          '${building.surfaceArea} m²',
                          Colors.green,
                        ),
                      ...building.reforms.map(
                        (ref) => _buildInfoChip(
                          Icons.construction,
                          ref,
                          Colors.brown,
                        ),
                      ),
                      ...building.prizes.map(
                        (premio) => _buildInfoChip(
                          Icons.emoji_events,
                          premio,
                          Colors.amber[800]!,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  _buildSectionHeader("DESCRIPCIÓ"),
                  const SizedBox(height: 16),

                  (building.description.isNotEmpty &&
                          building.description != 'Sense descripció disponible')
                      ? Text(
                          building.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            height: 1.6,
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.description_outlined,
                                size: 40,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Sense descripció disponible",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),

                  const SizedBox(height: 40),

                  // 5. ARQUITECTOS
                  if (building.architects.isNotEmpty)
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.15),
                          ),
                        ),
                        child: ExpansionTile(
                          iconColor: const Color(0xFFE41E26),
                          collapsedIconColor: const Color(0xFFE41E26),
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: const Text(
                            "Arquitectes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFFE41E26),
                            ),
                          ),
                          leading: const Icon(
                            Icons.person_rounded,
                            color: Color(0xFFE41E26),
                          ),
                          children: building.architects.map((arq) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 12,
                                left: 16,
                                right: 16,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.subdirectory_arrow_right_rounded,
                                    color: Color(0xFFE41E26),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      arq,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  if (building.usos.isNotEmpty)
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.15),
                          ),
                        ),
                        child: ExpansionTile(
                          iconColor: const Color(0xFFE41E26),
                          collapsedIconColor: const Color(0xFFE41E26),
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: const Text(
                            "Usos",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFFE41E26),
                            ),
                          ),
                          leading: const Icon(
                            Icons.domain_rounded,
                            color: Color(0xFFE41E26),
                          ),
                          children: building.usos.map((uso) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 12,
                                left: 16,
                                right: 16,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.subdirectory_arrow_right_rounded,
                                    color: Color(0xFFE41E26),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      uso,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context, 'show_map');
        },
        backgroundColor: const Color(0xFFE41E26),
        elevation: 4,
        icon: const Icon(Icons.map_rounded, color: Colors.white),
        label: const Text(
          "Veure al mapa",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }


  Widget _buildSectionHeader(String title, {VoidCallback? onInfo}) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFFE41E26),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: Colors.black54,
          ),
        ),
        if (onInfo != null) ...[
          const Spacer(),
          InkWell(
            onTap: onInfo,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSliverAppBar(Buildings building, String distanciaPorDefecto) {
    return SliverAppBar(
      expandedHeight: 320.0,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.bottomCenter,
          children: [
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
                color: Colors.grey[100],
                child: Center(
                  child: Icon(
                    Icons.broken_image_rounded,
                    size: 60,
                    color: Colors.grey[300],
                  ),
                ),
              ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
                  ),
                ),
              ),
            ),

            if (building.images != null && building.images!.length > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ValueListenableBuilder<int>(
                  valueListenable: _controller.currentImageIndex,
                  builder: (context, index, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        building.images!.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == index ? 20 : 8, 
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: i == index
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            Positioned(
              bottom: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.near_me_rounded,
                      color: Color(0xFFE41E26),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      distanciaPorDefecto,
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
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color.withValues(alpha: 0.8)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color.withValues(alpha: 0.9),
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