import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/building_model.dart';
import '../models/publication_model.dart';
import '../services/building_service.dart';
import '../services/publications_service.dart';

class BuildingListController {
  final BuildingService _service = BuildingService();

  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _isLoading = false;

  LatLng miUbicacion = const LatLng(0, 0);
  int publicationFiltro = 0;

  bool get hasMoreData => _hasMoreData;
  bool get isLoading => _isLoading;

  Future<List<Buildings>> getInitialData() async {
    if (_service.primeraPaginaCargada && publicationFiltro == 0) {
      _currentPage = 2;
      if (_service.cacheEdificios.isEmpty) {
        _hasMoreData = false;
      }
      return _service.cacheEdificios;
    } else {
      return await fetchNextPage();
    }
  }

  Future<List<Publication>> obtenerPublicacionesParaFiltro() async {
    try {
      return await PublicationService().getPublications();
    } catch (e) {
      return [];
    }
  }

  Future<List<Buildings>> fetchNextPage() async {
    if (_isLoading || !_hasMoreData) return [];

    _isLoading = true;

    try {
      final newBuildings = await _service.getBuildings(
        page: _currentPage,
        publicationId: publicationFiltro == 0 ? null : publicationFiltro,
      );

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
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      miUbicacion = LatLng(position.latitude, position.longitude);

      _currentPage = 1;
      _hasMoreData = true;

      final gpsBuildings = await _service.getBuildings(
        page: 1,
        latitude: position.latitude,
        longitude: position.longitude,
        publicationId: publicationFiltro == 0 ? null : publicationFiltro,
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

  Future<List<Buildings>> aplicarFiltro(int? idPublicacion) async {
    _isLoading = true;
    publicationFiltro = idPublicacion ?? 0;
    _currentPage = 1;
    _hasMoreData = true;

    try {
      final filteredBuildings = await _service.getBuildings(
        page: 1,
        publicationId: publicationFiltro == 0 ? null : publicationFiltro,
        latitude: miUbicacion.latitude == 0.0 ? null : miUbicacion.latitude,
        longitude: miUbicacion.longitude == 0.0 ? null : miUbicacion.longitude,
        forceRefresh: true,
      );

      if (filteredBuildings.isNotEmpty) {
        _currentPage++;
      } else {
        _hasMoreData = false;
      }

      _isLoading = false;
      return filteredBuildings;
    } catch (e) {
      _isLoading = false;
      return [];
    }
  }
}