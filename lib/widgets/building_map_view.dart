import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/building_list_controller.dart';
import '../entity/building_entity.dart';
import '../utils/app_constants.dart';
import '../utils/lang_extensions.dart';

class BuildingMapView extends StatelessWidget {
  final BuildingListController controller;
  final String? mapStyleDark;
  final BitmapDescriptor iconoYo;
  final BitmapDescriptor iconoEdificio;
  final void Function(GoogleMapController) onMapCreated;
  final Future<void> Function(Building, BuildingListController)
  onNavigateToDetail;

  const BuildingMapView({
    super.key,
    required this.controller,
    this.mapStyleDark,
    required this.iconoYo,
    required this.iconoEdificio,
    required this.onMapCreated,
    required this.onNavigateToDetail,
  });

  @override
  Widget build(BuildContext context) {
    LatLng centro = LatLng(
      controller.location.latitude,
      controller.location.longitude,
    );

    if (centro.latitude == 0 && centro.longitude == 0) {
      try {
        final validBuilding = controller.buildings.firstWhere(
          (b) => b.latitude != 0 && b.longitude != 0,
        );
        centro = LatLng(validBuilding.latitude, validBuilding.longitude);
      } catch (e) {
        centro = AppConstants.defaultLocation;
      }
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: centro,
        zoom: AppConstants.defaultMapZoom,
      ),
      style: isDarkMode ? mapStyleDark : null,
      onMapCreated: onMapCreated,
      markers: {
        if (controller.location.latitude != 0)
          Marker(
            markerId: const MarkerId('yo'),
            position: LatLng(
              controller.location.latitude,
              controller.location.longitude,
            ),
            icon: iconoYo,
            infoWindow: InfoWindow(title: context.loc.me),
          ),

        ...controller.buildings
            .where((e) => e.latitude != 0 && e.longitude != 0)
            .map((edificio) {
              return Marker(
                markerId: MarkerId(edificio.hashCode.toString()),
                position: LatLng(edificio.latitude, edificio.longitude),
                icon: iconoEdificio,
                onTap: () => onNavigateToDetail(edificio, controller),
              );
            }),
      },
    );
  }
}
