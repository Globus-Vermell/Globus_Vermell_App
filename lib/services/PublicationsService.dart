import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Publications.dart';

class PublicationService {
  // Singleton para ahorrar memoria
  static final PublicationService _instance = PublicationService._internal();
  factory PublicationService() => _instance;
  PublicationService._internal();

  static const String _baseUrl = 'https://projecte-de-innovacio.onrender.com';

  Future<List<Publication>> getPublications() async {
    try {
      final url = Uri.parse('$_baseUrl/publications/api/list');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> listaJson = data['data'] ?? [];

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
