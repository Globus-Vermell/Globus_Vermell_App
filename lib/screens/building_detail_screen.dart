import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:globus_vermell_app/utils/get_distance.dart';
import 'package:latlong2/latlong.dart';
import '../models/building_model.dart';
import '../controllers/building_detail_controller.dart';
import '../services/publications_service.dart';
import '../utils/lang_extensions.dart';
import '../widgets/info_chip.dart';
import '../widgets/section_header.dart';
import 'publication_detail_screen.dart';

class BuildingDetailScreen extends StatefulWidget {
  final Building building;
  final LatLng? location;

  const BuildingDetailScreen({
    super.key,
    required this.building,
    this.location,
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

      final publication = await _controller.getPublicationByTitle(title);

      if (!mounted) return;
      Navigator.pop(context);

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
        SnackBar(
          content: Text(context.loc.pubNotFound),
          backgroundColor: const Color(0xFFE41E26),
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
        title: Text(context.loc.iconsLegend, style: const TextStyle(color: Color(0xFFE41E26)),),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLegendItem(
                Icons.auto_stories_rounded,
                context.loc.publication,
                const Color(0xFFE41E26),
              ),
              const SizedBox(height: 12),
              _buildLegendItem(Icons.category, context.loc.typology, Colors.blue),
              const SizedBox(height: 12),
              _buildLegendItem(Icons.security, context.loc.protection, Colors.orange),
              const SizedBox(height: 12),
              _buildLegendItem(
                Icons.calendar_today,
                context.loc.yearConst,
                Colors.purple,
              ),
              const SizedBox(height: 12),
              _buildLegendItem(Icons.square_foot, context.loc.surface, Colors.green),
              const SizedBox(height: 12),
              _buildLegendItem(Icons.construction, context.loc.renovation, Colors.brown),
              const SizedBox(height: 12),
              _buildLegendItem(Icons.emoji_events, context.loc.award, Colors.amber),
              const SizedBox(height: 12),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.loc.understood,
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
    final location = widget.location;

    String distanciaPorDefecto = getDistance(location, building);

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

                  SectionHeader(
                    title: context.loc.techSheet,
                    onInfo: () => _showLegend(context),
                  ),
                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (building.typologyName.isNotEmpty)
                        InfoChip(
                          icon: Icons.category,
                          label: building.typologyName,
                          color: Colors.blue,
                        ),
                      if (building.protectionName.isNotEmpty)
                        InfoChip(
                          icon: Icons.security,
                          label: building.protectionName,
                          color: Colors.orange,
                        ),
                      InfoChip(
                        icon: Icons.calendar_today,
                        label: '${building.constructionYear}',
                        color: Colors.purple,
                      ),
                      if (building.surfaceArea > 0)
                        InfoChip(
                          icon: Icons.square_foot,
                          label: '${building.surfaceArea} m²',
                          color: Colors.green,
                        ),
                      ...building.reforms.map(
                        (ref) => InfoChip(
                          icon: Icons.construction,
                          label: ref,
                          color: Colors.brown,
                        ),
                      ),
                      ...building.prizes.map(
                        (premio) => InfoChip(
                          icon: Icons.emoji_events,
                          label: premio,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  SectionHeader(title: context.loc.description),
                  const SizedBox(height: 16),

                  (building.description.isNotEmpty &&
                          building.description != context.loc.noDescription)
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
                                context.loc.noDescription,
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
                          title: Text(
                            context.loc.architects,
                            style: const TextStyle(
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

                  if (building.uses.isNotEmpty)
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
                          title: Text(
                            context.loc.uses,
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
                          children: building.uses.map((uso) {
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
        label: Text(
          context.loc.viewInMap,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(Building building, String distanciaPorDefecto) {
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
            if (building.images.isNotEmpty)
              PageView.builder(
                itemCount: building.images.length,
                onPageChanged: _controller.onPageChanged,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: building.images[index],
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

            if (building.images.length > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ValueListenableBuilder<int>(
                  valueListenable: _controller.currentImageIndex,
                  builder: (context, index, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        building.images.length,
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
}