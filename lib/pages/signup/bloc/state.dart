part of 'bloc.dart';

class SignUpState {
  SignUpState({
    this.email = '',
    this.password = '',
    this.phoneNumber = '',
    this.confirmPassword = '',
    this.countryCode = '+91',
    this.formStatus = const Idle(),
  });

  final String phoneNumber;
  bool get isValidphoneNumber => validators.isValidPhoneNumber(phoneNumber);
  final String? countryCode;
  bool get isValidCountryCode => countryCode is String;

  final String email;
  String? get emailValidator => !validators.notEmptyValidator(email)
      ? 'Email is required'
      : !validators.isValidEmail(email)
          ? 'Invalid email'
          : null;

  final String password;
  String? get passwordValidator => !validators.notEmptyValidator(password)
      ? 'Password is required'
      : !validators.isValidPassword(password)
          ? 'Must contain at least 7 characters'
          : null;

  final String confirmPassword;
  String? get confirmNewPasswordValidator => confirmPassword.isEmpty
      ? 'Enter password once more'
      : confirmPassword != password
          ? 'Should match the password'
          : null;

  final WorkStatus formStatus;

  SignUpState copyWith({
    String? phoneNumber,
    String? countryCode,
    String? email,
    String? password,
    String? confirmPassword,
    WorkStatus? formStatus,
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
