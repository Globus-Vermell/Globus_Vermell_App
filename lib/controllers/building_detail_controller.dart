import 'package:flutter/material.dart';
import '../models/building/building_entity.dart';
import '../models/publication/publication_entity.dart';
import '../services/publications_service.dart';

class BuildingDetailController {
  final Building building;
  final PublicationService _pubService;
  final ValueNotifier<int> currentImageIndex = ValueNotifier(0);

  BuildingDetailController(this.building, this._pubService);

  // Método para actualizar el índice del carrusel
  void onPageChanged(int index) {
    currentImageIndex.value = index;
  }

  Future<void> openMap() {
    return Future.value();
  }

  // Limpieza de recursos
  void dispose() {
    currentImageIndex.dispose();
  }

  Future<Publication> getPublicationByTitle(String title) async {
    final publications = await _pubService.getPublications();

    return publications.firstWhere(
      (p) => p.title.trim().toLowerCase() == title.trim().toLowerCase(),
      orElse: () => throw Exception('Publicació no trobada'),
    );
  }
}
