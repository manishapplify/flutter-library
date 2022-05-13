part of blocs;
abstract class NotificationsEvent extends BaseEvent {}

class GetNotificationsEvent extends NotificationsEvent {}

class _GetNotificationsSubscriptionEvent  extends NotificationsEvent {}

class _NotificationsSubscriptionDisposeEvent extends NotificationsEvent {}

class _OnNotificationsEvent extends NotificationsEvent {
  _OnNotificationsEvent({
    required this.notifications,
  });

  final Set<FirebaseMessage> notifications;
}

class _OnLocalNotificationsLoadEvent extends NotificationsEvent{
_OnLocalNotificationsLoadEvent({
    required this.notifications,
  });
  final Set<FirebaseMessage> notifications;
}