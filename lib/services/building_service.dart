import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/building_model.dart';

class BuildingService {
  // 1. Singleton: Para que sea la MISMA instancia en toda la app
  static final BuildingService _instance = BuildingService._internal();
  factory BuildingService() => _instance;
  BuildingService._internal();

  http.Client client = http.Client();

  static final String _baseUrl = dotenv.env["API_URL"] ?? "Error";
  // 2. Memoria Caché: Aquí guardaremos los edificios para no perderlos
  List<Building> cacheEdificios = [];
  bool primeraPaginaCargada = false; // Para saber si ya hicimos la pre-carga

  Future<List<Building>> getBuildings({
    int page = 1,
    bool forceRefresh = false,
    double? latitude,
    double? longitude,
    int? publicationId,
  }) async {
    if (page == 1 && primeraPaginaCargada && !forceRefresh && publicationId == null)  {
      return cacheEdificios;
    }

    try {
      String urlString = '$_baseUrl/buildings/api/list?page=$page&limit=100';

      if (latitude != null && longitude != null) {
        urlString += '&lat=$latitude&long=$longitude';
      }

      if (publicationId != null) {
        urlString += '&publication=$publicationId';
      }

      final url = Uri.parse(urlString);
      debugPrint("Llamando a la API: $url");

      final response = await client.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> listaJson = data['buildings'];

        final nuevosEdificios = listaJson.map((mapa) {
          return Building.fromMap(mapa);
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
      debugPrint(" Error fetching data: $e");
      throw Exception('NetworkError');
    }
  }
}
