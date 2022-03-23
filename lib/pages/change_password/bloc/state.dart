part of 'bloc.dart';

class ChangePasswordState {
  ChangePasswordState({
    this.currentPassword = '',
    this.newPassword = '',
    this.formStatus = const InitialFormStatus(),
    //this.isLoginSuccessful,
  });

  final String currentPassword;
  bool get isValidcurrentPassword => currentPassword.length > 5;

  final String newPassword;
  bool get isValidnewPassword => newPassword.length > 5;

  final FormSubmissionStatus formStatus;
  //final bool? isLoginSuccessful;

  ChangePasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    FormSubmissionStatus? formStatus,
  }) {
    return ChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
