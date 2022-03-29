part of 'bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfileRefferalCodeChanged extends ProfileEvent {
  ProfileRefferalCodeChanged({required this.refferalCode});
  final String refferalCode;
}

class ProfileFirstnameChanged extends ProfileEvent {
  ProfileFirstnameChanged({required this.firstname});
  final String firstname;
}

class ProfileLastnameChanged extends ProfileEvent {
  ProfileLastnameChanged({required this.lastname});
  final String lastname;
}

class ProfileCountryCodeChanged extends ProfileEvent {
  ProfileCountryCodeChanged({required this.countryCode});
  final String countryCode;
}

class ProfilePhoneNumberChanged extends ProfileEvent {
  ProfilePhoneNumberChanged({required this.phoneNumber});
  final String phoneNumber;
}

class ProfileEmailChanged extends ProfileEvent {
  ProfileEmailChanged({required this.email});
  final String email;
}

class ProfileGenderChanged extends ProfileEvent {
  ProfileGenderChanged({required this.gender});
  final Gender gender;
}

class ProfileImageChanged extends ProfileEvent {
  ProfileImageChanged({required this.profilePic});
  final File profilePic;
}

class ProfileAgeChanged extends ProfileEvent {
  ProfileAgeChanged({required this.age});
  final int age;
}

class ProfileAddressChanged extends ProfileEvent {
  ProfileAddressChanged({required this.address});
  final String address;
}

class ProfileCityChanged extends ProfileEvent {
  ProfileCityChanged({required this.city});
  final String city;
}

class ProfileNotificationStatusChanged extends ProfileEvent {
  ProfileNotificationStatusChanged({required this.enableNotifications});
  final bool enableNotifications;
}

class ExistingUserProfileFetched extends ProfileEvent {
  ExistingUserProfileFetched({required this.user});

  final User user;
}

class ProfileSubmitted extends ProfileEvent {}

class ResetFormStatus extends ProfileEvent {}
