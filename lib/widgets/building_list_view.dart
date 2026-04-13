import 'package:flutter/material.dart';
import '../controller/building_list_controller.dart';
import '../entity/building_entity.dart';
import 'building_card.dart';

class BuildingListView extends StatelessWidget {
  final BuildingListController controller;
  final ScrollController scrollController;
  final Future<void> Function(Building, BuildingListController)
  onNavigateToDetail;

  const BuildingListView({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.onNavigateToDetail,
  });

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    if (controller.filteredBuildings.isEmpty && controller.isLoading) {
      return Center(child: CircularProgressIndicator(color: colores.primary));
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount:
          controller.filteredBuildings.length +
          (controller.hasMoreData && controller.searchQuery.isEmpty ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == controller.filteredBuildings.length) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: CircularProgressIndicator(color: colores.primary),
            ),
          );
        }

        final edificio = controller.filteredBuildings[index];

        return BuildingCard(
          building: edificio,
          location: controller.location,
          onTap: () => onNavigateToDetail(edificio, controller),
        );
      },
    );
  }
}
