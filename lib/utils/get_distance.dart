import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../entity/building_entity.dart';

String getDistance(LatLng location, Building building) {
  String distance = '0.6 Km';

  if (location.latitude != 0 && building.latitude != 0) {
    double distanceM = Geolocator.distanceBetween(
      location.latitude,
      location.longitude,
      building.latitude,
      building.longitude,
    );
    double distanceKm = distanceM / 1000;
    distance = "${distanceKm.toStringAsFixed(1)} Km";
  }
  return distance;
}
