part of blocs;

class ProfileState extends BaseState {
 const ProfileState({
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
    WorkStatus blocStatus = const Idle(),
  }) : super(blocStatus);

  /// Initialize when user selects a file from gallery or camera.
  final File? profilePicFile;

  /// Should not be empty when registering a user.
  bool get isValidProfilePicFilePath =>
      screenType != Screen.registerUser || profilePicFile is File;

  /// Initialize from the user object.
  final String? profilePicUrlPath;

  final String? referralCode;

  final String? firstname;
  String? get firstnameValidator => !validators.notEmptyValidator(firstname)
      ? 'First name is required'
      : null;

  final String? lastname;
  String? get lastnameValidator =>
      !validators.notEmptyValidator(lastname) ? 'Last name is required' : null;

  final String? email;
  String? get emailValidator => !validators.notEmptyValidator(email)
      ? 'Email is required'
      : !validators.isValidEmail(email)
          ? 'Invalid email'
          : null;

  final String? countryCode;
  bool get isValidCountryCode => validators.notEmptyValidator(countryCode);

  final String? phoneNumber;
  String? get phoneNumberValidator => !validators.notEmptyValidator(phoneNumber)
      ? 'Phone number is required'
      : !validators.isValidPhoneNumber(phoneNumber)
          ? 'Invalid phone number'
          : null;

  final Gender? gender;
  bool get isValidGender => gender is Gender;

  final int? age;
  String? get ageValidator => age is! int
      ? 'Age is required'
      : age! < 18
          ? 'Must be above 18 to use the app'
          : age! > 200
              ? 'Invalid age'
              : null;

  final String? address;
  bool get isValidAddress => validators.notEmptyValidator(address);

  final String? city;
  bool get isValidCity => validators.notEmptyValidator(city);

  final bool isNotificationEnabled;

  final Screen screenType;


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
    WorkStatus? blocStatus,
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
      blocStatus: blocStatus ?? this.blocStatus,
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
      screenType: screenType,
    );
  }
  @override
  BaseState resetState() =>  ProfileState(screenType: screenType);

  @override
  BaseState updateStatus(WorkStatus blocStatus) =>
      this.copyWith(blocStatus: blocStatus);
}
