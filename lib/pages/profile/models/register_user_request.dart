import 'package:components/pages/profile/models/update_profile_request.dart';

class RegisterUserRequest extends UpdateProfileRequest {
  RegisterUserRequest({
    required String? firstName,
    required String? lastName,
    required String? countryCode,
    required String? phoneNumber,
    required String? email,
    required String? gender,
    required String? profilePic,
    required int? age,
    required String? address,
    required String? city,
    required String notificationEnabled,
    required this.platformType,
    this.referralCode,
    required this.signupType,
  }) : super(
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
          notificationEnabled: notificationEnabled,
        );

  final String platformType;
  final String? referralCode;
  final String signupType;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = super.toJson()
      ..addAll(<String, dynamic>{
        'platformType': platformType,
        'signupType': signupType,
      });

    if (referralCode is String) {
      map['referralCode'] = referralCode;
    }

    return map;
  }
}
