import 'package:components/pages/login/models/request.dart';
import 'package:components/pages/signup/models/request.dart';
import 'package:dio/dio.dart';

class Api {
  Api({
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

    if (interceptorsWrapper is InterceptorsWrapper) {
      dio.interceptors.add(interceptorsWrapper);
    }

    if (interceptors is List<Interceptor>) {
      for (final Interceptor interceptor in interceptors) {
        dio.interceptors.add(interceptor);
      }
    }
  }

  final String _baseUrl = const String.fromEnvironment("baseUrl");
  late final Dio dio;

  Future<Response<dynamic>> signup(SignupRequest signupRequest) async {
    final Response<dynamic> response = await dio.post(
      '',
      data: signupRequest.toJson(),
    );
    return response;
  }

  Future<Response<dynamic>> appVersion(
    String platform,
  ) async {
    final Response<dynamic> response = await dio.get(
      _appVersion,
      queryParameters: <String, dynamic>{
        'platform': platform,
      },
    );
    return response;
  }

  Future<Response<dynamic>> login(LoginRequest request) async {
    final Response<dynamic> response = await dio.post(
      _login,
      data: request.toJson(),
    );
    return response;
  }
}

const String _appVersion = '/api/v1/common/appVersion';
const String _login = '/api/v1/user/login';
