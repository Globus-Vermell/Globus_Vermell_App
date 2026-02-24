import 'package:flutter/cupertino.dart';

import '../models/publication_model.dart';
import '../services/publications_service.dart';

class ThemesController {
  final PublicationService _service = PublicationService();

  Future<Map<String, List<Publication>>> getOrganizedPublications() async {
    final allPubs = await _service.getPublications();

    debugPrint(" REVISANDO NOMBRES DE TEMAS:");
    for (var p in allPubs) {
      debugPrint(" - Título: ${p.title} | Tema: '${p.themes}'");
    }

    return {
      // etapes
      'etapes': allPubs.where((p) {
        final t = p.themes.toLowerCase().trim();
        return t.contains('etap');
      }).toList(),

      // tematica
      'arquitectura tematica': allPubs.where((p) {
        final t = p.themes.toLowerCase().trim();
        return t.contains('tem');
      }).toList(),

      // barris
      'barris': allPubs.where((p) {
        final t = p.themes.toLowerCase().trim();
        return t.contains('barris');
      }).toList(),
    };
  }
}
