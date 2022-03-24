import 'package:components/base/base_response.dart';
import 'package:components/cubits/models/user.dart';

class SignupResponse extends BaseResponse {
  SignupResponse({
    required int statusCode,
    required String message,
    required this.user,
  }) : super(statusCode, message);

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    final User user = User.fromJson(json['data']);

    return SignupResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      user: user,
    );
  }

  User user;
}
