import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import '../models/building_model.dart';

class BuildingService {
  final Isar isar;
  http.Client client = http.Client();

  BuildingService(this.isar);
  static const String _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'Error',
  );

  bool firstPageLoading = false; // Para saber si ya hicimos la pre-carga

  Future<List<Building>> getBuildings({
    int page = 1,
    int? limit,
    bool forceRefresh = false,
    double? latitude,
    double? longitude,
    int? publicationId,
  }) async {
    final bool isCleanFetch =
        publicationId == null && latitude == null && longitude == null;

    if (page == 1 && !forceRefresh && isCleanFetch) {
      final localBuildings = await isar.buildings.where().findAll();
      if (localBuildings.isNotEmpty) {
        debugPrint("Cargando edificios desde la memoria local (Offline)");
        return localBuildings;
      }
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

      final uri = Uri.parse(
        '$_baseUrl/buildings/api/list',
      ).replace(queryParameters: queryParams);
      debugPrint("Llamando a la API: $uri");

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final List<Building> nuevosEdificios = await compute(
          _parseBuildings,
          response.body,
        );

        if (page == 1 && isCleanFetch) {
          //writeTxn bloquea la BBDD hasta que se complete la escritura
          await isar.writeTxn(() async {
            if (forceRefresh) {
              await isar.buildings.clear();
            }
            await isar.buildings.putAll(nuevosEdificios);
          });
          debugPrint("Nuevos edificios guardados en el disco local");
        }
        return nuevosEdificios;
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(" Error fetching data: $e");
      //Si no hay wifi o hay modo avión tiramos de la memoria local
      if (isCleanFetch) {
        final localBuildings = await isar.buildings.where().findAll();
        if (localBuildings.isNotEmpty) return localBuildings;
      }
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
