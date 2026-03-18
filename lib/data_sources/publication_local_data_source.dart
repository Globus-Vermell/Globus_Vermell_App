import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../models/publication/publication_entity.dart';

class PublicationLocalDataSource {
  final Isar isar;

  PublicationLocalDataSource({required this.isar});

  Future<List<Publication>> getPublications() async {
    debugPrint("Cargando desde memoria local");
    return await isar.publications.where().findAll();
  }

  Future<void> savePublications(
    List<Publication> publications, {
    required bool clearFirst,
  }) async {
    await isar.writeTxn(() async {
      if (clearFirst) {
        await isar.publications.clear();
      }
      await isar.publications.putAll(publications);
    });
    debugPrint("Nuevas publicaciones guardadas en Isar");
  }

  Future<int> countPublications() async {
    return await isar.publications.count();
  }

  Future<List<Publication>> getPublicationsByThemeKeyword(
    String keyword,
  ) async {
    return await isar.publications
        .filter()
        .themesContains(keyword, caseSensitive: false)
        .findAll();
  }
}
