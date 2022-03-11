import 'package:components/cubits/auth_cubit.dart';
import 'package:components/pages/login/models/request.dart';
import 'package:components/pages/login/models/response.dart';
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
  })  : _api = api,
        _config = config,
        _fcm = fcm,
        _persistence = persistence,
        _authCubit = authCubit;

  final Api _api;
  final Config _config;
  final FirebaseCloudMessaging _fcm;
  final Persistence _persistence;
  final AuthCubit _authCubit;

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
      countryCode: _persistence.fetchCountryCode() ?? 'in',
      emailOrPhoneNumber: username,
      password: password,
    );

    final Response<dynamic> response = await _api.login(request);
    final LoginResponse loginResponse = LoginResponse.fromJson(response.data);

    _authCubit.signupOrLogin(loginResponse.user);
    _persistence.saveUser(loginResponse.user);
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
}
