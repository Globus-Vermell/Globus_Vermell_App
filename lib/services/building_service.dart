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
    int? limit,
    bool forceRefresh = false,
    double? latitude,
    double? longitude,
    int? publicationId,
  }) async {
    final bool isCleanFetch = publicationId == null && latitude == null && longitude == null;

    if (page == 1 &&
        firstPageLoading &&
        !forceRefresh &&
        isCleanFetch) {
      return buildingsCache;
    }

    try {
      final queryParams = {
        'page': page.toString(),
        'limit': (limit ?? 100).toString(),
      };

      if (latitude != null && longitude != null) {
        queryParams['lat'] = latitude.toString();
        queryParams['long'] = longitude.toString();
      }

      if (publicationId != null) {
        queryParams['publication'] = publicationId.toString();
      }

      final uri = Uri.parse('$_baseUrl/buildings/api/list').replace(queryParameters: queryParams);
      debugPrint("Llamando a la API: $uri");

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final List<Building> nuevosEdificios = await compute(
          _parseBuildings,
          response.body,
        );

        if (page == 1 && isCleanFetch) {
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