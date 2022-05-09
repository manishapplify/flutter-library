part of blocs;

class ForgotPasswordState extends BaseState {
  const ForgotPasswordState({
    this.email = '',
    this.isLoginSuccessful,
  WorkStatus blocStatus = const Idle(),
  }) : super(blocStatus);

  final String email;
  String? get emailValidator =>
      !validators.notEmptyValidator(email) ? 'Email is required' : null;

  final bool? isLoginSuccessful;

  ForgotPasswordState copyWith({
    String? email,
    WorkStatus? blocStatus,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      blocStatus: blocStatus ?? this.blocStatus,
    );
  }
  @override
  BaseState resetState() => const ForgotPasswordState();

  @override
  BaseState updateStatus(WorkStatus blocStatus) =>
      this.copyWith(blocStatus: blocStatus);
}
