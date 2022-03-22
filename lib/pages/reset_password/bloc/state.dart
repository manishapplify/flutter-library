part of 'bloc.dart';

class ResetPasswordState {
  ResetPasswordState({
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  final String password;
  bool get isValidPassword => password.length > 6;

  final FormSubmissionStatus formStatus;

  ResetPasswordState copyWith({
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return ResetPasswordState(
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
