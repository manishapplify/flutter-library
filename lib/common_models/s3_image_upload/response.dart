import 'package:components/base/base_response.dart';

class S3ImageUploadResponse extends BaseResponse {
  S3ImageUploadResponse(
      {required int statusCode,
      required String message,
      required this.uploadURL,
      required this.fileName,
      required this.key})
      : super(statusCode, message);

  factory S3ImageUploadResponse.fromJson(Map<String, dynamic> json) =>
      S3ImageUploadResponse(
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
