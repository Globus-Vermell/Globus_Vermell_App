import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dto/architect_dto.dart';
import '../utils/app_constants.dart';

class ArchitectRemoteDataSource {
  Future<List<ArchitectDto>> getArchitects() async {
    final url = Uri.parse('${AppConstants.baseUrl}/api/architects/list');
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['success'] == true) {
        final list = decoded['architects'] as List;
        return list.map((e) => ArchitectDto.fromMap(e)).toList();
      }
    }
    throw Exception("Error al cargar els arquitectes des del servidor");
  }
}