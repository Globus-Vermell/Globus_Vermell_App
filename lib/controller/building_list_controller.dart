import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math'; 

import '../entity/building_entity.dart';
import '../entity/publication_entity.dart';
import '../repository/building_repository.dart';
import '../services/location_service.dart';
import '../repository/publication_repository.dart';
import '../utils/service_locator.dart';
import 'dart:async';

enum SearchMode { all, publication, nearby }

class BuildingListController extends ChangeNotifier with WidgetsBindingObserver {
  final BuildingRepository _service = getIt<BuildingRepository>();
  final PublicationRepository _pubService = getIt<PublicationRepository>();
  final LocationService _locationService = getIt<LocationService>();

  BuildingListController() {
    WidgetsBinding.instance.addObserver(this);
  }

  List<Building> buildings = [];
  List<Publication> publicationsFilter = [];

  bool isLoading = false;
  bool hasMoreData = true;

  SearchMode _currentMode = SearchMode.all;
  
  int? _selectedPublicationId;
  int? get selectedPublicationId => _selectedPublicationId; 

  LatLng location = const LatLng(0, 0);

  int _currentPage = 1;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Building> get filteredBuildings {
    if (_searchQuery.isEmpty) return buildings;

    return buildings.where((b) {
      final nameMatch = b.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final locMatch = b.location.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return nameMatch || locMatch;
    }).toList();
  }

  LatLngBounds? getBoundsForFilteredBuildings() {
    if (filteredBuildings.isEmpty) return null;

    // Solo cogemos los edificios que tengan coordenadas reales
    final validBuildings = filteredBuildings.where((b) => b.latitude != 0 && b.longitude != 0).toList();
    
    if (validBuildings.isEmpty) return null;

    // Si solo hay un edificio, creamos un mini recuadro para que el mapa no explote
    if (validBuildings.length == 1) {
      double lat = validBuildings.first.latitude;
      double lng = validBuildings.first.longitude;
      return LatLngBounds(
        southwest: LatLng(lat - 0.005, lng - 0.005),
        northeast: LatLng(lat + 0.005, lng + 0.005),
      );
    }

    double minLat = validBuildings.first.latitude;
    double maxLat = validBuildings.first.latitude;
    double minLng = validBuildings.first.longitude;
    double maxLng = validBuildings.first.longitude;

    for (var b in validBuildings) {
      minLat = min(minLat, b.latitude);
      maxLat = max(maxLat, b.latitude);
      minLng = min(minLng, b.longitude);
      maxLng = max(maxLng, b.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  StreamSubscription<LatLng>? _realPosition;

  SearchMode get currentMode => _currentMode;

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

      final int activeLimit = isNearby ? (limit ?? 20) : (limit ?? 100);

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
          buildings = newBuildings.take(activeLimit).toList();
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
    if (!await _locationService.checkPermissionsAndService()) return;

    isLoading = true;
    notifyListeners();

    try {
      location = await _locationService.getCurrentPosition();
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
    _realPosition = _locationService.getPositionStream().listen(
      (LatLng newLocation) {
        location = newLocation;
        notifyListeners();
      },
      onError: (e) {
        debugPrint("Error en el stream del GPS: $e");
      },
    );
  }

  void stopTracking() {
    _realPosition?.cancel();
    _realPosition = null;
  }

  Future<void> nearbyBuildings() async {
    if (!await _locationService.checkPermissionsAndService()) return;

    _currentMode = SearchMode.nearby;
    isLoading = true;
    notifyListeners();

    try {
      location = await _locationService.getLastKnownPosition();
      isLoading = false;
      await _loadPage(reset: true, limit: 20);
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("Error obteniendo GPS en cercanos: $e");
      rethrow;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopTracking();
    super.dispose();
  }
}