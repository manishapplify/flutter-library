class ChangePasswordRequest {
  ChangePasswordRequest(
      {required this.oldPassword,
      required this.password,
      required this.authorization});

  final String oldPassword;
  final String password;
  final String? authorization;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'oldPassword': oldPassword,
        'password': password,
        'authorization': authorization,
      };
}
