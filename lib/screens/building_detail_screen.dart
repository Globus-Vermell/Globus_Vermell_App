import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:globus_vermell_app/services/publications_service.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:globus_vermell_app/utils/get_distance.dart';
import 'package:globus_vermell_app/widgets/empty_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/building/building_entity.dart';
import '../controllers/building_detail_controller.dart';
import '../utils/lang_extensions.dart';
import '../widgets/info_chip.dart';
import '../widgets/section_header.dart';
import 'publication_detail_screen.dart';
import '../widgets/translated_text.dart';

class BuildingDetailScreen extends StatefulWidget {
  final Building building;
  final LatLng location;

  const BuildingDetailScreen({
    super.key,
    required this.building,
    required this.location,
  });

  @override
  State<BuildingDetailScreen> createState() => _BuildingDetailScreenState();
}

class _BuildingDetailScreenState extends State<BuildingDetailScreen> {
  late final BuildingDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BuildingDetailController(
      widget.building,
      context.read<PublicationService>(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openPublication(String title) async {
    final colores = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: colores.primary)),
    );

    try {
      final publication = await _controller.getPublicationByTitle(title);

      if (!mounted) return;
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PublicationDetailScreen(publication: publication),
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
          backgroundColor: colores.error,
        ),
      );
    }
  }

  void _showLegend(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isHighContrast = themeProvider.isHighContrast;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colores.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isHighContrast
              ? BorderSide(color: colores.onSurface, width: 2.0)
              : BorderSide.none,
        ),
        title: Text(
          context.loc.iconsLegend,
          style: TextStyle(
            color: isHighContrast ? colores.onSurface : colores.primary,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLegendItem(
                Icons.auto_stories_rounded,
                context.loc.publication,
                colores.primary,
                colores,
                isHighContrast, // ¡Pasamos la variable universal!
              ),
              const SizedBox(height: 12),
              _buildLegendItem(
                Icons.category,
                context.loc.typology,
                Colors.blue,
                colores,
                isHighContrast,
              ),
              const SizedBox(height: 12),
              _buildLegendItem(
                Icons.security,
                context.loc.protection,
                Colors.orange,
                colores,
                isHighContrast,
              ),
              const SizedBox(height: 12),
              _buildLegendItem(
                Icons.calendar_today,
                context.loc.yearConst,
                Colors.purple,
                colores,
                isHighContrast,
              ),
              const SizedBox(height: 12),
              _buildLegendItem(
                Icons.square_foot,
                context.loc.surface,
                Colors.green,
                colores,
                isHighContrast,
              ),
              const SizedBox(height: 12),
              _buildLegendItem(
                Icons.construction,
                context.loc.renovation,
                Colors.brown,
                colores,
                isHighContrast,
              ),
              const SizedBox(height: 12),
              _buildLegendItem(
                Icons.emoji_events,
                context.loc.award,
                Colors.amber,
                colores,
                isHighContrast,
              ),
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
                color: isHighContrast ? colores.onSurface : colores.primary,
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
    final colores = Theme.of(context).colorScheme;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isHighContrast = themeProvider.isHighContrast;

    String distanciaPorDefecto = getDistance(location, building);

    return Scaffold(
      backgroundColor: colores.surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(building, distanciaPorDefecto, colores),
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
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      color: colores.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: colores.onSurfaceVariant,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          building.location,
                          style: TextStyle(
                            fontSize: 15,
                            color: colores.onSurfaceVariant,
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
                      onTap: () =>
                          _openPublication(building.publications.first),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isHighContrast
                              ? colores.surface
                              : colores.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(50),
                          border: isHighContrast
                              ? Border.all(color: colores.onSurface, width: 2.0)
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_stories_rounded,
                              size: 18,
                              color: isHighContrast
                                  ? colores.onSurface
                                  : colores.primary,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                building.publications.first,
                                style: TextStyle(
                                  color: isHighContrast
                                      ? colores.onSurface
                                      : colores.primary,
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
                  Divider(
                    color: colores.outline.withValues(alpha: 0.2),
                    thickness: 1,
                  ),
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
                      ? TranslatedText(
                          text: building.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                            color: colores.onSurfaceVariant,
                            height: 1.6,
                          ),
                        )
                      : EmptyCard(
                          icon: Icons.description_outlined,
                          message: context.loc.noDescription,
                        ),

                  const SizedBox(height: 40),

                  if (building.architects.isNotEmpty)
                    _buildExpandableSection(
                      title: context.loc.architects,
                      icon: Icons.person_rounded,
                      items: building.architects,
                      colores: colores,
                      isHighContrast: isHighContrast,
                    ),

                  const SizedBox(height: 16),

                  if (building.uses.isNotEmpty)
                    _buildExpandableSection(
                      title: context.loc.uses,
                      icon: Icons.domain_rounded,
                      items: building.uses,
                      colores: colores,
                      isHighContrast: isHighContrast,
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
        backgroundColor: isHighContrast ? colores.surface : colores.primary,
        elevation: 4,
        shape: isHighContrast
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: colores.onSurface, width: 2.0),
              )
            : null,
        icon: Icon(
          Icons.map_rounded,
          color: isHighContrast ? colores.onSurface : colores.onPrimary,
        ),
        label: Text(
          context.loc.viewInMap,
          style: TextStyle(
            color: isHighContrast ? colores.onSurface : colores.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required List<String> items,
    required ColorScheme colores,
    required bool isHighContrast,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: isHighContrast
              ? colores.surface
              : colores.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHighContrast
                ? colores.onSurface
                : colores.outline.withValues(alpha: 0.15),
            width: isHighContrast ? 2.0 : 1.0,
          ),
        ),
        child: ExpansionTile(
          iconColor: isHighContrast ? colores.onSurface : colores.primary,
          collapsedIconColor: isHighContrast
              ? colores.onSurface
              : colores.primary,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isHighContrast ? colores.onSurface : colores.primary,
            ),
          ),
          leading: Icon(
            icon,
            color: isHighContrast ? colores.onSurface : colores.primary,
          ),
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.subdirectory_arrow_right_rounded,
                    color: isHighContrast ? colores.onSurface : colores.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: isHighContrast
                            ? colores.onSurface
                            : colores.onSurfaceVariant,
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
    );
  }

  Widget _buildSliverAppBar(
    Building building,
    String distanciaPorDefecto,
    ColorScheme colores,
  ) {
    return SliverAppBar(
      expandedHeight: 320.0,
      pinned: true,
      backgroundColor: colores.surface,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colores.surface.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colores.onSurface),
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
                color: colores.outline.withValues(alpha: 0.1),
                child: Center(
                  child: Icon(
                    Icons.broken_image_rounded,
                    size: 60,
                    color: colores.onSurfaceVariant,
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
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.5),
                    ],
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
                  color: colores.surface.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: colores.shadow.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.near_me_rounded,
                      color: colores.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      distanciaPorDefecto,
                      style: TextStyle(
                        color: colores.onSurface,
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

  Widget _buildLegendItem(
    IconData icon,
    String text,
    Color color,
    ColorScheme colores,
    bool isHighContrast,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isHighContrast
                ? colores.surface
                : color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: isHighContrast
                ? Border.all(color: colores.onSurface, width: 2.0)
                : null,
          ),
          child: Icon(
            icon,
            size: 18,
            color: isHighContrast ? colores.onSurface : color,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: isHighContrast ? colores.onSurface : colores.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
