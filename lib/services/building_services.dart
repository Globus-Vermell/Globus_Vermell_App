import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/buildings.dart';

class BuildingService {
  // ⚠️ IMPORTANTE:
  // Si usas Emulador Android: 'http://10.0.2.2:3000'
  // Si usas iOS o Web: 'http://localhost:3000'
  // Si usas móvil físico: La IP de tu PC (ej: 'http://192.168.1.35:3000')
  static const String _baseUrl = 'http://10.0.2.2:3000';

  Future<List<Buildings>> getBuildings({int page = 1}) async {
    try {
      // Aquí usamos el truco del "?format=json" que te expliqué antes 😉
      final url = Uri.parse('$_baseUrl/buildings?format=json&page=$page');

      print("📞 Llamando a la API: $url");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> listaJson = data['buildings'];

        return listaJson.map((mapa) => Buildings.fromMap(mapa)).toList();
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }
}
