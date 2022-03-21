class ForgotPasswordRequest {
  ForgotPasswordRequest({
    required this.email,
    required this.countryCode,
    required this.phoneNumber,
  });

  final String email;
  final String countryCode;
  final String? phoneNumber;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{
      'email': email,
      'countryCode': countryCode,
    };
    if (phoneNumber is String) {
      map['phoneNumber'] = phoneNumber;
    }
    return map;
  }
}
