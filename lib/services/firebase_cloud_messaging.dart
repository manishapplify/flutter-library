import 'package:firebase_messaging/firebase_messaging.dart';

// ignore: constant_identifier_names
const String FIREBASE_TOPIC_NAME = "NEWWIT_NOTIFICATION";

class FirebaseCloudMessaging {
  late FirebaseMessaging _messaging;
  late String? deviceToken;

  Future<void> registerFCM() async {
    _messaging = FirebaseMessaging.instance;

    _messaging.subscribeToTopic(FIREBASE_TOPIC_NAME);

    final NotificationSettings settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission: ${settings.authorizationStatus}');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> getToken() async {
    deviceToken = await _messaging.getToken();
    print(deviceToken);
  }
}
