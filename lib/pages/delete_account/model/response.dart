import 'package:components/base/base_response.dart';

class DeleteAccountResponse extends BaseResponse {
  DeleteAccountResponse({
    required int statusCode,
    required String message,
  }) : super(statusCode, message);

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAccountResponse(
      statusCode: json['statusCode'],
      message: json['message'],
    );
  }
}
