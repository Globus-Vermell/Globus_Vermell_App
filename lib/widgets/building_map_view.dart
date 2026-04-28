import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/building_list_controller.dart';
import '../entity/building_entity.dart';
import '../utils/app_constants.dart';

class BuildingMapView extends StatefulWidget {
  final BuildingListController controller;
  final String? mapStyleDark;
  final BitmapDescriptor iconoYo;
  final BitmapDescriptor iconoEdificio;
  final void Function(GoogleMapController) onMapCreated;
  final Future<void> Function(Building, BuildingListController) onNavigateToDetail;

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
  State<BuildingMapView> createState() => _BuildingMapViewState();
}

class _BuildingMapViewState extends State<BuildingMapView> {
  GoogleMapController? _internalMapController;
  int? _lastPublicationId;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    LatLng centro = LatLng(
      controller.location.latitude,
      controller.location.longitude,
    );

    if (centro.latitude == 0 && centro.longitude == 0) {
      try {
        final validBuilding = controller.filteredBuildings.firstWhere(
          (b) => b.latitude != 0 && b.longitude != 0,
        );
        centro = LatLng(validBuilding.latitude, validBuilding.longitude);
      } catch (e) {
        centro = AppConstants.defaultLocation;
      }
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (_internalMapController != null) {
      if (controller.currentMode == SearchMode.publication && _lastPublicationId != controller.selectedPublicationId) {
        _lastPublicationId = controller.selectedPublicationId;
        final bounds = controller.getBoundsForFilteredBuildings();
        
        if (bounds != null) {
          // Le damos un pequeño margen de tiempo para que la pantalla cambie antes de animar
          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted) {
              // 50.0 es el padding para que los pines no queden pegados a los bordes
              _internalMapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
            }
          });
        }
      } else if (controller.currentMode != SearchMode.publication) {
        _lastPublicationId = null; // Reseteamos si quitan el filtro
      }
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: centro,
        zoom: AppConstants.defaultMapZoom,
      ),
      style: isDarkMode ? widget.mapStyleDark : null,
      onMapCreated: (mapController) {
        _internalMapController = mapController;
        widget.onMapCreated(mapController);
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      markers: {
        ...controller.filteredBuildings
            .where((e) => e.latitude != 0 && e.longitude != 0)
            .map((edificio) {
              return Marker(
                markerId: MarkerId(edificio.hashCode.toString()),
                position: LatLng(edificio.latitude, edificio.longitude),
                icon: widget.iconoEdificio,
                onTap: () => widget.onNavigateToDetail(edificio, controller),
              );
            }),
      },
    );
  }
}