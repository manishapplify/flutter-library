part of 'bloc.dart';

class ChangePasswordState {
  ChangePasswordState({
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmNewPassword = '',
    this.formStatus = const InitialFormStatus(),
  });

  final String currentPassword;
  String? get currentPasswordValidator =>
      currentPassword.isEmpty ? 'Current password is required' : null;

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

  final FormSubmissionStatus formStatus;

  ChangePasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmNewPassword,
    FormSubmissionStatus? formStatus,
  }) {
    return ChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
