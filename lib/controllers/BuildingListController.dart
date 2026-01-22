import '../models/buildings.dart';
import '../services/BuildingServices.dart';

class BuildingListController {
  final BuildingService _service = BuildingService();

  // Estado interno
  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _isLoading = false;

  // Getters
  bool get hasMoreData => _hasMoreData;
  bool get isLoading => _isLoading;

  // 2. Usamos 'async' aquí también para que sea más fácil y no de errores de tipo
  Future<List<Buildings>> getInitialData() async {
    if (_service.primeraPaginaCargada) {
      _currentPage = 2;
      if (_service.cacheEdificios.isEmpty) {
        _hasMoreData = false;
      }
      return _service.cacheEdificios;
    } else {
      // Como fetchNextPage devuelve un Future, usamos await
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
      print("Error en controller: $e");
      _isLoading = false;
      return [];
    }
  }
}
