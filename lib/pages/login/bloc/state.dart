part of 'bloc.dart';

class LoginState {
  LoginState({
    this.email = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
    this.isLoginSuccessful,
  });

  final String email;
  String? get emailValidator =>
      !validators.notEmptyValidator(email) ? 'Email is required' : null;

  final String password;
  String? get passwordValidator =>
      !validators.notEmptyValidator(password) ? 'Password is required' : null;

  final FormSubmissionStatus formStatus;
  final bool? isLoginSuccessful;

  LoginState copyWith({
    String? email,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
