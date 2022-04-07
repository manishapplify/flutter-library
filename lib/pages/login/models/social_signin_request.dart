class SocialSigninRequest {
  SocialSigninRequest({
    required this.platformType,
    required this.deviceToken,
    required this.socialId,
    required this.loginType,
    this.countryCode,
    this.emailOrPhoneNumber,
    this.password,
  });

  final String platformType;
  final String deviceToken;
  final String socialId;
  final String? countryCode;
  final int loginType;
  final String? emailOrPhoneNumber;
  String? password;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{
      'platformType': platformType,
      'deviceToken': deviceToken,
      'social_id': socialId,
      'loginType': loginType,
    };

    if (countryCode is String) {
      map['countryCode'] = countryCode;
    }
    if (emailOrPhoneNumber is String) {
      map['emailOrPhoneNumber'] = emailOrPhoneNumber;
    }
    if (password is String) {
      map['password'] = password;
    }

    return map;
  }
}
