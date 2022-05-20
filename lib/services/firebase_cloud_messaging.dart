import 'package:firebase_messaging/firebase_messaging.dart';

const String firebaseTopicName = "Flutter_Library_Firebase_Messaging";

class FirebaseCloudMessaging {
  late FirebaseMessaging _messaging;
  late String? deviceToken;
  late NotificationSettings notificationSettings;

  Future<void> registerFCM() async {
    _messaging = FirebaseMessaging.instance;

    _messaging.subscribeToTopic(firebaseTopicName);

    notificationSettings = await _messaging.requestPermission();
  }

  Future<void> getToken() async {
    deviceToken = await _messaging.getToken();
  }
}
