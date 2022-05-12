part of blocs;

class NotificationBloc extends BaseBloc<NotificationEvent, NotificationState> {
  NotificationBloc({
    required FirebaseRealtimeDatabase firebaseRealtimeDatabase,
    required AuthCubit authCubit,
    required LocalNotificationService localNotificationService,
  })  : _firebaseRealtimeDatabase = firebaseRealtimeDatabase,
        _authCubit = authCubit,
        _localNotificationService = localNotificationService,
        super(const NotificationState()) {
    on<GetNotificationEvent>(_getNotificationsEventHandler);
    on<GetNotificationSubscriptionEvent>(
        _getNotificationSubscriptionEventHandler);
    on<_OnNotificationEvent>(_onNotificationEventHandler);
  }
  final FirebaseRealtimeDatabase _firebaseRealtimeDatabase;
  final AuthCubit _authCubit;
  final LocalNotificationService _localNotificationService;
  void _getNotificationsEventHandler(
      GetNotificationEvent event, Emitter<NotificationState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        if (!_authCubit.state.isAuthorized) {
          throw AppException.authenticationException();
        }
        final User currentUser = _authCubit.state.user!;
        final Set<FirebaseMessage> notifications =
            await _firebaseRealtimeDatabase.getNotifications();

        notifications.removeWhere((FirebaseMessage element) =>
            !element.chatDialogId.split(',').contains(currentUser.firebaseId) 
            || currentUser.firebaseId == element.senderId
            );
        emit(state.copyWith(
          notifications: notifications,
        ));
      },
      emit: emit,
    );
  }

  void _getNotificationSubscriptionEventHandler(
      GetNotificationSubscriptionEvent event,
      Emitter<NotificationState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        if (!_authCubit.state.isAuthorized) {
          throw AppException.authenticationException();
        }

        final Stream<Set<FirebaseMessage>> notificationsStream =
            _firebaseRealtimeDatabase.getNotificationStream();

        if (_authCubit.state.user!.notificationEnabled == 1) {
          final User currentUser = _authCubit.state.user!;
          final StreamSubscription<Set<FirebaseMessage>>
              notificationsSubscription =
              notificationsStream.listen((Set<FirebaseMessage> notifications) {
            notifications.removeWhere((FirebaseMessage element) =>
                !element.chatDialogId
                    .split(',')
                    .contains(currentUser.firebaseId) 
                    || currentUser.firebaseId == element.senderId
                    );
            add(_OnNotificationEvent(notification: notifications));
          });

          emit(state.copyWith(
            notificationsSubscription: notificationsSubscription,
          ));
        }
      },
      emit: emit,
      emitFailureOnly: true,
    );
  }

  void _onNotificationEventHandler(
      _OnNotificationEvent event, Emitter<NotificationState> emit) {
    if (event.notification != state.notifications) {
      final Set<String> addedNotification = event.notification
          .difference(state.notifications)
          .map((FirebaseMessage notification) => notification.message)
          .toSet();
      for (final String notification in addedNotification) {
         _localNotificationService.showLocalNotification(
             title: "Flutter Library", body: notification);
      }
    }
    emit(
      state.copyWith(notifications: event.notification),
    );
  }
}