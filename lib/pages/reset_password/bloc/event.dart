part of blocs;


abstract class ResetPasswordEvent extends BaseEvent {}

class ResetNewPasswordChanged extends ResetPasswordEvent {
  ResetNewPasswordChanged({required this.newPassword});

  final String newPassword;
}

class ResetConfirmNewPasswordChanged extends ResetPasswordEvent {
  ResetConfirmNewPasswordChanged({required this.confirmNewPassword});

  final String confirmNewPassword;
}

class ResetResetPasswordFormState extends ResetPasswordEvent {}

class ResetPasswordSubmitted extends ResetPasswordEvent {}
