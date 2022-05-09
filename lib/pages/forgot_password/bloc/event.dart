part of blocs;

abstract class ForgotPasswordEvent extends BaseEvent {}

class EmailChanged extends ForgotPasswordEvent {
  EmailChanged(this.email);

  final String email;
}

class ForgotPasswordSubmitted extends ForgotPasswordEvent {}

class ResetForgotPasswordFormStatus extends ForgotPasswordEvent {}
