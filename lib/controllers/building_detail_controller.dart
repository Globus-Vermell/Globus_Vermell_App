import 'package:flutter/material.dart';
import '../models/building_model.dart';
import '../models/publication_model.dart';
import '../services/publications_service.dart';

class BuildingDetailController {
  final Building building;

  final ValueNotifier<int> currentImageIndex = ValueNotifier(0);

  BuildingDetailController(this.building);

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
    final publications = await PublicationService().getPublications();

    return publications.firstWhere(
      (p) => p.title.trim().toLowerCase() == title.trim().toLowerCase(),
      orElse: () => throw Exception('Publicació no trobada'),
    );
  }
}
