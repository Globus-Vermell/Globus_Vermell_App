import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/publication_model.dart';

class PublicationService {
  static final PublicationService _instance = PublicationService._internal();
  factory PublicationService() => _instance;
  PublicationService._internal();

  static const String _baseUrl = 'https://projecte-de-innovacio.onrender.com';

  Future<List<Publication>> getPublications() async {
    try {
      final url = Uri.parse('$_baseUrl/publications/api/list');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // 1. Decodificamos la caja completa (el JSON)
        final Map<String, dynamic> respuestaCompleta = jsonDecode(
          response.body,
        );

        final List<dynamic> listaJson = respuestaCompleta['publications'] ?? [];

        // 3. Convertimos cada item de la lista en un objeto Publication
        return listaJson.map((json) => Publication.fromMap(json)).toList();
      } else {
        print("Ups! Error del servidor: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching publications: $e");
      return [];
    }
  }
}
