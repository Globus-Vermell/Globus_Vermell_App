import '../data_sources/building_local_data_source.dart';
import '../data_sources/building_remote_data_source.dart';
import '../models/building/building_entity.dart';
import '../models/building/building_mapper.dart';

class BuildingRepository {
  final BuildingRemoteDataSource remoteDataSource;
  final BuildingLocalDataSource localDataSource;

  BuildingRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<List<Building>> getBuildings({
    int page = 1,
    int? limit,
    bool forceRefresh = false,
    double? latitude,
    double? longitude,
    int? publicationId,
  }) async {
    final bool isCleanFetch =
        publicationId == null && latitude == null && longitude == null;

    if (page == 1 && !forceRefresh && isCleanFetch) {
      final localBuildings = await localDataSource.getBuildings();
      if (localBuildings.isNotEmpty) {
        return localBuildings;
      }
    }
    try {
      final dtos = await remoteDataSource.fetchBuildings(
        page: page,
        limit: limit,
        latitude: latitude,
        longitude: longitude,
        publicationId: publicationId,
      );
      final entities = dtos.map((dto) => dto.toEntity()).toList();
      if (page == 1 && isCleanFetch) {
        await localDataSource.saveBuildings(entities, clearFirst: forceRefresh);
      }

      return entities;
    } catch (e) {
      if (isCleanFetch) {
        final localBuildings = await localDataSource.getBuildings();
        if (localBuildings.isNotEmpty) return localBuildings;
      }
      rethrow;
    }
  }
}
