part of blocs;

class LoginState extends BaseState {
  const LoginState({
    this.email = '',
    this.password,
    this.isLoginSuccessful,
    WorkStatus blocStatus = const Idle(),
  }) : super(blocStatus);

  final String email;
  String? get emailValidator =>
      !validators.notEmptyValidator(email) ? 'Email is required' : null;

  final String? password;

  final bool? isLoginSuccessful;

  LoginState copyWith({
    String? email,
    String? password,
    WorkStatus? blocStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      blocStatus: blocStatus ?? this.blocStatus,
    );
  }

  @override
  BaseState resetState() => const LoginState();

  @override
  BaseState updateStatus(WorkStatus blocStatus) =>
      this.copyWith(blocStatus: blocStatus);
}
