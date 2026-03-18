import 'package:get_it/get_it.dart';
import 'package:globus_vermell_app/services/location_service.dart';
import 'package:isar/isar.dart';
import '../data_sources/building_local_data_source.dart';
import '../data_sources/building_remote_data_source.dart';
import '../data_sources/publication_local_data_source.dart';
import '../data_sources/publication_remote_data_source.dart';
import '../repositories/building_repository.dart';
import '../repositories/publication_repository.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

void setupServiceLocator(Isar isar) {
  // http
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  //Repositorio Building
  getIt.registerLazySingleton<BuildingRemoteDataSource>(
    () => BuildingRemoteDataSource(client: getIt<http.Client>()),
  );
  getIt.registerLazySingleton<BuildingLocalDataSource>(
    () => BuildingLocalDataSource(isar: isar),
  );
  getIt.registerLazySingleton<BuildingRepository>(
    () => BuildingRepository(
      remoteDataSource: getIt<BuildingRemoteDataSource>(),
      localDataSource: getIt<BuildingLocalDataSource>(),
    ),
  );

  //Repositorio Publication
  getIt.registerLazySingleton<PublicationRemoteDataSource>(
    () => PublicationRemoteDataSource(client: getIt<http.Client>()),
  );
  getIt.registerLazySingleton<PublicationLocalDataSource>(
    () => PublicationLocalDataSource(isar: isar),
  );

  getIt.registerLazySingleton<PublicationRepository>(
    () => PublicationRepository(
      remoteDataSource: getIt<PublicationRemoteDataSource>(),
      localDataSource: getIt<PublicationLocalDataSource>(),
    ),
  );

  //Servicio de ubicación
  getIt.registerLazySingleton<LocationService>(() => LocationService());
}
