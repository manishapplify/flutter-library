class ForgotPasswordToken {
  ForgotPasswordToken({
    required this.token,
    required this.email,
  });
  factory ForgotPasswordToken.fromJson(Map<String, dynamic> map) {
    return ForgotPasswordToken(
      token: map['token'] ?? '',
      email: map['email'] ?? '',
    );
  }

  final String token;
  final String email;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'token': token,
      'email': email,
    };
  }
}
