import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../entity/building_entity.dart';
import '../entity/publication_entity.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground',
    'Servicio de Ubicación',
    description: 'Este canal se usa para rastrear edificios en segundo plano.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Rastreo de Edificios',
      initialNotificationContent: 'Buscando edificios cercanos...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      final String? payload = response.payload;
      if (payload != null) {
        service.invoke('open_building', {'id': int.parse(payload)});
      }
    },
  );

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([
    BuildingSchema,
    PublicationSchema,
  ], directory: dir.path);

  Set<int> notifiedBuildingIds = {};

  Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
  ).listen((Position position) {
    _processProximity(
      position: position,
      isar: isar,
      notificationsPlugin: flutterLocalNotificationsPlugin,
      notifiedIds: notifiedBuildingIds,
    );
  });
}

Future<void> _processProximity({
  required Position position,
  required Isar isar,
  required FlutterLocalNotificationsPlugin notificationsPlugin,
  required Set<int> notifiedIds,
}) async {
  const double proximityThreshold = 50.0;

  final List<Building> localBuildings = await isar.buildings.where().findAll();

  for (var building in localBuildings) {
    if (building.latitude == 0 || building.longitude == 0) continue;

    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      building.latitude,
      building.longitude,
    );

    if (distance <= proximityThreshold) {
      if (!notifiedIds.contains(building.idBuilding)) {
        final AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
              'proximity_channel',
              'Edificios Cercanos',
              importance: Importance.max,
              priority: Priority.high,
              styleInformation: BigTextStyleInformation(''),
              icon: '@mipmap/launcher_icon',
            );

        await notificationsPlugin.show(
          id: building.idBuilding,
          title: 'Estás cerca de ${building.name}',
          body: 'Estoy probando esto',
          payload: building.idBuilding.toString(),
          notificationDetails: NotificationDetails(android: androidDetails),
        );

        notifiedIds.add(building.idBuilding);
      }
    } else if (distance > proximityThreshold + 100) {
      notifiedIds.remove(building.idBuilding);
    }
  }
}
