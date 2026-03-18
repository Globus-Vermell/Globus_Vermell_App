import 'package:flutter/foundation.dart';
import '../data_sources/publication_local_data_source.dart';
import '../data_sources/publication_remote_data_source.dart';
import '../models/publication/publication_entity.dart';
import '../models/publication/publication_mapper.dart';
import '../utils/app_exceptions.dart';

class PublicationRepository {
  final PublicationRemoteDataSource remoteDataSource;
  final PublicationLocalDataSource localDataSource;

  PublicationRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<List<Publication>> getPublications({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final localPublications = await localDataSource.getPublications();
      if (localPublications.isNotEmpty) {
        return localPublications;
      }
    }

    try {
      final dtos = await remoteDataSource.fetchPublications();

      final entities = dtos.map((dto) => dto.toEntity()).toList();

      await localDataSource.savePublications(
        entities,
        clearFirst: forceRefresh,
      );

      return entities;
    } catch (e) {
      debugPrint("Error fetching publications: $e");

      final localPublications = await localDataSource.getPublications();
      if (localPublications.isNotEmpty) return localPublications;

      throw NetworkException();
    }
  }

  Future<List<Publication>> getPublicationsByThemeKeyword(
    String keyword,
  ) async {
    final localCount = await localDataSource.countPublications();
    if (localCount == 0) {
      await getPublications();
    }
    return await localDataSource.getPublicationsByThemeKeyword(keyword);
  }
}
