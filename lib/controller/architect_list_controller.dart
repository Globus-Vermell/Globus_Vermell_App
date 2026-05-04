import 'package:flutter/material.dart';
import '../entity/architect_entity.dart';
import '../repository/architect_repository.dart';
import '../utils/service_locator.dart';

class ArchitectListController extends ChangeNotifier {
  final ArchitectRepository _repository = getIt<ArchitectRepository>();

  List<Architect> architects = [];
  List<Architect> filteredArchitects = [];
  bool isLoading = true;

  ArchitectListController() {
    loadArchitects();
  }

  Future<void> loadArchitects() async {
    isLoading = true;
    notifyListeners();
    try {
      architects = await _repository.getArchitects(forceRefresh: true);
      filteredArchitects = architects;
    } catch (e) {
      debugPrint("Error carregant arquitectes: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchArchitects(String query) {
    if (query.isEmpty) {
      filteredArchitects = architects;
    } else {
      filteredArchitects = architects
          .where((a) => a.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}