import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/password_auth.dart';
import 'package:components/pages/change_password/model/request.dart';
import 'package:components/pages/delete_account/model/request.dart';
import 'package:components/pages/delete_account/model/response.dart';
import 'package:components/pages/forgot_password/models/request.dart';
import 'package:components/pages/forgot_password/models/response.dart';
import 'package:components/pages/login/models/request.dart';
import 'package:components/pages/login/models/response.dart';
import 'package:components/pages/logout/model/request.dart';
import 'package:components/pages/logout/model/response.dart';
import 'package:components/pages/otp/models/request.dart';
import 'package:components/pages/reset_password/models/request.dart';
import 'package:components/pages/signup/models/request.dart';
import 'package:components/services/api.dart';
import 'package:components/services/firebase_cloud_messaging.dart';
import 'package:components/services/persistence.dart';
import 'package:components/utils/config.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  AuthRepository({
    required Api api,
    required Config config,
    required FirebaseCloudMessaging fcm,
    required Persistence persistence,
    required AuthCubit authCubit,
    required PasswordAuthCubit passwordAuthCubit,
  })  : _api = api,
        _config = config,
        _fcm = fcm,
        _persistence = persistence,
        _authCubit = authCubit,
        _passwordAuthCubit = passwordAuthCubit;

  final Api _api;
  final Config _config;
  final FirebaseCloudMessaging _fcm;
  final Persistence _persistence;
  final AuthCubit _authCubit;
  final PasswordAuthCubit _passwordAuthCubit;

  Future<String> attemptAutoLogin() async {
    await Future<dynamic>.delayed(const Duration(seconds: 1));
    throw Exception('not signed in');
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (_fcm.deviceToken == null) {
      await _fcm.getToken();
    }

    final LoginRequest request = LoginRequest(
      platformType: _config.platform.name,
      deviceToken: _fcm.deviceToken!,
      countryCode: _persistence.fetchCountryCode() ?? '+91',
      emailOrPhoneNumber: username,
      password: password,
    );

    final Response<dynamic> response = await _api.login(request);
    final LoginResponse loginResponse = LoginResponse.fromJson(response.data);

    _authCubit.signupOrLogin(loginResponse.user);
  }

  Future<void> signUp({
    required String profilePic,
    required String firstName,
    required String lastName,
    required String countryCode,
    required String phoneNumber,
    required String email,
    required String password,
    String? referralCode,
  }) async {
    await Future<dynamic>.delayed(const Duration(seconds: 2));
    _api.signup(
      SignupRequest(
        profilePic: profilePic,
        firstName: firstName,
        lastName: lastName,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
        referralCode: referralCode,
      ),
    );
  }

  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    final Response<dynamic> response = await _api.forgotPassword(request);
    final ForgotPasswordResponse forgotPasswordResponse =
        ForgotPasswordResponse.fromJson(response.data);

    _passwordAuthCubit.setToken(
      token: forgotPasswordResponse.token,
      email: request.email,
    );
  }

  Future<void> verifyForgetPasswordOtp(String otp) async {
    if (!_passwordAuthCubit.state.isTokenGenerated) {
      throw Exception('No token present');
    }

    final VerifyForgetPasswordOtpRequest request =
        VerifyForgetPasswordOtpRequest(
      token: _passwordAuthCubit.state.forgotPasswordToken!.token,
      forgotPasswordOtp: otp,
    );

    await _api.verifyForgetPasswordOtp(request);
  }

  Future<void> resetPassword(String password) async {
    if (!_passwordAuthCubit.state.isTokenGenerated) {
      throw Exception('No token present');
    }

    final ResetPasswordRequest request = ResetPasswordRequest(
      token: _passwordAuthCubit.state.forgotPasswordToken!.token,
      password: password,
    );

    await _api.resetPassword(request);
  }

  Future<dynamic> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!_authCubit.state.isAuthorized) {
      throw Exception('not signed in');
    }
    await Future<dynamic>.delayed(const Duration(seconds: 5));
    print('ChamgePasswordSubmit');
    final ChangePasswordRequest request = ChangePasswordRequest(
        oldPassword: currentPassword,
        password: newPassword,
        authorization: _authCubit.state.user!.accessToken);

    final Response<dynamic> response = await _api.changePassword(request);
    throw Exception('failed ChangePasswordSubmission');
  }

  Future<dynamic> logout() async {
    print('Logout');
    if (_fcm.deviceToken == null) {
      await _fcm.getToken();
    }
    if (!_authCubit.state.isAuthorized) {
      throw Exception('not signed in');
    }
    final LogoutRequest request = LogoutRequest(
        deviceToken: _fcm.deviceToken!,
        authorization: _authCubit.state.user!.accessToken);

    final Response<dynamic> response = await _api.logout(request);
    final LogoutResponse logoutResponse =
        LogoutResponse.fromJson(response.data);
    if (logoutResponse.message == "success") {
      _authCubit.logout();
    }
    throw Exception('failed Logout');
  }

  Future<dynamic> deleteAccount() async {
    if (!_authCubit.state.isAuthorized) {
      throw Exception('not signed in');
    }
    print('DeleteAccount');
    final DeleteAccountRequest request =
        DeleteAccountRequest(authorization: _authCubit.state.user!.accessToken);

    final Response<dynamic> response = await _api.deleteAccount(request);
    final DeleteAccountResponse deleteAccountResponse =
        DeleteAccountResponse.fromJson(response.data);
    if (deleteAccountResponse.message == "success") {
      _authCubit.deleteAccount();
    }
    throw Exception('failed ChangePasswordSubmission');
  }

  Future<dynamic> feedbackSubmit({
    required String? feedbackissue,
    List<String>? feedbackreasons,
  }) async {
    print('Feedback Submit');
    await Future<dynamic>.delayed(const Duration(seconds: 5));
    print('feedbackSubmit');
    throw Exception('failed feedbackSubmission');
  }

  Future<dynamic> feedback2Submit(
      {required String? feedbackissue,
      required String? feedbackreason,
      required double? feedbackRating}) async {
    print('Feedback Submit');
    await Future<dynamic>.delayed(const Duration(seconds: 5));
    print('feedbackSubmit');
    throw Exception('failed feedbackSubmission');
  }
}
