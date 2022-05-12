part of blocs;

class UsersBloc extends BaseBloc<UsersEvent, UsersState> {
  UsersBloc({
    required FirebaseRealtimeDatabase firebaseRealtimeDatabase,
    required AuthCubit authCubit,
    required this.imageBaseUrl,
  })  : _firebaseRealtimeDatabase = firebaseRealtimeDatabase,
        _authCubit = authCubit,
        super(const UsersState()) {
    on<GetUsersEvent>(_getUsersEventHandler);
    on<MessageIconTapEvent>(_messageIconTapHandler);
    on<QueryChangedEvent>(_queryChangedEventHandler);
    on<ResetChatState>(_resetChatStateHandler);
  }

  final FirebaseRealtimeDatabase _firebaseRealtimeDatabase;
  final AuthCubit _authCubit;
  final String imageBaseUrl;

  void _getUsersEventHandler(
      GetUsersEvent event, Emitter<UsersState> emit) async {
    emit(state.copyWith(blocStatus: InProgress()));
    await _commonHandler(
      handlerJob: () async {
        final List<FirebaseUser> users =
            await _firebaseRealtimeDatabase.getUsers();
        if (!_authCubit.state.isAuthorized) {
          throw AppException.authenticationException();
        }

        // Don't show self in the list.
        final String currentUserId = _authCubit.state.user!.firebaseId;
        users.removeWhere((FirebaseUser user) => user.id == currentUserId);

        emit(
          state.copyWith(
            users: users,
            usersMatchingQuery: users,
          ),
        );
      },
      emit: emit,
    );
  }

  void _messageIconTapHandler(
      MessageIconTapEvent event, Emitter<UsersState> emit) async {
    emit(state.copyWith(chatStatus: InProgress()));
    await _commonHandler(
      handlerJob: () async {
        final FirebaseChat chat =
            await _firebaseRealtimeDatabase.addChatIfNotExists(
          firebaseUserA: event.firebaseUserA,
          firebaseUserB: event.firebaseUserB,
        );

        emit(
          state.copyWith(
            chat: chat,
          ),
        );
      },
      onStatusUpdate: (WorkStatus status) {
        emit(
          state.copyWith(
            chatStatus: status,
          ),
        );
      },
      emit: emit,
    );
  }

  void _queryChangedEventHandler(
      QueryChangedEvent event, Emitter<UsersState> emit) {
    final List<FirebaseUser> usersMatchingQuery = event.query.isEmpty
        ? state.users
        : state.users
            .where((FirebaseUser user) =>
                user.name?.toLowerCase().contains(event.query.toLowerCase()) ??
                false)
            .toList();

    emit(
      state.copyWith(
        usersMatchingQuery: usersMatchingQuery,
      ),
    );
  }

  void _resetChatStateHandler(
      ResetChatState event, Emitter<UsersState> emit) async {
    emit(
      UsersState(
        blocStatus: state.blocStatus,
        users: state.users,
      ),
    );
  }
}
