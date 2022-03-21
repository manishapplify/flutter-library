part of 'bloc.dart';

@immutable
class ForgotPasswordState {
  const ForgotPasswordState({
    this.email = '',
    this.formStatus = const InitialFormStatus(),
    this.isLoginSuccessful,
  });

  final String email;
  bool get isValidEmail => email.length > 3;

  final FormSubmissionStatus formStatus;
  final bool? isLoginSuccessful;

  ForgotPasswordState copyWith({
    String? email,
    FormSubmissionStatus? formStatus,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
