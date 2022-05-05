part of blocs;

abstract class LoginEvent extends BaseEvent {}

class LoginEmailChanged extends LoginEvent {
  LoginEmailChanged({required this.email});

  final String email;
}

class LoginPasswordChanged extends LoginEvent {
  LoginPasswordChanged({required this.password});

  final String password;
}

class GoogleSignInSummitted extends LoginEvent {}

class FacebookSignInSummitted extends LoginEvent {}

class AppleSignInSummitted extends LoginEvent {}

class LoginSubmitted extends LoginEvent {}

class ResetLoginBlocStatus extends LoginEvent {}
