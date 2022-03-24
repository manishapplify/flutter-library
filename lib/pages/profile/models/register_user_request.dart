import 'package:components/pages/profile/models/update_profile_request.dart';

class RegisterUserRequest extends UpdateProfileRequest {
  RegisterUserRequest({
    required String authToken,
    required String firstName,
    required String lastName,
    required String countryCode,
    required String phoneNumber,
    required String email,
    required String gender,
    required String profilePic,
    required int age,
    required String address,
    required String city,
    required String notificationEnabled,
    required this.platformType,
    required this.refferalCode,
    required this.signupType,
  }) : super(
            authToken: authToken,
            firstName: firstName,
            lastName: lastName,
            countryCode: countryCode,
            phoneNumber: phoneNumber,
            email: email,
            gender: gender,
            profilePic: profilePic,
            age: age,
            address: address,
            city: city,
            notificationEnabled: notificationEnabled);

  final String platformType;
  final String refferalCode;
  final String signupType;

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll(<String, dynamic>{
      'platformType': platformType,
      'refferalCode': refferalCode,
      'signupType': signupType,
    });
}
