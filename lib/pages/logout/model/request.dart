class LogoutRequest {
  LogoutRequest({required this.deviceToken, required this.authorization});

  final String authorization;
  final String deviceToken;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'deviceToken': deviceToken,
        'authorization': authorization,
      };
}
