import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  
  int _notificationId = 0;
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
