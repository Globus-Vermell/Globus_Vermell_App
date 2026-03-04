import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/building_model.dart';
import '../models/publication_model.dart';
import '../services/building_service.dart';
import '../services/publications_service.dart';

class BuildingListController extends ChangeNotifier {
  final BuildingService _service = BuildingService();

  List<Building> buildings = [];
  List<Publication> publicationsFilter = [];
  bool isLoading = false;
  int publicationFilter = 0;
  LatLng location = const LatLng(0, 0);
  bool hasMoreData = true;
  int _currentPage = 1;
  StreamSubscription<Position>? _realPosition;

  Future<void> initialData() async {
    isLoading = true;
    notifyListeners();

    try {
      publicationsFilter = await PublicationService().getPublications();

      if (_service.firstPageLoading && publicationFilter == 0) {
        _currentPage = 2;
        buildings = List.from(_service.buildingsCache);
        if (buildings.isEmpty) hasMoreData = false;
      } else {
        final newBuildings = await _service.getBuildings(
          page: _currentPage,
          publicationId: publicationFilter == 0 ? null : publicationFilter,
        );
        if (newBuildings.isEmpty) {
          hasMoreData = false;
        } else {
          _currentPage++;
          buildings.addAll(newBuildings);
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNextPage() async {
    if (isLoading || !hasMoreData) return;

    isLoading = true;
    notifyListeners();

    try {
      final newBuildings = await _service.getBuildings(
        page: _currentPage,
        publicationId: publicationFilter == 0 ? null : publicationFilter,
      );

      if (newBuildings.isEmpty) {
        hasMoreData = false;
      } else {
        _currentPage++;
        buildings.addAll(newBuildings);
      }
    } catch (e) {
      hasMoreData = false;
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyFilter(int idPublicacion) async {
    isLoading = true;
    publicationFilter = idPublicacion;
    _currentPage = 1;
    hasMoreData = true;
    buildings.clear();
    notifyListeners();

    try {
      final filteredBuildings = await _service.getBuildings(
        page: 1,
        publicationId: publicationFilter == 0 ? null : publicationFilter,
        latitude: location.latitude == 0.0 ? null : location.latitude,
        longitude: location.longitude == 0.0 ? null : location.longitude,
        forceRefresh: true,
      );

      if (filteredBuildings.isNotEmpty) {
        _currentPage++;
        buildings.addAll(filteredBuildings);
      } else {
        hasMoreData = false;
      }
    } catch (e) {
      hasMoreData = false;
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> activateGPS() async {
    isLoading = true;
    notifyListeners();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        isLoading = false;
        notifyListeners();
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      location = LatLng(position.latitude, position.longitude);
      _currentPage = 1;
      hasMoreData = true;
      buildings.clear();

      final gpsBuildings = await _service.getBuildings(
        page: 1,
        latitude: position.latitude,
        longitude: position.longitude,
        publicationId: publicationFilter == 0 ? null : publicationFilter,
        forceRefresh: true,
      );

      if (gpsBuildings.isNotEmpty) {
        _currentPage++;
        buildings.addAll(gpsBuildings);
      } else {
        hasMoreData = false;
      }

      startGPSTracking();
    } catch (e) {
      hasMoreData = false;
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void startGPSTracking() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    _realPosition?.cancel();
    _realPosition =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position position) {
          location = LatLng(position.latitude, position.longitude);
          notifyListeners();
        });
  }

  void stopTracking() {
    _realPosition?.cancel();
  }
}
