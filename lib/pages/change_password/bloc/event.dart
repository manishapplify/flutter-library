part of 'bloc.dart';

abstract class ChangePasswordEvent {}

class CurrentPasswordChanged extends ChangePasswordEvent {
  CurrentPasswordChanged({required this.currentPassword});

  final String currentPassword;
}

class NewPasswordChanged extends ChangePasswordEvent {
  NewPasswordChanged({required this.newPassword});

  final String newPassword;
}

class ChangePasswordSubmitted extends ChangePasswordEvent {}
