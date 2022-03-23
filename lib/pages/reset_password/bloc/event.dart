part of 'bloc.dart';

@immutable
abstract class ResetPasswordEvent {}

class ResetPasswordChanged extends ResetPasswordEvent {
  ResetPasswordChanged({required this.password});

  final String password;
}

class ResetPasswordSubmitted extends ResetPasswordEvent {}
