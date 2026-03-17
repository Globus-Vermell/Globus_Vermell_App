import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import '../services/building_service.dart';
import '../services/publications_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator(Isar isar) {
  getIt.registerLazySingleton<BuildingService>(() => BuildingService(isar));
  getIt.registerLazySingleton<PublicationService>(
    () => PublicationService(isar),
  );
}
