part of blocs;

abstract class SignUpEvent extends BaseEvent {}

class SignUpEmailChanged extends SignUpEvent {
  SignUpEmailChanged({required this.email});
  final String email;
}

class SignUpCountryCodeChanged extends SignUpEvent {
  SignUpCountryCodeChanged({required this.countryCode});
  final String countryCode;
}

class SignUpPhoneNumberChanged extends SignUpEvent {
  SignUpPhoneNumberChanged({required this.phoneNumber});
  final String phoneNumber;
}

class SignUpPasswordChanged extends SignUpEvent {
  SignUpPasswordChanged({required this.password});
  final String password;
}

class SignUpConfirmPasswordChanged extends SignUpEvent {
  SignUpConfirmPasswordChanged({required this.confirmPassword});
  final String confirmPassword;
}

class SignUpSubmitted extends SignUpEvent {}
