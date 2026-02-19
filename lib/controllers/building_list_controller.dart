import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/building_model.dart';
import '../services/building_service.dart';

class BuildingListController {
  final BuildingService _service = BuildingService();

  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _isLoading = false;
  LatLng? miUbicacion;

  bool get hasMoreData => _hasMoreData;
  bool get isLoading => _isLoading;

  Future<List<Buildings>> getInitialData() async {
    if (_service.primeraPaginaCargada) {
      _currentPage = 2;
      if (_service.cacheEdificios.isEmpty) {
        _hasMoreData = false;
      }
      return _service.cacheEdificios;
    } else {
      return await fetchNextPage();
    }
  }

  Future<List<Buildings>> fetchNextPage() async {
    if (_isLoading || !_hasMoreData) return [];

    _isLoading = true;

    try {
      final newBuildings = await _service.getBuildings(page: _currentPage);

      if (newBuildings.isEmpty) {
        _hasMoreData = false;
      } else {
        _currentPage++;
      }

      _isLoading = false;
      return newBuildings;
    } catch (e) {
      _isLoading = false;
      return [];
    }
  }

  Future<List<Buildings>> activarGPS() async {
    _isLoading = true;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _isLoading = false;
        return [];
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _isLoading = false;
      return [];
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      miUbicacion = LatLng(position.latitude, position.longitude);

      _currentPage = 1;
      _hasMoreData = true;

      final gpsBuildings = await _service.getBuildings(
        page: 1,
        latitude: position.latitude,
        longitude: position.longitude,
        forceRefresh: true,
      );

      if (gpsBuildings.isNotEmpty) {
        _currentPage++;
      } else {
        _hasMoreData = false;
      }

      _isLoading = false;
      return gpsBuildings;
    } catch (e) {
      _isLoading = false;
      return [];
    }
  }
}
