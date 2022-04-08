part of 'bloc.dart';

@immutable
class UsersState {
  const UsersState({
    this.users = const <FirebaseUser>[],
    this.blocStatus = const InitialFormStatus(),
    this.chatStatus = const InitialFormStatus(),
  });

  final List<FirebaseUser> users;
  final FormSubmissionStatus blocStatus;

  /// Used to track state of loading a chat when user presses message icon.
  final FormSubmissionStatus chatStatus;

  UsersState copyWith({
    List<FirebaseUser>? users,
    FormSubmissionStatus? blocStatus,
    FormSubmissionStatus? chatStatus,
  }) {
    return UsersState(
      users: users ?? this.users,
      blocStatus: blocStatus ?? this.blocStatus,
      chatStatus: chatStatus ?? this.chatStatus,
    );
  }
}
