import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/building/building_entity.dart';
import '../utils/get_distance.dart';
import '../utils/lang_extensions.dart';

class BuildingCard extends StatelessWidget {
  final Building building;
  final VoidCallback onTap;
  final LatLng location;

  const BuildingCard({
    super.key,
    required this.building,
    required this.onTap,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final String distance = getDistance(location, building);
    final colores = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: colores.surface,
      shadowColor: colores.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colores.outline.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: colores.outline.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: (building.images.isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: building.images.first,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return Icon(
                              Icons.broken_image,
                              color: colores.onSurfaceVariant,
                            );
                          },
                          placeholder: (context, url) {
                            return Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colores.primary,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.image_outlined,
                        color: colores.onSurfaceVariant,
                        size: 40,
                      ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      building.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: colores.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      building.location,
                      style: TextStyle(
                        fontSize: 14,
                        color: colores.onSurfaceVariant,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: colores.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            (building.publications.isNotEmpty)
                                ? building.publications.first
                                : context.loc.noPublication,
                            style: TextStyle(
                              fontSize: 13,
                              color: (building.publications.isNotEmpty)
                                  ? colores.onSurface
                                  : colores.onSurfaceVariant,
                              fontWeight: (building.publications.isNotEmpty)
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontStyle: (building.publications.isNotEmpty)
                                  ? FontStyle.normal
                                  : FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.navigation,
                          color: colores.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distance,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colores.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
