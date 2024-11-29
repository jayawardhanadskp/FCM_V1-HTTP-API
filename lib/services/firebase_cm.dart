import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBg(RemoteMessage message) async {
  print(message);
}

class FirebaseCM {
  final firebaseMessaging = FirebaseMessaging.instance;

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'notification',
    'notification',
    importance: Importance.max,
    playSound: true,
    showBadge: true,
  );

  final localNotification = FlutterLocalNotificationsPlugin();

  Future<void> iniNotification() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('User has denied permissions');
    }
    final fcmToken = await firebaseMessaging.getToken();

    FirebaseMessaging.onBackgroundMessage(handleBg);
    initPushNotification();
    initLocalNotification();
  }

  Future<void> initLocalNotification() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
  }

  Future<void> initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(function);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  FutureOr function(RemoteMessage? value) {
    print(value);
  }

  void handleMessage(RemoteMessage message) {
    if (message != null) {
      print(message);
    }
  }

  void subscribeToTopic() {
    FirebaseMessaging.instance.subscribeToTopic('notification');
  }
}
