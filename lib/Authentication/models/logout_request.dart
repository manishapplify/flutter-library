class LogoutRequest {
  LogoutRequest({required this.deviceToken});

  final String deviceToken;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'deviceToken': deviceToken,
      };
}
