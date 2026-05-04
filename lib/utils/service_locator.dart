import 'package:get_it/get_it.dart';
import 'package:globus_vermell_app/datasource/architect_local_datasource.dart';
import 'package:globus_vermell_app/datasource/architect_remote_datasource.dart';
import 'package:globus_vermell_app/repository/architect_repository.dart';
import 'package:globus_vermell_app/services/location_service.dart';
import 'package:isar/isar.dart';
import '../datasource/building_local_datasource.dart';
import '../datasource/building_remote_datasource.dart';
import '../datasource/publication_local_datasource.dart';
import '../datasource/publication_remote_datasource.dart';
import '../repository/building_repository.dart';
import '../repository/publication_repository.dart';
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

  getIt.registerLazySingleton(() => ArchitectLocalDataSource(isar));
  getIt.registerLazySingleton(() => ArchitectRemoteDataSource());
  getIt.registerLazySingleton(() => ArchitectRepository(getIt(), getIt()));
}
