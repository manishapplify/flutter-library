import 'dart:io';
import 'package:dio/dio.dart';

class S3ImageUpload {
  S3ImageUpload({
    BaseOptions? baseOptions,
    InterceptorsWrapper? interceptorsWrapper,
    List<Interceptor>? interceptors,
  }) {
    dio = Dio(
      baseOptions ??
          BaseOptions(
            baseUrl: _baseUrl,
            connectTimeout: 60000,
            receiveTimeout: 60000,
          ),
    );
  }

  late final Dio dio;
  final String _baseUrl = const String.fromEnvironment("baseUrl");

  Future<Response<dynamic>> uploadImageToSignedURL({
    required String s3SignedURL,
    required File image,
  }) async {
    final Response<dynamic> response = await dio.put(
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
