part of blocs;

class NotificationsState extends BaseState {
  const NotificationsState({
    this.notifications = const <FirebaseMessage>{},
    this.notificationsSubscription,
    WorkStatus blocStatus = const Idle(),
  }) : super(blocStatus);

  final Set<FirebaseMessage> notifications;
  final StreamSubscription<Set<FirebaseMessage>>? notificationsSubscription;
  NotificationsState copyWith({
    Set<FirebaseMessage>? notifications,
    StreamSubscription<Set<FirebaseMessage>>? notificationsSubscription,
    WorkStatus? blocStatus,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      notificationsSubscription:
          notificationsSubscription ?? this.notificationsSubscription,
      blocStatus: blocStatus ?? this.blocStatus,
    );
  }

  @override
  BaseState resetState() => const NotificationsState();

  @override
  BaseState updateStatus(WorkStatus blocStatus) =>
      this.copyWith(blocStatus: blocStatus);
}
