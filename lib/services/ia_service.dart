import 'dart:convert';
import 'package:http/http.dart' as http;

/*
Todo esto es el services de la ia, si se quiere utilizar contacten primeramente a Angel Sardinha,
ya que fue el estudiante que realizo todo el tema de la ia, y por si tienen alguna duda, 
de todas maneras se les deja el link del render que es justo el que esta abajo, 
también se les deja el enlace al repositorio de github de la ia --> https://github.com/AngelinhoSardinha/ia_server.git 
por si quieren ver la ia y como esta construida, o por si se quiere modificar alguna cosa.
El repositorio esta contectado al render por lo que este se actualizará de manera automatica, sino contacten por el correo y se les actualizará,
también destacar que la ia funciona con una base de datos de supabase, y esté se encuentra en el repositorio de github. 
Comuniquense con Angel Sardinha antes de hacer cualquier cambio/modificación/implementación. 
Gracias. 
*/
class IaService {
  static const String baseUrl =
      'https://ia-server-globus-vermell.onrender.com/api/chat';

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
          'respuesta':
              'Uy, la IA se quedó dormida... (Error ${response.statusCode})',
          'edificios_relacionados': [],
        };
      }
    } catch (e) {
      return {
        'respuesta': 'No hay conexión a internet',
        'edificios_relacionados': [],
      };
    }
  }
}
