import 'dart:io';

import 'package:components/pages/change_password/model/request.dart';
import 'package:components/pages/feedback/models/request.dart';
import 'package:components/pages/login/models/social_signin_request.dart';
import 'package:components/pages/report_bug/models/request.dart';
import 'package:components/pages/forgot_password/models/request.dart';
import 'package:components/pages/login/models/login_request.dart';
import 'package:components/Authentication/models/logout_request.dart';
import 'package:components/pages/otp/models/request.dart';
import 'package:components/pages/profile/models/register_user_request.dart';
import 'package:components/pages/profile/models/update_profile_request.dart';
import 'package:components/pages/reset_password/models/request.dart';
import 'package:components/pages/signup/models/request.dart';
import 'package:components/services/api/models/report_item.dart';
import 'package:components/services/s3_image_upload/request.dart';
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
            contentType: "application/json",
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

  final String _baseUrl = const String.fromEnvironment('baseUrl');
  late final Dio dio;

  void addAuthorizationHeader(String authorization) {
    dio.options.headers = <String, dynamic>{
      'authorization': authorization,
    };
  }

  void removeAuthorizationHeader() {
    dio.options.headers = <String, dynamic>{};
  }

  /// Return the path of the downloaded file.
  Future<String> downloadFile(String url, String name) async {
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/$name');
    if (tempFile.existsSync()) {
      return tempFile.path;
    }
    final Response<dynamic> response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
    );
    final RandomAccessFile raf = tempFile.openSync(mode: FileMode.write)
      ..writeFromSync(response.data);
    await raf.close();
    return tempFile.path;
  }

  Future<Response<dynamic>> signup(SignupRequest signupRequest) async {
    final Response<dynamic> response = await dio.post(
      _signUp,
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

  Future<Response<dynamic>> socialLogin(SocialSigninRequest request) async {
    final Response<dynamic> response = await dio.post(
      _socialLogin,
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
    final Response<dynamic> response = await dio.put(
      _changePassword,
      data: request.toJson(),
    );
    return response;
  }

  Future<Response<dynamic>> logout(LogoutRequest request) async {
    final Response<dynamic> response = await dio.put(
      _logout,
      data: request.toJson(),
    );
    return response;
  }

  Future<Response<dynamic>> deleteAccount() async {
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

  Future<Response<dynamic>> verifyEmail(String otp) async {
    final Response<dynamic> response = await dio.put(
      _verifyEmail,
      queryParameters: <String, String>{
        'otp': otp,
      },
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

  Future<Response<dynamic>> registerUser(RegisterUserRequest request) async {
    final Response<dynamic> response = await dio.put(
      _registerUser,
      data: request.toJson(),
    );
    return response;
  }

  Future<Response<dynamic>> updateProfile(UpdateProfileRequest request) async {
    final Response<dynamic> response = await dio.put(
      _user,
      data: request.toJson(),
    );
    return response;
  }

  Future<Response<dynamic>> getS3UploadSignedURL(
      S3SignedUrlRequest request) async {
    final Response<dynamic> response = await dio.post(
      _getS3UploadSignedURL,
      data: request.toJson(),
    );
    return response;
  }

  Future<Response<dynamic>> reportFeedback(FeedbackRequest request) async {
    final Response<dynamic> response = await dio.post(
      _reportFeedback,
      data: request.toJson(),
    );
    return response;
  }

  Future<Response<dynamic>> reportBug(ReportBugRequest request) async {
    final Response<dynamic> response = await dio.post(
      _reportBug,
      data: request.toJson(),
    );
    return response;
  }

  Future<Response<dynamic>> reportItems(ReportItemRequest request) async {
    final Response<dynamic> response = await dio.post(
      _reportItems,
      data: request.toJson(),
    );
    return response;
  }
}

const String _appVersion = '/api/v1/common/appVersion';
const String _login = '/api/v1/user/login';
const String _signUp = '/api/v1/user/signUp';
const String _forgotPassword = '/api/v1/user/forgotPassword';
const String _verifyForgetPasswordOtp = '/api/v1/user/verifyForgetPasswordOtp';
const String _verifyEmail = '/api/v1/user/verifyEmail';
const String _resetPassword = '/api/v1/user/resetPassword';
const String _changePassword = '/api/v1/user/changePassword';
const String _logout = '/api/v1/user/logout';
const String _deleteAccount = '/api/v1/user';
const String _registerUser = '/api/v1/user/registerUser';
const String _user = '/api/v1/user';
const String _getS3UploadSignedURL = '/api/v1/common/getSignedURL';
const String _reportFeedback = '/api/v1/reportedFeedback/create';
const String _reportBug = '/api/v1/reportedBugs';
const String _reportItems = '/api/v1/reportedItems/create';
const String _socialLogin = '/api/v1/user/socialLogin';
