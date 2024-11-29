import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class AccessToken {
  static String firebaseMessagingScope =
      "https://www.googleapis.com/auth/firebase.messaging";

  Future<String> getAccesToken() async {
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(
        {
          // add your notification-v1-http-api-firebase-adminsdk.json
        },
      ),
      [firebaseMessagingScope],
    );

    // EXtract the acces token form the credintials
    final accessToken = client.credentials.accessToken.data;
    print("Access Token: $accessToken");

    // return the acces token
    return accessToken;
  }
}
