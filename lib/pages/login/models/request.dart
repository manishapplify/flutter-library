class LoginRequest {
  LoginRequest({
    required this.platformType,
    required this.deviceToken,
    required this.countryCode,
    required this.emailOrPhoneNumber,
    required this.password,
  });

  final String platformType;
  final String deviceToken;
  final String countryCode;
  final String emailOrPhoneNumber;
  final String? password;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{
      'platformType': platformType,
      'deviceToken': deviceToken,
      'countryCode': countryCode,
      'emailOrPhoneNumber': emailOrPhoneNumber,
    };

    if (password is String) {
      map['password'] = password;
    }

    return map;
  }
}
