part of 'bloc.dart';

class LogoutState {
  LogoutState({
    this.formStatus = const InitialFormStatus(),
  });
  final FormSubmissionStatus formStatus;

  LogoutState copyWith({
    FormSubmissionStatus? formStatus,
  }) {
    return LogoutState(
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
