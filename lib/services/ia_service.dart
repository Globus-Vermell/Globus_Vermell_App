import 'dart:convert';
import 'package:http/http.dart' as http;

class IaService {
  static const String baseUrl = 'https://ia-server-globus-vermell.onrender.com/api/chat';

  static Future<Map<String, dynamic>> enviarMensaje(String mensaje) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({'pregunta': mensaje}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        return {
          'respuesta': 'Uy, la IA se quedó dormida... (Error ${response.statusCode})', 
          'edificios_relacionados': []
        };
      }
    } catch (e) {
      return {
        'respuesta': 'No hay conexión a internet', 
        'edificios_relacionados': []
      };
    }
  }
}