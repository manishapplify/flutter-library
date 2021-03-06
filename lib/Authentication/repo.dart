import 'package:components/Authentication/models/logout_request.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/password_auth.dart';
import 'package:components/enums/platform.dart';
import 'package:components/common/app_exception.dart';
import 'package:components/pages/change_password/model/request.dart';
import 'package:components/pages/forgot_password/models/request.dart';
import 'package:components/pages/forgot_password/models/response.dart';
import 'package:components/pages/login/models/login_request.dart';
import 'package:components/pages/login/models/login_response.dart';
import 'package:components/pages/login/models/social_signin_request.dart';
import 'package:components/pages/login/models/social_signin_response.dart';
import 'package:components/pages/otp/models/request.dart';
import 'package:components/pages/reset_password/models/request.dart';
import 'package:components/pages/signup/models/request.dart';
import 'package:components/pages/signup/models/response.dart';
import 'package:components/services/api/api.dart';
import 'package:components/services/firebase_cloud_messaging.dart';
import 'package:components/services/firebase_realtime_database/firebase_realtime_database.dart';
import 'package:components/services/persistence.dart';
import 'package:components/common/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository {
  AuthRepository({
    required Api api,
    required Config config,
    required FirebaseCloudMessaging fcm,
    required Persistence persistence,
    required AuthCubit authCubit,
    required PasswordAuthCubit passwordAuthCubit,
    required FirebaseRealtimeDatabase firebaseRealtimeDatabase,
  })  : _api = api,
        _config = config,
        _fcm = fcm,
        _persistence = persistence,
        _authCubit = authCubit,
        _passwordAuthCubit = passwordAuthCubit,
        _firebaseRealtimeDatabase = firebaseRealtimeDatabase;

  final Api _api;
  final Config _config;
  final FirebaseCloudMessaging _fcm;
  final Persistence _persistence;
  final AuthCubit _authCubit;
  final PasswordAuthCubit _passwordAuthCubit;
  final FirebaseRealtimeDatabase _firebaseRealtimeDatabase;

  Future<void> login({
    required String username,
    required String? password,
  }) async {
    if (_fcm.deviceToken == null) {
      await _fcm.getToken();
    }

    final LoginRequest request = LoginRequest(
      platformType: _config.platform.name,
      deviceToken: _fcm.deviceToken!,
      countryCode: _persistence.fetchCountryCode() ?? '+91',
      emailOrPhoneNumber: username.trim(),
      password: password,
    );

    final Response<dynamic> response = await _api.login(request);
    final LoginResponse loginResponse = LoginResponse.fromJson(response.data);

    _authCubit.signupOrLogin(loginResponse.user);
    _firebaseRealtimeDatabase.addUser(loginResponse.user);
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final String socialId = googleSignInAccount.id;
      final String socialEmail = googleSignInAccount.email;
      await _signInWithSocialId(
          socialId: socialId, socialEmail: socialEmail, loginType: 3);
    } else {
      throw AppException.googleSignInException();
    }
  }

  Future<void> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final Map<String, dynamic> requestData =
          await FacebookAuth.i.getUserData(fields: "email");
      final String socialId = requestData['id'];
      final String socialEmail = requestData['email'];
      await _signInWithSocialId(
          socialId: socialId, socialEmail: socialEmail, loginType: 2);
    } else {
      throw AppException.facebookSignInException(result.message);
    }
  }

  Future<void> signInWithApple() async {
    if (_config.platform != Platform.IOS) {
      throw AppException.unsupportedActionException();
    }

    final AuthorizationCredentialAppleID credential =
        await SignInWithApple.getAppleIDCredential(
      scopes: <AppleIDAuthorizationScopes>[
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],

      // TODO: Configure to enable apple login in android.
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'com.applify.flutter.library.android',
        redirectUri: Uri.parse('uri'),
      ),
    );

    if (credential.userIdentifier != null) {
      await _signInWithSocialId(
        socialId: credential.userIdentifier!,
        socialEmail: credential.email,
        loginType: 4,
      );
    } else {
      throw AppException.appleSignInException();
    }
  }

  Future<void> _signInWithSocialId({
    required String socialId,
    required String? socialEmail,
    required int loginType,
  }) async {
    if (_fcm.deviceToken == null) {
      await _fcm.getToken();
    }
    final SocialSigninRequest request = SocialSigninRequest(
      platformType: _config.platform.name,
      deviceToken: _fcm.deviceToken!,
      loginType: loginType,
      socialId: socialId,
      emailOrPhoneNumber: socialEmail,
      countryCode: _persistence.fetchCountryCode(),
    );
    final Response<dynamic> response = await _api.socialLogin(request);
    final SocialSigninResponse socialSigninResponse =
        SocialSigninResponse.fromJson(response.data);
    _authCubit.signupOrLogin(socialSigninResponse.user);
    _firebaseRealtimeDatabase.addUser(socialSigninResponse.user);
  }

  Future<void> signUp({
    String? countryCode,
    String? phoneNumber,
    String? email,
    required String password,
    required int userType,
  }) async {
    if (_fcm.deviceToken == null) {
      await _fcm.getToken();
    }

    final Response<dynamic> response = await _api.signup(
      SignupRequest(
        platformType: _config.platform.name,
        deviceToken: _fcm.deviceToken!,
        countryCode: countryCode?.trim(),
        phoneNumber: phoneNumber?.trim(),
        email: email?.trim(),
        password: password,
        userType: userType,
      ),
    );
    final SignupResponse signupResponse =
        SignupResponse.fromJson(response.data);
    _authCubit.signupOrLogin(signupResponse.user);

    if (countryCode is String) {
      _persistence.saveCountryCode(countryCode);
    }
  }

  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    final Response<dynamic> response = await _api.forgotPassword(request);
    final ForgotPasswordResponse forgotPasswordResponse =
        ForgotPasswordResponse.fromJson(response.data);

    _passwordAuthCubit.setToken(
      token: forgotPasswordResponse.token,
      email: request.email.trim(),
    );
  }

  Future<void> verifyForgetPasswordOtp(String otp) async {
    if (!_passwordAuthCubit.state.isTokenGenerated) {
      throw AppException.passwordResetTokenAbsentException();
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
      throw AppException.passwordResetTokenAbsentException();
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
      throw AppException.authenticationException();
    }
    await Future<dynamic>.delayed(const Duration(seconds: 5));
    final ChangePasswordRequest request = ChangePasswordRequest(
      oldPassword: currentPassword,
      password: newPassword,
    );

    await _api.changePassword(request);
  }

  Future<dynamic> logout() async {
    if (_fcm.deviceToken == null) {
      await _fcm.getToken();
    }
    if (!_authCubit.state.isAuthorized) {
      throw AppException.authenticationException();
    }
    final LogoutRequest request = LogoutRequest(
      deviceToken: _fcm.deviceToken!,
    );

    await _api.logout(request);
    _authCubit.logoutOrDeleteAccount();
  }

  Future<dynamic> deleteAccount() async {
    if (!_authCubit.state.isAuthorized) {
      throw AppException.authenticationException();
    }

    await _api.deleteAccount();
    _firebaseRealtimeDatabase.removeUser(user: _authCubit.state.user);
    _authCubit.logoutOrDeleteAccount();
  }

  Future<dynamic> feedbackSubmit({
    required String? feedbackissue,
    List<String>? feedbackreasons,
  }) async {
    await Future<dynamic>.delayed(const Duration(seconds: 5));
  }
}
