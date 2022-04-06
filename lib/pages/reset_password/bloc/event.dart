part of 'bloc.dart';

@immutable
abstract class ResetPasswordEvent {}

class ResetNewPasswordChanged extends ResetPasswordEvent {
  ResetNewPasswordChanged({required this.newPassword});

  final String newPassword;
}

class ConfirmNewPasswordChanged extends ResetPasswordEvent {
  ConfirmNewPasswordChanged({required this.confirmNewPassword});

  final String confirmNewPassword;
}

class ResetFormState extends ResetPasswordEvent {}

class ResetPasswordSubmitted extends ResetPasswordEvent {}
