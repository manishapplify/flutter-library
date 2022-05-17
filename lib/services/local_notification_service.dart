import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsService {
  int _notificationId = 0;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final NotificationDetails _notificationDetails = const NotificationDetails(
    android: AndroidNotificationDetails(
      'Flutter Library',
      'Flutter Library',
      importance: Importance.max,
    ),
  );

  Future<bool?> initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: IOSInitializationSettings(),
    );
    return _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showLocalNotification({String? title, String? body}) async {
    await _flutterLocalNotificationsPlugin.show(
      _notificationId++,
      title,
      body,
      _notificationDetails,
    );
  }

  Future<void> registerNotification() async {
    FirebaseMessaging.onMessage.listen(showFCMNotification);
  }

  void showFCMNotification(RemoteMessage message) {
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      showLocalNotification(title: notification.title, body: notification.body);
    }
  }
}
