import 'package:components/pages/change_password/model/request.dart';
import 'package:components/pages/delete_account/model/request.dart';
import 'package:components/pages/forgot_password/models/request.dart';
import 'package:components/pages/login/models/request.dart';
import 'package:components/pages/logout/model/request.dart';
import 'package:components/pages/otp/models/request.dart';
import 'package:components/pages/reset_password/models/request.dart';
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

  Future<Response<dynamic>> forgotPassword(
      ForgotPasswordRequest request) async {
    final Response<dynamic> response = await dio.put(
      _forgotPassword,
      data: request.toJson(),
    );
    return response;
  }

  Future<Response<dynamic>> changePassword(
      ChangePasswordRequest request) async {
    dio.options.headers = <String, dynamic>{
      'authorization': request.authorization,
    };
    final Response<dynamic> response = await dio.put(
      _changePassword,
      data: request.toJson()..remove('authorization'),
    );
    return response;
  }

  Future<Response<dynamic>> logout(LogoutRequest request) async {
    dio.options.headers = <String, dynamic>{
      'authorization': request.authorization,
    };
    final Response<dynamic> response = await dio.put(
      _logout,
      data: request.toJson()..remove('authorization'),
    );
    return response;
  }

  Future<Response<dynamic>> deleteAccount(DeleteAccountRequest request) async {
    dio.options.headers = <String, dynamic>{
      'authorization': request.authorization,
    };
    final Response<dynamic> response = await dio.delete(
      _deleteAccount,
    );
    return response;
  }

  Future<Response<dynamic>> verifyForgetPasswordOtp(
      VerifyForgetPasswordOtpRequest request) async {
    final Response<dynamic> response = await dio.put(
      _verifyForgetPasswordOtp,
      data: request.toJson(),
    );
    return response;
  }

  Future<Response<dynamic>> resetPassword(ResetPasswordRequest request) async {
    final Response<dynamic> response = await dio.put(
      _resetPassword,
      data: request.toJson(),
    );
    return response;
  }
}

const String _appVersion = '/api/v1/common/appVersion';
const String _login = '/api/v1/user/login';
const String _forgotPassword = '/api/v1/user/forgotPassword';
const String _verifyForgetPasswordOtp = '/api/v1/user/verifyForgetPasswordOtp';
const String _resetPassword = '/api/v1/user/resetPassword';
const String _changePassword = '/api/v1/user/changePassword';
const String _logout = '/api/v1/user/logout';
const String _deleteAccount = '/api/v1/user';
