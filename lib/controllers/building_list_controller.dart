import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/building/building_entity.dart';
import '../models/publication/publication_entity.dart';
import '../services/building_service.dart';
import '../services/publications_service.dart';

enum SearchMode { all, publication, nearby }

class BuildingListController extends ChangeNotifier
    with WidgetsBindingObserver {
  final BuildingService _service;
  final PublicationService _pubService;

  BuildingListController(this._service, this._pubService) {
    WidgetsBinding.instance.addObserver(this);
  }

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

  //Controlar cuando estamos en segundo plano
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      debugPrint("App en segundo plano: Pausando GPS");
      _realPosition?.pause();
    } else if (state == AppLifecycleState.resumed) {
      debugPrint("App en primer plano: Reanudando GPS");
      _realPosition?.resume();
    }
  }

  Future<void> refreshData() async {
    await _loadPage(reset: true);
  }

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
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initialData() async {
    try {
      if (publicationsFilter.isEmpty) {
        publicationsFilter = await _pubService.getPublications();
      }
    } catch (e) {
      debugPrint("Error al cargar publicaciones (Offline): $e");
    }
    await _loadPage(reset: true);
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
      rethrow;
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
      rethrow;
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
    WidgetsBinding.instance.removeObserver(this);
    stopTracking();
    super.dispose();
  }
}
