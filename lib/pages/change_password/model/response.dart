import 'package:components/common/base_response.dart';

class ChangePasswordResponse extends BaseResponse {
  ChangePasswordResponse({
    required int statusCode,
    required String message,
  }) : super(statusCode, message);

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      statusCode: json['statusCode'],
      message: json['message'],
    );
  }
}
