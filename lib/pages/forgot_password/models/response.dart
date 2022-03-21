import 'package:components/base/base_response.dart';

class ForgotPasswordResponse extends BaseResponse {
  ForgotPasswordResponse({
    required int statusCode,
    required String message,
    required this.token,
  }) : super(statusCode, message);

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      token: json['data']['token'],
    );
  }

  final String token;
}
