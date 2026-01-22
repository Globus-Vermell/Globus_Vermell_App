import '../models/Publications.dart';
import '../services/PublicationsService.dart';

class ThemesController {
  final PublicationService _service = PublicationService();

  Future<Map<String, List<Publication>>> getOrganizedPublications() async {
    // 1. Pedimos todas las publicaciones
    final allPubs = await _service.getPublications();

    // 2. Las filtramos y organizamos en un Mapa
    return {
      'etapes': allPubs
          .where((p) => _matchesCategory(p, ['etapa', 'segle', 'any']))
          .toList(),
      'tematica': allPubs
          .where(
            (p) => _matchesCategory(p, ['arquitectura', 'estil', 'tematica']),
          )
          .toList(),
      'barris': allPubs
          .where((p) => _matchesCategory(p, ['barri', 'districte']))
          .toList(),
    };
  }

  // Una función auxiliar privada para limpiar el código de arriba
  bool _matchesCategory(Publication p, List<String> keywords) {
    final themes = p.themes.toLowerCase();
    for (final word in keywords) {
      if (themes.contains(word)) return true;
    }
    return false;
  }
}
