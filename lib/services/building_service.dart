import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/building_model.dart';

class BuildingService {
  // 1. Singleton: Para que sea la MISMA instancia en toda la app
  static final BuildingService _instance = BuildingService._internal();
  factory BuildingService() => _instance;
  BuildingService._internal();

  http.Client client = http.Client();

  static const String _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'Error',
  );
  // 2. Memoria Caché: Aquí guardaremos los edificios para no perderlos
  List<Building> buildingsCache = [];
  bool firstPageLoading = false; // Para saber si ya hicimos la pre-carga

  Future<List<Building>> getBuildings({
    int page = 1,
    bool forceRefresh = false,
    double? latitude,
    double? longitude,
    int? publicationId,
  }) async {
    if (page == 1 &&
        firstPageLoading &&
        !forceRefresh &&
        publicationId == null) {
      return buildingsCache;
    }

    try {
      String urlString = '$_baseUrl/buildings/api/list?page=$page&limit=100';

      if (latitude != null && longitude != null) {
        urlString += '&lat=$latitude&long=$longitude';
      }

      if (publicationId != null) {
        urlString += '&publication=$publicationId';
      }
      final url = Uri.parse(urlString);
      debugPrint("Llamando a la API: $url");
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final List<Building> nuevosEdificios = await compute(
          _parseBuildings,
          response.body,
        );
        if (page == 1) {
          buildingsCache = nuevosEdificios;
          firstPageLoading = true;
        }

        return nuevosEdificios;
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(" Error fetching data: $e");
      throw Exception('NetworkError');
    }
  }
}

List<Building> _parseBuildings(String responseBody) {
  final data = jsonDecode(responseBody);
  final List<Map<String, dynamic>> listaJson = List<Map<String, dynamic>>.from(
    data['buildings'] ?? [],
  );
  return listaJson.map((mapa) => Building.fromMap(mapa)).toList();
}
