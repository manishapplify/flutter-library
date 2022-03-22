part of 'bloc.dart';

@immutable
abstract class ForgotPasswordEvent {}

class EmailChanged extends ForgotPasswordEvent {
  EmailChanged(this.email);

  final String email;
}

class ForgotPasswordSubmitted extends ForgotPasswordEvent {}