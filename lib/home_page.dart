import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_v1httpapi/api/access_token.dart';
import 'package:push_notification_v1httpapi/services/firebase_cm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _statusMessage = 'Ready to send notification';

  // Function to send notification
  Future<void> _sendNotification() async {
    setState(() {
      _statusMessage = 'Fetching FCM token...';
    });

    try {
      // Get FCM token
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print('FCM TOKEN: $fcmToken');

      if (fcmToken != null) {
        setState(() {
          _statusMessage = 'FCM token received. Sending notification...';
        });

        // Here you would usually get the access token from your own API or service
        // Assuming you want to send the notification via Firebase CM service
        try {
          // Send notification with the fcmToken
          await FirebaseCM.sendTokenNotification(fcmToken, 'Notification Title', 'This is a notification message.');
          setState(() {
            _statusMessage = 'Notification sent successfully!';
          });
        } catch (e) {
          setState(() {
            _statusMessage = 'Failed to send notification: $e';
          });
          print('Error sending notification: $e');
        }
      } else {
        setState(() {
          _statusMessage = 'Failed to retrieve FCM token';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error fetching FCM token: $e';
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Push Notification Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _sendNotification,
              child: Text('Send Notification'),
            ),
            SizedBox(height: 20),
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
