import 'package:components/Authentication/form_submission.dart';

class SignUpState {
  SignUpState({
    this.profilePic = '',
    this.firstname = '',
    this.lastname = '',
    this.referralCode = '',
    this.email = '',
    this.password = '',
    this.phoneNumber = '',
    this.code = '+91',
    this.formStatus = const InitialFormStatus(),
  });
  final String firstname;
  bool get isValidFirstname => firstname.length > 2;
  final String lastname;
  bool get isValidLastname => lastname.length > 2;
  final String referralCode;

  final String phoneNumber;
  bool get isValidphoneNumber => phoneNumber.length > 9;
  final String code;

  final String profilePic;
  final String email;
  bool get isValidEmail => email.contains('@');

  final String password;
  bool get isValidPassword => password.length > 6;

  final FormSubmissionStatus formStatus;

  SignUpState copyWith({
    String? profilePic,
    String? firstname,
    String? lastname,
    String? referralCode,
    String? phoneNumber,
    String? code,
    String? email,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return SignUpState(
      profilePic: profilePic ?? this.profilePic,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      referralCode: referralCode ?? this.referralCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      code: code ?? this.code,
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
