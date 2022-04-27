part of 'bloc.dart';

class LoginState {
  LoginState({
    this.email = '',
    this.password,
    this.formStatus = const Idle(),
    this.isLoginSuccessful,
  });

  final String email;
  String? get emailValidator =>
      !validators.notEmptyValidator(email) ? 'Email is required' : null;

  final String? password;

  final WorkStatus formStatus;
  final bool? isLoginSuccessful;

  LoginState copyWith({
    String? email,
    String? password,
    WorkStatus? formStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
