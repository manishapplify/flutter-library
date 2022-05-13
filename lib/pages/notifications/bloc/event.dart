part of blocs;
abstract class NotificationEvent extends BaseEvent {}

class GetNotificationEvent extends NotificationEvent {}

class GetNotificationSubscriptionEvent  extends NotificationEvent {}

class _OnNotificationEvent extends NotificationEvent {
  _OnNotificationEvent({
    required this.notifications,
  });

  final Set<FirebaseMessage> notifications;
}

class _OnLocalNotificationEvent extends NotificationEvent{
_OnLocalNotificationEvent({
    required this.notifications,
  });
  final Set<FirebaseMessage> notifications;
}