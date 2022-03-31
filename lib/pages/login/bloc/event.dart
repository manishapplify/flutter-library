part of 'bloc.dart';

abstract class LoginEvent {}

class LoginUsernameChanged extends LoginEvent {
  LoginUsernameChanged({required this.username});

  final String username;
}

class LoginPasswordChanged extends LoginEvent {
  LoginPasswordChanged({required this.password});

  final String password;
}

class GoogleSignInPressed extends LoginEvent {}

class LoginSubmitted extends LoginEvent {}
