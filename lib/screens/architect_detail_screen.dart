import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../entity/architect_entity.dart';
import '../controller/building_list_controller.dart';
import '../providers/theme_provider.dart';
import '../utils/lang_extensions.dart';
import 'building_detail_screen.dart';
import '../providers/language_provider.dart';

class ArchitectDetailScreen extends StatelessWidget {
  final Architect architect;

  const ArchitectDetailScreen({super.key, required this.architect});

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isHighContrast = themeProvider.isHighContrast;

    final langCode = context
        .watch<LanguageProvider>()
        .currentLocale
        .languageCode;
    final localDesc = architect.getLocalizedDescription(langCode);
    final localNat = architect.getLocalizedNationality(langCode);

    final buildingController = context.watch<BuildingListController>();
    final architectBuildings = buildingController.buildings.where((b) {
      return b.architects.contains(architect.name);
    }).toList();

    return Scaffold(
      backgroundColor: colores.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            pinned: true,
            backgroundColor: isHighContrast ? colores.surface : colores.primary,
            elevation: isHighContrast ? 0 : 2,
            iconTheme: IconThemeData(
              color: isHighContrast
                  ? colores.onSurface
                  : Theme.of(context).appBarTheme.foregroundColor,
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colores.surface.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                border: isHighContrast
                    ? Border.all(color: colores.onSurface, width: 2)
                    : null,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: colores.onSurface),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 20,
                bottom: 16,
                right: 20,
              ),
              title: Text(
                architect.name,
                style: TextStyle(
                  color: isHighContrast
                      ? colores.onSurface
                      : Theme.of(context).appBarTheme.foregroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  shadows: isHighContrast
                      ? []
                      : [
                          const Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                ),
              ),
              background: Container(
                color: isHighContrast ? colores.surface : colores.primary,
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      bottom: -20,
                      child: Icon(
                        Icons.architecture_rounded,
                        size: 150,
                        color: isHighContrast
                            ? colores.onSurface.withValues(alpha: 0.1)
                            : Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    // Línea inferior para separar en alto contraste
                    if (isHighContrast)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Divider(
                          color: colores.onSurface,
                          height: 1,
                          thickness: 2,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (localNat.isNotEmpty)
                        _buildInfoChip(
                          Icons.flag_rounded,
                          localNat,
                          Colors.blue,
                          colores,
                          isHighContrast,
                        ),
                      if (architect.birthYear != null)
                        _buildInfoChip(
                          Icons.cake_rounded,
                          "${context.loc.born}: ${architect.birthYear}",
                          Colors.purple,
                          colores,
                          isHighContrast,
                        ),
                      if (architect.deathYear != null)
                        _buildInfoChip(
                          Icons.church_rounded,
                          "${context.loc.died}: ${architect.deathYear}",
                          Colors.brown,
                          colores,
                          isHighContrast,
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Divider(
                    color: isHighContrast
                        ? colores.onSurface
                        : colores.outline.withValues(alpha: 0.2),
                    thickness: isHighContrast ? 2 : 1,
                  ),
                  const SizedBox(height: 16),

                  if (localDesc.isNotEmpty) ...[
                    Text(
                      context.loc.description, // O "Descripció" si no usas i18n
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isHighContrast
                            ? colores.onSurface
                            : colores.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localDesc, // ✨ Usamos la variable traducida
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                        color: colores.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  Text(
                    "${context.loc.work} (${architectBuildings.length})",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isHighContrast
                          ? colores.onSurface
                          : colores.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (architectBuildings.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          context.loc.noWorks,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colores.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: architectBuildings.length,
                      itemBuilder: (context, index) {
                        final building = architectBuildings[index];
                        return Card(
                          elevation: isHighContrast ? 0 : 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: isHighContrast
                                ? BorderSide(color: colores.onSurface, width: 2)
                                : BorderSide.none,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 60,
                                height: 60,
                                color: isHighContrast
                                    ? colores.surface
                                    : colores.primary.withValues(alpha: 0.1),
                                child: Icon(
                                  Icons.apartment_rounded,
                                  color: isHighContrast
                                      ? colores.onSurface
                                      : colores.primary,
                                ),
                              ),
                            ),
                            title: Text(
                              building.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colores.onSurface,
                              ),
                            ),
                            subtitle: Text(
                              building.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: colores.onSurfaceVariant),
                            ),
                            trailing: Icon(
                              Icons.chevron_right_rounded,
                              color: isHighContrast
                                  ? colores.onSurface
                                  : colores.primary,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BuildingDetailScreen(
                                    building: building,
                                    location: const LatLng(0, 0),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    IconData icon,
    String text,
    Color baseColor,
    ColorScheme colores,
    bool isHighContrast,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isHighContrast
            ? colores.surface
            : baseColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: isHighContrast
            ? Border.all(color: colores.onSurface, width: 2)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isHighContrast ? colores.onSurface : baseColor,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isHighContrast
                  ? colores.onSurface
                  : baseColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
