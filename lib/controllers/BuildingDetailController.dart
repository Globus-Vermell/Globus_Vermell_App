import 'package:flutter/material.dart';
import '../models/buildings.dart';

class BuildingDetailController {
  final Buildings building;

  // Estado para saber qué imagen del carrusel estamos viendo
  final ValueNotifier<int> currentImageIndex = ValueNotifier(0);

  BuildingDetailController(this.building);

  // Método para actualizar el índice del carrusel
  void onPageChanged(int index) {
    currentImageIndex.value = index;
  }

  // Ejemplo de lógica futura: Abrir ubicación en Google Maps Aún falta hacerla del todo
  Future<void> openMap() async {
    debugPrint("Abriendo mapa para: ${building.name}");
  }

  // Limpieza de recursos
  void dispose() {
    currentImageIndex.dispose();
  }
}
