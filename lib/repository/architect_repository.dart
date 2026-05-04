import 'package:flutter/foundation.dart';
import '../datasource/architect_local_datasource.dart';
import '../datasource/architect_remote_datasource.dart';
import '../entity/architect_entity.dart';
import '../mapper/architect_mapper.dart';

class ArchitectRepository {
  final ArchitectLocalDataSource localDataSource;
  final ArchitectRemoteDataSource remoteDataSource;

  ArchitectRepository(this.localDataSource, this.remoteDataSource);

  Future<List<Architect>> getArchitects({bool forceRefresh = false}) async {
    if (forceRefresh) {
      try {
        final dtos = await remoteDataSource.getArchitects();
        final entities = dtos.map((e) => e.toEntity()).toList();
        await localDataSource.saveArchitects(entities);
        return entities;
      } catch (e) {
        debugPrint("Error fetching remote architects: $e");
      }
    }

    final localData = await localDataSource.getArchitects();
    
    if (localData.isEmpty && !forceRefresh) {
      try {
        final dtos = await remoteDataSource.getArchitects();
        final entities = dtos.map((e) => e.toEntity()).toList();
        await localDataSource.saveArchitects(entities);
        return entities;
      } catch (e) {
        debugPrint("Error fallback architects: $e");
      }
    }
    
    return localData;
  }
}