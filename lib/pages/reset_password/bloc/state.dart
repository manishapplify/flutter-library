part of 'bloc.dart';

class ResetPasswordState {
  ResetPasswordState({
    this.newPassword = '',
    this.confirmNewPassword = '',
    this.formStatus = const InitialFormStatus(),
  });

  final String newPassword;
  String? get newPasswordValidator => newPassword.isEmpty
      ? 'New password is required'
      : !validators.isValidPassword(newPassword)
          ? 'New password is too short'
          : null;

  final String confirmNewPassword;
  String? get confirmNewPasswordValidator => confirmNewPassword.isEmpty
      ? 'Enter new password once more'
      : confirmNewPassword != newPassword
          ? 'Should match the new password'
          : null;

  final FormSubmissionStatus formStatus;

  ResetPasswordState copyWith({
    String? newPassword,
    String? confirmNewPassword,
    FormSubmissionStatus? formStatus,
  }) {
    return ResetPasswordState(
      newPassword: newPassword ?? this.newPassword,
      formStatus: formStatus ?? this.formStatus,
      confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
    );
  }
}
