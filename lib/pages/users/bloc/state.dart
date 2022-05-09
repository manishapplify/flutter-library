part of blocs;

@immutable
class UsersState extends BaseState {
  const UsersState({
    this.users = const <FirebaseUser>[],
    this.chat,
    this.chatStatus = const Idle(),
    this.usersMatchingQuery = const <FirebaseUser>[],
    WorkStatus blocStatus = const Idle(),
  }) : super(blocStatus);

  // Using list since index operation is required in view.
  final List<FirebaseUser> users;

  /// Chat that the user tapped on.
  final FirebaseChat? chat;

  /// Used to track state of loading a chat when user presses message icon.
  final WorkStatus chatStatus;

  final List<FirebaseUser> usersMatchingQuery;

  UsersState copyWith({
    List<FirebaseUser>? users,
    FirebaseChat? chat,
    WorkStatus? blocStatus,
    WorkStatus? chatStatus,
    List<FirebaseUser>? usersMatchingQuery,
  }) {
    return UsersState(
      users: users ?? this.users,
      chat: chat ?? this.chat,
      blocStatus: blocStatus ?? this.blocStatus,
      chatStatus: chatStatus ?? this.chatStatus,
      usersMatchingQuery: usersMatchingQuery ?? this.usersMatchingQuery,
    );
  }

  @override
  BaseState resetState() => const UsersState();

  @override
  BaseState updateStatus(WorkStatus blocStatus) =>
      this.copyWith(blocStatus: blocStatus);
}
