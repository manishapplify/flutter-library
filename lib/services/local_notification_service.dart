import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  int _notificationId = 0;

  Future<bool?> initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: IOSInitializationSettings(),
    );
    return _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void showLocalNotification(
      {String? title, String? body, String? payload}) async {
    const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
      'Flutter Library',
      'Flutter Library',
      importance: Importance.max,
    ));

    await _flutterLocalNotificationsPlugin.show(
      _notificationId++,
      title,
      body,
      notificationDetails,
    );
  }
}
