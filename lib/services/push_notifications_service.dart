import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

class PushNotificationService {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static  String? token;

  @pragma('vm:entry-point')
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    debugPrint('Mensaje en segundo plano: ${message.messageId}');
  }

  static void _onMessageHandler(RemoteMessage message) {
    debugPrint('Mensaje en primer plano: ${message.notification?.title}');
  }

  static void _onMessageOpenApp(RemoteMessage message) {
    debugPrint('Han tocado la notificación: ${message.messageId}');
  }

  static Future<void> initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await requestPermission();

    token = await FirebaseMessaging.instance.getToken();
    debugPrint('Token del dispositivo: $token');

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('Permisos de notificación: ${settings.authorizationStatus}');
  }
}