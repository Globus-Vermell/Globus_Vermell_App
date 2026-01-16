import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/buildings.dart';

class BuildingService {
  static const String _baseUrl = 'https://projecte-de-innovacio.onrender.com';

  Future<List<Buildings>> getBuildings({int page = 1}) async {
    try {
      final url = Uri.parse('$_baseUrl/buildings/api/list?page=$page');

      print(" Llamando a la API: $url");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> listaJson = data['buildings'];

        return listaJson.map((mapa) {
          // 1. Imprimimos los datos de CADA edificio para ver si llega "images"
          print(" Data de un edificio: $mapa");

          // 2. Convertimos el mapa a objeto Building
          return Buildings.fromMap(mapa);
        }).toList(); // 3. Y al final lo convertimos todo a lista
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      print(" Error fetching data: $e");
      return [];
    }
  }
}
