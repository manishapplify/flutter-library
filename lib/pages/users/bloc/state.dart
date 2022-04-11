part of 'bloc.dart';

@immutable
class UsersState {
  const UsersState({
    this.users = const <FirebaseUser>[],
    this.chat,
    this.blocStatus = const InitialFormStatus(),
    this.chatStatus = const InitialFormStatus(),
  });

  final List<FirebaseUser> users;

  /// Chat that the user tapped on.
  final FirebaseChat? chat;
  final FormSubmissionStatus blocStatus;

  /// Used to track state of loading a chat when user presses message icon.
  final FormSubmissionStatus chatStatus;

  UsersState copyWith({
    List<FirebaseUser>? users,
    FirebaseChat? chat,
    FormSubmissionStatus? blocStatus,
    FormSubmissionStatus? chatStatus,
  }) {
    return UsersState(
      users: users ?? this.users,
      chat: chat ?? this.chat,
      blocStatus: blocStatus ?? this.blocStatus,
      chatStatus: chatStatus ?? this.chatStatus,
    );
  }
}
