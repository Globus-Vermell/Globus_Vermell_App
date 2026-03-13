import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/publication_model.dart';

class PublicationService {
  http.Client client = http.Client();

  static const String _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'Error',
  );

  Future<List<Publication>> getPublications() async {
    try {
      final url = Uri.parse('$_baseUrl/publications/api/list');
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final List<Publication> publications = await compute(
          _parsePublication,
          response.body,
        );
        return publications;
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error fetching publications: $e");
      throw Exception('NetworkError');
    }
  }
}

List<Publication> _parsePublication(String responseBody) {
  final data = jsonDecode(responseBody);
  final List<Map<String, dynamic>> listaJson = List<Map<String, dynamic>>.from(
    data['publications'] ?? [],
  );
  return listaJson.map((mapa) => Publication.fromMap(mapa)).toList();
}
