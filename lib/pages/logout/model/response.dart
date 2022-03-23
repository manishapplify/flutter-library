import 'package:components/base/base_response.dart';

class LogoutResponse extends BaseResponse {
  LogoutResponse({
    required int statusCode,
    required String message,
  }) : super(statusCode, message);

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      statusCode: json['statusCode'],
      message: json['message'],
    );
  }
}
