part of 'bloc.dart';

class ProfileState {
  ProfileState({
    required this.screenType,
    this.profilePicFilePath,
    this.profilePicUrlPath,
    this.firstname = '',
    this.lastname = '',
    this.referralCode = '',
    this.email = '',
    this.phoneNumber = '',
    this.countryCode = '+91',
    this.gender,
    this.age = '',
    this.address = '',
    this.city = '',
    this.isNotificationEnabled = false,
    this.formStatus = const InitialFormStatus(),
  });

  /// Initialize when user selects a file from gallery or camera.
  final String? profilePicFilePath;

  /// Initialize from the user object.
  final String? profilePicUrlPath;

  final String referralCode;

  final String firstname;
  bool get isValidFirstname => firstname.length > 2;
  final String lastname;
  bool get isValidLastname => lastname.length > 2;

  final String email;
  bool get isValidEmail => validators.isValidEmail(email);

  final String countryCode;
  final String phoneNumber;
  bool get isValidphoneNumber => validators.isValidPhoneNumber(phoneNumber);

  final Gender? gender;

  final String age;
  final String address;
  final String city;

  final bool isNotificationEnabled;

  final Screen screenType;

  final FormSubmissionStatus formStatus;

  ProfileState copyWith({
    String? profilePicFilePath,
    String? profilePicUrlPath,
    String? firstname,
    String? lastname,
    String? referralCode,
    String? phoneNumber,
    String? code,
    String? email,
    Gender? gender,
    String? age,
    String? address,
    String? city,
    bool? isNotificationEnabled,
    FormSubmissionStatus? formStatus,
  }) {
    return ProfileState(
      profilePicFilePath: profilePicFilePath ?? this.profilePicFilePath,
      profilePicUrlPath: profilePicUrlPath ?? this.profilePicUrlPath,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      referralCode: referralCode ?? this.referralCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: code ?? this.countryCode,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      address: address ?? this.address,
      city: city ?? this.city,
      formStatus: formStatus ?? this.formStatus,
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
      screenType: screenType,
    );
  }
}
