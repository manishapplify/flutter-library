part of 'bloc.dart';

abstract class LoginEvent {}

class LoginEmailChanged extends LoginEvent {
  LoginEmailChanged({required this.email});

  final String email;
}

class LoginPasswordChanged extends LoginEvent {
  LoginPasswordChanged({required this.password});

  final String password;
}

class GoogleSignInPressed extends LoginEvent {}

class LoginSubmitted extends LoginEvent {}
