import '../models/publication/publication_entity.dart';
import '../services/publications_service.dart';
import '../utils/service_locator.dart';

class ThemesController {
  final PublicationService _service = getIt<PublicationService>();

  ThemesController();

  Future<Map<String, List<Publication>>> getOrganizedPublications() async {
    final publications = await Future.wait([
      _service.getPublicationsByThemeKeyword('etap'),
      _service.getPublicationsByThemeKeyword('tem'),
      _service.getPublicationsByThemeKeyword('barris'),
    ]);

    return {
      'etapes': publications[0],
      'arquitectura tematica': publications[1],
      'barris': publications[2],
    };
  }
}
