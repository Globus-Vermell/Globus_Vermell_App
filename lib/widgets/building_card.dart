import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/building_model.dart';
import '../utils/get_distance.dart';
import '../utils/lang_extensions.dart';

class BuildingCard extends StatefulWidget {
  final Building building;
  final VoidCallback onTap;
  final LatLng? location;

  const BuildingCard({super.key,
    required this.building,
    required this.onTap,
    required this.location,
  });

  @override
  State<BuildingCard> createState() => _BuildingCardState();
}

class _BuildingCardState extends State<BuildingCard> {
  @override
  Widget build(BuildContext context) {
    String distance = getDistance(widget.location, widget.building);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: (widget.building.images.isNotEmpty)
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: widget.building.images.first,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return Icon(
                        Icons.broken_image,
                        color: Colors.grey[400],
                      );
                    },
                    placeholder: (context, url) {
                      return const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                  ),
                )
                    : Icon(
                  Icons.image_outlined,
                  color: Colors.grey[400],
                  size: 40,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.building.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.building.location,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFFE41E26),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            (widget.building.publications.isNotEmpty)
                                ? widget.building.publications.first
                                : context.loc.noPublication,
                            style: TextStyle(
                              fontSize: 13,
                              color: (widget.building.publications.isNotEmpty)
                                  ? const Color.fromARGB(255, 0, 0, 0)
                                  : Colors.grey[700],
                              fontWeight: (widget.building.publications.isNotEmpty)
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontStyle: (widget.building.publications.isNotEmpty)
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
                          color: Colors.grey[600],
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distance,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
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