import 'dart:convert';
import 'package:http/http.dart' as http;

class IAService {
  // Clases 
  // static const String baseUrl = 'http://172.30.1.188/api/chat';
  // static const String baseUrl = 'http://10.0.2.2:8000/api/chat';
  // Internet propio
  //172.20.10.12
  static const String baseUrl = 'https://ia-server-globus-vermell.onrender.com/api/chat';

  Future<String> enviarPregunta(String pregunta) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'pregunta': pregunta}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['respuesta'];
      } else {
        return "Uy, el servidor dio error ${response.statusCode}.";
      }
    } catch (e) {
      return "No pude conectar. ¿Pusiste bien la IP de tu Mac?";
    }
  }
}