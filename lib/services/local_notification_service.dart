import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
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

  void showLocalNotification(
      {String? title, String? body, String? payload}) async {
    await _flutterLocalNotificationsPlugin.show(
      _notificationId++,
      title,
      body,
      _notificationDetails,
    );
  }
}
