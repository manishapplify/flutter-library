import 'dart:io';

import 'package:components/exceptions/app_exception.dart';
import 'package:components/services/api/api.dart';
import 'package:components/services/s3_image_upload/request.dart';
import 'package:components/services/s3_image_upload/response.dart';
import 'package:dio/dio.dart';

class S3ImageUpload {
  S3ImageUpload({
    BaseOptions? baseOptions,
    InterceptorsWrapper? interceptorsWrapper,
    List<Interceptor>? interceptors,
    required Api api,
  }) : _api = api {
    _dio = Dio(
      baseOptions ??
          BaseOptions(
            baseUrl: _baseUrl,
            connectTimeout: 60000,
            receiveTimeout: 60000,
          ),
    );
  }

  late final Dio _dio;
  final String _baseUrl = const String.fromEnvironment("baseUrl");
  late final Api _api;

  Future<String?> getS3ImageUrl({
    required String s3Directory,
    File? profilePicFile,
  }) async {
    if (profilePicFile == null) {
      return null;
    }

    Response<dynamic> response;
    response = await _api.getS3UploadSignedURL(
      S3SignedUrlRequest(
        directory: s3Directory,
        fileName: profilePicFile.uri.pathSegments.last,
      ),
    );
    final S3SignedUrlResponse s3imageUploadResponse =
        S3SignedUrlResponse.fromJson(response.data);

    response = await _uploadImageToSignedURL(
      s3SignedURL: s3imageUploadResponse.uploadURL,
      image: profilePicFile,
    );

    final Uri? uri = Uri.tryParse(s3imageUploadResponse.uploadURL);
    if (uri == null) {
      throw AppException.s3UrlParseException;
    }

    return '${uri.scheme}://${uri.authority}${uri.path}';
  }

  Future<Response<dynamic>> _uploadImageToSignedURL({
    required String s3SignedURL,
    required File image,
  }) async {
    final Response<dynamic> response = await _dio.put(
      s3SignedURL,
      data: image.openRead(),
      options: Options(
        headers: <String, dynamic>{
          "Content-Length": image.lengthSync(),
          "Content-Type": 'image/jpeg',
        },
      ),
    );
    return response;
  }
}
