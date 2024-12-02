import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:push_notification_v1httpapi/api/access_token.dart';

Future<void> handleBg(RemoteMessage message) async {
  print('incomming message $message');
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
    print('FCM TOKEN : $fcmToken');

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

  static Future<void> sendTokenNotification(
      String token, String title, String message) async {
    try {
      final body = {
        'message': {
          'token': token,
          'notification': {
            'body': message,
            'title': title,
          }
        }
      };

      // Fixed URL
      String url =
          'https://fcm.googleapis.com/v1/projects/notification-v1-http-api/messages:send';

      // Retrieve access token
      String accessKey = await AccessToken().getAccesToken();

      // Make POST request with the fixed URL
      await http
          .post(Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $accessKey',
              },
              body: jsonEncode(body))
          .then((value) {
        print('Status code ${value.statusCode}');
      });
    } catch (e) {
      print('error : $e');
    }
  }
}
