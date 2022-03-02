import 'package:firebase_messaging/firebase_messaging.dart';

// ignore: constant_identifier_names
const String FIREBASE_TOPIC_NAME = "NEWWIT_NOTIFICATION";

class FcmService {
  late FirebaseMessaging _messaging;

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

  void getToken() async {
    final String? token = await _messaging.getToken();
    print(token);
  }
}
