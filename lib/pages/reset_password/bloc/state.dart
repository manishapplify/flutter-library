part of 'bloc.dart';

class ResetPasswordState {
  ResetPasswordState({
    this.newPassword = '',
    this.confirmNewPassword = '',
    this.formStatus = const Idle(),
  });

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

  final WorkStatus formStatus;

  ResetPasswordState copyWith({
    String? newPassword,
    String? confirmNewPassword,
    WorkStatus? formStatus,
  }) {
    return ResetPasswordState(
      newPassword: newPassword ?? this.newPassword,
      formStatus: formStatus ?? this.formStatus,
      confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
    );
  }
}
