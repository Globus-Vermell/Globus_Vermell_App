import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../dto/publication_dto.dart';
import '../utils/app_exceptions.dart';

class PublicationRemoteDataSource {
  final http.Client client;
  static const String _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'Error',
  );

  PublicationRemoteDataSource({required this.client});

  Future<List<PublicationDto>> fetchPublications() async {
    final uri = Uri.parse('$_baseUrl/publications/api/list');
    debugPrint("Llamando a la API: $uri");

    try {
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        return await compute(_parsePublicationsDto, response.body);
      } else {
        throw ServerException(response.statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException();
    }
  }
}

List<PublicationDto> _parsePublicationsDto(String responseBody) {
  final data = jsonDecode(responseBody);
  final List<Map<String, dynamic>> listaJson = List<Map<String, dynamic>>.from(
    data['publications'] ?? [],
  );
  return listaJson.map((mapa) => PublicationDto.fromMap(mapa)).toList();
}
