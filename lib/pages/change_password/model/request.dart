class ChangePasswordRequest {
  ChangePasswordRequest(
      {required this.oldPassword,
      required this.password,
      });

  final String oldPassword;
  final String password;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'oldPassword': oldPassword,
        'password': password,
      };
}
