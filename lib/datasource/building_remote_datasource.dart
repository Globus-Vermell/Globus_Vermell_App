import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../dto/building_dto.dart';
import '../utils/app_exceptions.dart';

class BuildingRemoteDataSource {
  final http.Client client;
  static const String _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'Error',
  );

  BuildingRemoteDataSource({required this.client});

  Future<List<BuildingDto>> fetchBuildings({
    required int page,
    int? limit,
    double? latitude,
    double? longitude,
    int? publicationId,
  }) async {
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

    try {
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        return await compute(_parseBuildingsDto, response.body);
      } else {
        throw ServerException(response.statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      debugPrint("Error: $e");
      rethrow;
    }
  }
}

List<BuildingDto> _parseBuildingsDto(String responseBody) {
  final data = jsonDecode(responseBody);
  final List<Map<String, dynamic>> listaJson = List<Map<String, dynamic>>.from(
    data['buildings'] ?? [],
  );
  return listaJson.map((mapa) => BuildingDto.fromMap(mapa)).toList();
}
