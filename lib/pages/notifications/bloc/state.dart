part of blocs;

class NotificationState extends BaseState {
  const NotificationState({
    this.notifications = const <FirebaseMessage>{},
    this.notificationsSubscription,
    WorkStatus blocStatus = const Idle(),
  }) : super(blocStatus);

  final Set<FirebaseMessage> notifications;
  final StreamSubscription<Set<FirebaseMessage>>? notificationsSubscription;
  NotificationState copyWith({
    Set<FirebaseMessage>? notifications,
    StreamSubscription<Set<FirebaseMessage>>? notificationsSubscription,
    WorkStatus? blocStatus,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      notificationsSubscription:
          notificationsSubscription ?? this.notificationsSubscription,
      blocStatus: blocStatus ?? this.blocStatus,
    );
  }

  @override
  BaseState resetState() => const NotificationState();

  @override
  BaseState updateStatus(WorkStatus blocStatus) =>
      this.copyWith(blocStatus: blocStatus);
}
