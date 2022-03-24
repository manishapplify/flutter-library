part of 'bloc.dart';

class SignUpState {
  SignUpState({
    this.email = '',
    this.password = '',
    this.phoneNumber = '',
    this.confirmPassword = '',
    this.countryCode = '+91',
    this.formStatus = const InitialFormStatus(),
  });

  final String phoneNumber;
  bool get isValidphoneNumber => validators.isValidPhoneNumber(phoneNumber);
  final String? countryCode;
  bool get isValidCountryCode => countryCode is String;

  final String email;
  bool get isValidEmail => validators.isValidEmail(email);

  final String password;
  bool get isValidPassword => validators.isValidPassword(password);

  final String confirmPassword;
  bool get isValidConfirmPassword => confirmPassword == password;

  final FormSubmissionStatus formStatus;

  SignUpState copyWith({
    String? phoneNumber,
    String? countryCode,
    String? email,
    String? password,
    String? confirmPassword,
    FormSubmissionStatus? formStatus,
  }) {
    return SignUpState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
