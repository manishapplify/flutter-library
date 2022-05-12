part of blocs;
abstract class NotificationEvent extends BaseEvent {}

class GetNotificationEvent extends NotificationEvent {}

class GetNotificationSubscriptionEvent  extends NotificationEvent {}

class _OnNotificationEvent extends NotificationEvent {
  _OnNotificationEvent({
    required this.notification,
  });

  final Set<FirebaseMessage> notification;
}