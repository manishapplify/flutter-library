import 'package:image_picker/image_picker.dart';

abstract class SignUpEvent {}

class SignUpFirstnameChanged extends SignUpEvent {
  SignUpFirstnameChanged({required this.firstname});
  final String firstname;
}

class OpenImagePicker extends SignUpEvent {
  OpenImagePicker({required this.imageSource});
  final ImageSource imageSource;
}

class SignUpProfileImageChanged extends SignUpEvent {
  SignUpProfileImageChanged({required this.profilePic});
  final String profilePic;
}

class SignUpLastnameChanged extends SignUpEvent {
  SignUpLastnameChanged({required this.lastname});
  final String lastname;
}

class SignUpReferralCodeChanged extends SignUpEvent {
  SignUpReferralCodeChanged({required this.referralCode});
  final String referralCode;
}

class SignUpCountryCodeChanged extends SignUpEvent {
  SignUpCountryCodeChanged({required this.code});
  final String code;
}

class SignUpPhoneNumberChanged extends SignUpEvent {
  SignUpPhoneNumberChanged({required this.phoneNumber});
  final String phoneNumber;
}

class SignUpEmailChanged extends SignUpEvent {
  SignUpEmailChanged({required this.email});
  final String email;
}

class SignUpPasswordChanged extends SignUpEvent {
  SignUpPasswordChanged({required this.password});
  final String password;
}

class SignUpSubmitted extends SignUpEvent {}
