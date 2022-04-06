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
    final Map<String, dynamic> map = <String, dynamic>{};
    if (phoneNumber is String) {
      map['countryCode'] = countryCode;
      map['phoneNumber'] = phoneNumber;
    } else {
      map['email'] = email;
    }
    return map;
  }
}
