class ResetPasswordRequest {
  ResetPasswordRequest({
    required this.token,
    required this.password,
  });

  final String token;
  final String password;

  Map<String, dynamic> toJson() => <String, dynamic>{
      'token': token,
      'password': password,
    };
}
