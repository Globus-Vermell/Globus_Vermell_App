import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/app_exceptions.dart';

class LocationService {
  // Manejamos los permisos de ubicación para poder operar en la app
  Future<bool> checkPermissionsAndService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Obtenemos la posición actual del usuario
  Future<LatLng> getCurrentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: accuracy),
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      throw LocationException('No se ha podido obtener la ubicación: $e');
    }
  }

  // Obtenemos la última posición conocida del usuario o en su defecto una posición actual
  Future<LatLng> getLastKnownPosition() async {
    try {
      Position? position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        return LatLng(position.latitude, position.longitude);
      }
      return await getCurrentPosition(accuracy: LocationAccuracy.medium);
    } catch (e) {
      throw LocationException('Error obteniendo la última posición: $e');
    }
  }

  // Obtenemos un stream de posición del usuario con un filtro de distancia
  Stream<LatLng> getPositionStream({int distanceFilter = 10}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      ),
    ).map((Position position) => LatLng(position.latitude, position.longitude));
  }
}
