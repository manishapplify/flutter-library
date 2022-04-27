part of 'bloc.dart';

@immutable
class ForgotPasswordState {
  const ForgotPasswordState({
    this.email = '',
    this.formStatus = const Idle(),
    this.isLoginSuccessful,
  });

  final String email;
  String? get emailValidator =>
      !validators.notEmptyValidator(email) ? 'Email is required' : null;

  final WorkStatus formStatus;
  final bool? isLoginSuccessful;

  ForgotPasswordState copyWith({
    String? email,
    WorkStatus? formStatus,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
