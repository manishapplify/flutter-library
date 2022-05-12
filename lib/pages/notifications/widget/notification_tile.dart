import 'package:components/services/firebase_realtime_database/models/message/message.dart';
import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({Key? key, required this.notification})
      : super(key: key);
  final FirebaseMessage notification;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        subtitle: Text(notification.message),
        title: const Text("New Message"),
        leading: const Icon(
          Icons.notification_important,
        ));
  }
}
