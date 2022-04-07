part of 'bloc.dart';

@immutable
class UsersState {
  const UsersState({
    this.users = const <FirebaseUser>[],
    this.blocStatus = const InitialFormStatus(),
  });

  final List<FirebaseUser> users;
  final FormSubmissionStatus blocStatus;

  UsersState copyWith({
    List<FirebaseUser>? users,
    FormSubmissionStatus? blocStatus,
  }) {
    return UsersState(
      users: users ?? this.users,
      blocStatus: blocStatus ?? this.blocStatus,
    );
  }
}
