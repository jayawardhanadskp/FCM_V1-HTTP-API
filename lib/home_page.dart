import 'package:flutter/material.dart';
import 'package:push_notification_v1httpapi/api/access_token.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  AccessToken accessTokenGetter = AccessToken();
                  String? token = await accessTokenGetter.getAccesToken();

                  if (token != null) {
                    print("Access Token: $token");
                  } else {
                    print("Failed to retrieve token");
                  }
                },
                child: Text('Send'))
          ],
        ),
      ),
    );
  }
}
