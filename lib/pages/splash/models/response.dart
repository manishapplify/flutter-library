import 'package:components/base/base_response.dart';

class AppVersionResponse extends BaseResponse {
  AppVersionResponse({
    required int statusCode,
    required String message,
    required this.platform,
    required this.version,
    required this.minimumVersion,
  }) : super(statusCode, message);

  factory AppVersionResponse.fromJson(Map<String, dynamic> json) {
    return AppVersionResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      platform: json['data']['name'],
      version: json['data']['version'],
      minimumVersion: json['data']['minimumVersion'],
    );
  }

  /// name
  final String platform;
  final String version;
  final String minimumVersion;
}
