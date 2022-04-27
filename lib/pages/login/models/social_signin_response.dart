import 'package:components/common_models/base_response.dart';
import 'package:components/cubits/models/user.dart';

class SocialSigninResponse extends BaseResponse {
  SocialSigninResponse({
    required int statusCode,
    required String message,
    required this.user,
  }) : super(statusCode, message);

  factory SocialSigninResponse.fromJson(Map<String, dynamic> json) {
    final User user = User.fromJson(json['data']);

    return SocialSigninResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      user: user,
    );
  }

  User user;
}
