import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import '../models/building/building_entity.dart';

class BuildingLocalDataSource {
  final Isar isar;

  BuildingLocalDataSource({required this.isar});

  Future<List<Building>> getBuildings() async {
    debugPrint("Cargando desde memoria local");
    return await isar.buildings.where().findAll();
  }

  Future<void> saveBuildings(
    List<Building> buildings, {
    required bool clearFirst,
  }) async {
    await isar.writeTxn(() async {
      if (clearFirst) {
        await isar.buildings.clear();
      }
      await isar.buildings.putAll(buildings);
    });
    debugPrint("Edificios guardados en Isar");
  }
}
