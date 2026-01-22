import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/buildings.dart';

class BuildingService {
  // 1. Singleton: Para que sea la MISMA instancia en toda la app
  static final BuildingService _instance = BuildingService._internal();
  factory BuildingService() => _instance;
  BuildingService._internal();

  static const String _baseUrl = 'https://projecte-de-innovacio.onrender.com';

  // 2. Memoria Caché: Aquí guardaremos los edificios para no perderlos
  List<Buildings> cacheEdificios = [];
  bool primeraPaginaCargada = false; // Para saber si ya hicimos la pre-carga

  Future<List<Buildings>> getBuildings({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    if (page == 1 && primeraPaginaCargada && !forceRefresh) {
      return cacheEdificios;
    }

    try {
      final url = Uri.parse('$_baseUrl/buildings/api/list?page=$page');
      print("Llamando a la API: $url");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> listaJson = data['buildings'];

        final nuevosEdificios = listaJson.map((mapa) {
          return Buildings.fromMap(mapa);
        }).toList();

        // Si es la página 1, guardamos/actualizamos la caché
        if (page == 1) {
          cacheEdificios = nuevosEdificios;
          primeraPaginaCargada = true;
        }

        return nuevosEdificios;
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      print(" Error fetching data: $e");
      return [];
    }
  }
}
