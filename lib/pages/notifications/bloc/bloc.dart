part of blocs;

class NotificationsBloc
    extends BaseBloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc({
    required FirebaseRealtimeDatabase firebaseRealtimeDatabase,
    required AuthCubit authCubit,
    required LocalNotificationsService localNotificationsService,
    required Persistence persistence,
  })  : _firebaseRealtimeDatabase = firebaseRealtimeDatabase,
        _authCubit = authCubit,
        _localNotificationsService = localNotificationsService,
        _persistence = persistence,
        super(const NotificationsState()) {
    on<GetNotificationsEvent>(_getNotificationsEventHandler);
    on<_GetNotificationsSubscriptionEvent>(
        _getNotificationsSubscriptionEventHandler);
    on<_OnNotificationsEvent>(_onNotificationsEventHandler);
    on<_OnLocalNotificationsLoadEvent>(_onLocalNotificationsLoadEventHandler);
    on<_NotificationsSubscriptionDisposeEvent>(
        _notificationsSubscriptionDisposeEventHandler);
    final Set<FirebaseMessage>? notifications =
        _persistence.fetchNotifications();
    if (notifications != null && notifications.isNotEmpty) {
      add(_OnLocalNotificationsLoadEvent(notifications: notifications));
    }
    _handleAuthChanges(_authCubit.state);
    _authCubit.stream.listen(_handleAuthChanges);
  }
  final FirebaseRealtimeDatabase _firebaseRealtimeDatabase;
  final AuthCubit _authCubit;
  final LocalNotificationsService _localNotificationsService;
  final Persistence _persistence;
  void _getNotificationsEventHandler(
      GetNotificationsEvent event, Emitter<NotificationsState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        if (!_authCubit.state.isAuthorized) {
          throw AppException.authenticationException();
        }
        final Set<FirebaseMessage> notifications =
            await _firebaseRealtimeDatabase.getNotifications();

        final User currentUser = _authCubit.state.user!;
        notifications.removeWhere(
          (FirebaseMessage message) =>
              message.messageReadStatus != currentUser.firebaseId,
        );
        emit(state.copyWith(
          notifications: notifications,
        ));
      },
      emit: emit,
    );
  }

  void _getNotificationsSubscriptionEventHandler(
      _GetNotificationsSubscriptionEvent event,
      Emitter<NotificationsState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        if (!_authCubit.state.isAuthorized) {
          throw AppException.authenticationException();
        }

        final Stream<Set<FirebaseMessage>> notificationsStream =
            _firebaseRealtimeDatabase.getNotificationStream();

        final StreamSubscription<Set<FirebaseMessage>>
            notificationsSubscription = notificationsStream.listen(
          (Set<FirebaseMessage> notifications) {
            notifications.removeWhere(
              (FirebaseMessage message) {
                final User currentUser = _authCubit.state.user!;
                return message.messageReadStatus != currentUser.firebaseId;
              },
            );
            add(_OnNotificationsEvent(notifications: notifications));
          },
        );

        emit(
          state.copyWith(
            notificationsSubscription: notificationsSubscription,
          ),
        );
      },
      emit: emit,
      emitFailureOnly: true,
    );
  }

  void _onNotificationsEventHandler(
      _OnNotificationsEvent event, Emitter<NotificationsState> emit) {
    if (event.notifications != state.notifications) {
      final Set<String> newNotifications = event.notifications
          .difference(state.notifications)
          .map((FirebaseMessage notification) => notification.message)
          .toSet();
      for (final String notification in newNotifications) {
        _localNotificationsService.showLocalNotification(
          title: "Flutter Library",
          body: notification,
        );
      }
      emit(
        state.copyWith(notifications: event.notifications),
      );
      _persistence.saveNotifications(event.notifications);
    }
  }

  void _onLocalNotificationsLoadEventHandler(
      _OnLocalNotificationsLoadEvent event, Emitter<NotificationsState> emit) {
    emit(
      state.copyWith(notifications: event.notifications),
    );
  }

  void _notificationsSubscriptionDisposeEventHandler(
      _NotificationsSubscriptionDisposeEvent event,
      Emitter<NotificationsState> emit) {
    state.notificationsSubscription?.cancel();

    emit(const NotificationsState());
  }

  void _handleAuthChanges(AuthState event) {
    if (event.isAuthorized) {
      event.user!.notificationEnabled == 1
          ? add(_GetNotificationsSubscriptionEvent())
          : add(_NotificationsSubscriptionDisposeEvent());
    } else {
      add(_NotificationsSubscriptionDisposeEvent());
    }
  }
}
