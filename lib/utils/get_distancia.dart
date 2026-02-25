import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/building_model.dart';

String getDistancia(
    LatLng? ubicacion,
    Buildings edificio,
    ){
  String distancia = '0.6 Km';

  if (ubicacion != null && edificio.latitude != 0) {
    double distanciaMetros = Geolocator.distanceBetween(
      ubicacion.latitude,
      ubicacion.longitude,
      edificio.latitude,
      edificio.longitude,
    );
    double distanciaKm = distanciaMetros / 1000;
    distancia = "${distanciaKm.toStringAsFixed(1)} Km";
  }
  return distancia;
}