part of 'bloc.dart';

class ProfileState {
  ProfileState({
    required this.screenType,
    this.profilePicFile,
    this.profilePicUrlPath,
    this.firstname,
    this.lastname,
    this.referralCode,
    this.email,
    this.phoneNumber,
    this.countryCode,
    this.gender,
    this.age,
    this.address,
    this.city,
    this.isNotificationEnabled = false,
    this.formStatus = const InitialFormStatus(),
  });

  /// Initialize when user selects a file from gallery or camera.
  final File? profilePicFile;

  /// Should not be empty when registering a user.
  bool get isValidProfilePicFilePath =>
      screenType != Screen.registerUser || profilePicFile is File;

  /// Initialize from the user object.
  final String? profilePicUrlPath;

  final String? referralCode;

  final String? firstname;
  bool get isValidFirstname =>
      validators.notEmptyValidator(firstname) && firstname!.length > 2;
  final String? lastname;
  bool get isValidLastname =>
      validators.notEmptyValidator(lastname) && lastname!.length > 2;

  final String? email;
  String? get emailValidator => !validators.notEmptyValidator(email)
      ? 'Email is required'
      : !validators.isValidEmail(email)
          ? 'Invalid email'
          : null;

  final String? countryCode;
  bool get isValidCountryCode => validators.notEmptyValidator(countryCode);
  final String? phoneNumber;
  bool get isValidPhoneNumber => validators.isValidPhoneNumber(phoneNumber);

  final Gender? gender;
  bool get isValidGender => gender is Gender;

  final int? age;
  bool get isValidAge => age is int && age! > 18 && age! < 200;
  final String? address;
  bool get isValidAddress => validators.notEmptyValidator(address);
  final String? city;
  bool get isValidCity => validators.notEmptyValidator(city);

  final bool isNotificationEnabled;

  final Screen screenType;

  final FormSubmissionStatus formStatus;

  ProfileState copyWith({
    File? profilePicFile,
    String? profilePicUrlPath,
    String? firstname,
    String? lastname,
    String? referralCode,
    String? countryCode,
    String? phoneNumber,
    String? email,
    Gender? gender,
    int? age,
    String? address,
    String? city,
    bool? isNotificationEnabled,
    FormSubmissionStatus? formStatus,
  }) {
    return ProfileState(
      profilePicFile: profilePicFile ?? this.profilePicFile,
      profilePicUrlPath: profilePicUrlPath ?? this.profilePicUrlPath,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      referralCode: referralCode ?? this.referralCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
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
