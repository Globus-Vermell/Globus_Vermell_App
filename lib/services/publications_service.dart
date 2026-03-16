import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:globus_vermell_app/utils/app_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import '../models/publication/publication_entity.dart';
import '../models/publication/publication_dto.dart';
import '../models/publication/publication_mapper.dart';

class PublicationService {
  final Isar isar;
  http.Client client = http.Client();

  PublicationService(this.isar);

  static const String _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'Error',
  );

  Future<List<Publication>> getPublications({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final localPublications = await isar.publications.where().findAll();
      if (localPublications.isNotEmpty) {
        debugPrint("Cargando publicaciones desde Isar");
        return localPublications;
      }
    }

    try {
      final url = Uri.parse('$_baseUrl/publications/api/list');
      debugPrint("Llamando a la API: $url");
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final List<Publication> publications = await compute(
          _parsePublication,
          response.body,
        );
        await isar.writeTxn(() async {
          if (forceRefresh) {
            await isar.publications.clear();
          }
          await isar.publications.putAll(publications);
        });
        debugPrint("Nuevas publicaciones guardadas en el disco local");

        return publications;
      } else {
        throw ServerException(response.statusCode);
      }
    } catch (e) {
      debugPrint("Error fetching publications: $e");

      final localPublications = await isar.publications.where().findAll();
      if (localPublications.isNotEmpty) return localPublications;

      throw NetworkException();
    }
  }
}

List<Publication> _parsePublication(String responseBody) {
  final data = jsonDecode(responseBody);
  final List<Map<String, dynamic>> listaJson = List<Map<String, dynamic>>.from(
    data['publications'] ?? [],
  );
  final dtos = listaJson.map((mapa) => PublicationDto.fromMap(mapa)).toList();
  return dtos.map((dto) => dto.toEntity()).toList();
}
