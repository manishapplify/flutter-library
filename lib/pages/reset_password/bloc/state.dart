part of blocs;

class ResetPasswordState extends BaseState {
  const ResetPasswordState({
    this.newPassword = '',
    this.confirmNewPassword = '',
   WorkStatus blocStatus = const Idle(),
  }) : super(blocStatus);

  final String newPassword;
  String? get newPasswordValidator => newPassword.isEmpty
      ? 'New password is required'
      : !validators.isValidPassword(newPassword)
          ? 'Must contain at least 7 characters'
          : null;

  final String confirmNewPassword;
  String? get confirmNewPasswordValidator => confirmNewPassword.isEmpty
      ? 'Enter new password once more'
      : confirmNewPassword != newPassword
          ? 'Should match the new password'
          : null;


  ResetPasswordState copyWith({
    String? newPassword,
    String? confirmNewPassword,
    WorkStatus? blocStatus,
  }) {
    return ResetPasswordState(
      newPassword: newPassword ?? this.newPassword,
      blocStatus: blocStatus ?? this.blocStatus,
      confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
    );
  }

  @override
  BaseState resetState() => const ResetPasswordState();

  @override
  BaseState updateStatus(WorkStatus blocStatus) =>
      this.copyWith(blocStatus: blocStatus);
}
