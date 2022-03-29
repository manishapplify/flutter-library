import 'package:components/base/base_response.dart';

class S3SignedUrlResponse extends BaseResponse {
  S3SignedUrlResponse(
      {required int statusCode,
      required String message,
      required this.uploadURL,
      required this.fileName,
      required this.key})
      : super(statusCode, message);

  factory S3SignedUrlResponse.fromJson(Map<String, dynamic> json) =>
      S3SignedUrlResponse(
        statusCode: json['statusCode'],
        message: json['message'],
        uploadURL: json['data']['uploadURL'],
        fileName: json['data']['fileName'],
        key: json['data']['Key'],
      );

  String uploadURL;
  String fileName;
  String key;
}
