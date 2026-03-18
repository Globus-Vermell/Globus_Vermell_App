import 'package:flutter/cupertino.dart';
import '../models/publication/publication_entity.dart';
import '../services/publications_service.dart';
import '../utils/service_locator.dart';

class ThemesController extends ChangeNotifier {
  final PublicationService _service = getIt<PublicationService>();

  Map<String, List<Publication>> organizedData = {
    'etapes': [],
    'arquitectura tematica': [],
    'barris': [],
  };

  bool isLoading = true;
  bool hasError = false;

  ThemesController() {
    loadOrganizedPublications();
  }

  Future<void> loadOrganizedPublications() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getPublicationsByThemeKeyword('etap'),
        _service.getPublicationsByThemeKeyword('tem'),
        _service.getPublicationsByThemeKeyword('barris'),
      ]);

      organizedData = {
        'etapes': results[0],
        'arquitectura tematica': results[1],
        'barris': results[2],
      };
    } catch (e) {
      debugPrint("Error loading themes: $e");
      hasError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
