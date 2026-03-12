import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/building_model.dart';
import '../models/publication_model.dart';
import '../services/building_service.dart';
import '../services/publications_service.dart';

enum SearchMode { all, publication, nearby }

class BuildingListController extends ChangeNotifier {
  final BuildingService _service = BuildingService();
  final PublicationService _pubService = PublicationService();

  List<Building> buildings = [];
  List<Publication> publicationsFilter = [];

  bool isLoading = false;
  bool hasMoreData = true;

  SearchMode _currentMode = SearchMode.all;
  int? _selectedPublicationId;
  LatLng location = const LatLng(0, 0);

  int _currentPage = 1;
  StreamSubscription<Position>? _realPosition;

  SearchMode get currentMode => _currentMode;

  Future<void> _loadPage({bool reset = false, int? limit}) async {
    if (isLoading || (!hasMoreData && !reset)) return;

    isLoading = true;
    if (reset) {
      _currentPage = 1;
      buildings.clear();
      hasMoreData = true;
    }
    notifyListeners();

    try {
      final isNearby = _currentMode == SearchMode.nearby;
      final hasValidLocation =
          location.latitude != 0 && location.longitude != 0;

      final int? activeLimit = isNearby ? (limit ?? 20) : limit;

      final newBuildings = await _service.getBuildings(
        page: _currentPage,
        limit: activeLimit,
        publicationId: _currentMode == SearchMode.publication
            ? _selectedPublicationId
            : null,
        latitude: (isNearby || hasValidLocation) ? location.latitude : null,
        longitude: (isNearby || hasValidLocation) ? location.longitude : null,
        forceRefresh: reset,
      );

      if (newBuildings.isEmpty) {
        hasMoreData = false;
      } else {
        if (isNearby) {
          buildings = newBuildings.take(activeLimit!).toList();
          hasMoreData = false;
        } else {
          buildings.addAll(newBuildings);
          _currentPage++;
        }
      }
    } catch (e) {
      hasMoreData = false;
      debugPrint("Error loading buildings: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initialData() async {
    if (publicationsFilter.isEmpty) {
      publicationsFilter = await _pubService.getPublications();
    }

    if (_service.firstPageLoading &&
        _currentMode == SearchMode.all &&
        _service.buildingsCache.isNotEmpty) {
      buildings = List.from(_service.buildingsCache);
      _currentPage = 2;
      notifyListeners();
    } else {
      await _loadPage(reset: true);
    }
  }

  Future<void> fetchNextPage() => _loadPage();

  Future<void> applyFilter(int idPublicacion) async {
    _currentMode = SearchMode.publication;
    _selectedPublicationId = idPublicacion;
    await _loadPage(reset: true);
  }

  Future<void> clearFilter() async {
    _currentMode = SearchMode.all;
    _selectedPublicationId = null;
    await _loadPage(reset: true);
  }

  Future<void> activateGPS() async {
    if (!await _checkPermissionsAndService()) return;

    isLoading = true;
    notifyListeners();

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      location = LatLng(position.latitude, position.longitude);

      isLoading = false;
      await _loadPage(reset: true);

      _startListeningToPosition();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("Error obteniendo GPS: $e");
    }
  }

  void _startListeningToPosition() {
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
    _realPosition = null;
  }

  //Función que busca edifcios cercanos a partir de la posición actual del usuario.
  //Mostramos un máximo de 20 edificios para que no se sature la pantalla del usuario.
  Future<void> nearbyBuildings() async {
    if (!await _checkPermissionsAndService()) return;

    _currentMode = SearchMode.nearby;
    isLoading = true;
    notifyListeners();

    //Cogemos la última ubicación que tenemos del usuario, en caso de no tener
    //Buscamos su ubicación pero con el accuracy medio para no tardar tanto
    try {
      Position? position = await Geolocator.getLastKnownPosition();
      position ??= await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      location = LatLng(position.latitude, position.longitude);
      isLoading = false;
      await _loadPage(reset: true, limit: 20);
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("Error obteniendo GPS en cercanos: $e");
    }
  }

  Future<bool> _checkPermissionsAndService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

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

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}
