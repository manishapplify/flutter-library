part of 'bloc.dart';

class ChangePasswordState {
  ChangePasswordState({
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmNewPassword = '',
    this.formStatus = const Idle(),
  });

  final String currentPassword;
  String? get currentPasswordValidator =>
      currentPassword.isEmpty ? 'Current password is required' : null;

  final String newPassword;
  String? get newPasswordValidator => newPassword.isEmpty
      ? 'New password is required'
      : newPassword == currentPassword
          ? 'Must be different than current password'
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

  ChangePasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmNewPassword,
    WorkStatus? formStatus,
  }) {
    return ChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
