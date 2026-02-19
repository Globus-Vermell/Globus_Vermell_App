import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/building_model.dart';

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
    double? latitude,
    double? longitude,
  }) async {
    if (page == 1 && primeraPaginaCargada && !forceRefresh) {
      return cacheEdificios;
    }

    try {
      // 1. Primero construimos el TEXTO de la URL (String)
      String urlString = '$_baseUrl/buildings/api/list?page=$page';

      if (latitude != null && longitude != null) {
        urlString += '&lat=$latitude&long=$longitude';
      }

      // 3. convertimos el texto a URI
      final url = Uri.parse(urlString);
      print("Llamando a la API: $url");

      // 4.  la llamada
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> listaJson = data['buildings'];

        final nuevosEdificios = listaJson.map((mapa) {
          return Buildings.fromMap(mapa);
        }).toList();

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
