class SignupRequest {
  SignupRequest({
    required this.platformType,
    required this.deviceToken,
    this.countryCode,
    this.phoneNumber,
    this.email,
    required this.password,
    required this.userType,
  });

  final String platformType;
  final String deviceToken;
  final String? countryCode;
  final String? phoneNumber;
  final String? email;
  final String password;
  final int userType;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{
      'platformType': platformType,
      'deviceToken': deviceToken,
      'password': password,
      'userType': userType,
    };

    if (phoneNumber is String && phoneNumber!.isNotEmpty) {
      map['countryCode'] = countryCode;
      map['phoneNumber'] = phoneNumber;
    }

    if (email is String) {
      map['email'] = email;
    }

    return map;
  }
}
