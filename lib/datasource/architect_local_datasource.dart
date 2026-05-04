import 'package:isar/isar.dart';
import '../entity/architect_entity.dart';

class ArchitectLocalDataSource {
  final Isar isar;

  ArchitectLocalDataSource(this.isar);

  Future<List<Architect>> getArchitects() async {
    return await isar.architects.where().sortByName().findAll();
  }

  Future<void> saveArchitects(List<Architect> architects) async {
    await isar.writeTxn(() async {
      await isar.architects.clear();
      await isar.architects.putAll(architects);
    });
  }
}