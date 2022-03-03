import 'package:components/pages/signup/models/request.dart';
import 'package:components/services/api.dart';

class AuthRepository {
  AuthRepository(this._api) {}

  final Api _api;

  Future<String> attemptAutoLogin() async {
    await Future<dynamic>.delayed(const Duration(seconds: 1));
    throw Exception('not signed in');
  }

  Future<String> login({
    required String username,
    required String password,
  }) async {
    print('attempting login');
    await Future<dynamic>.delayed(const Duration(seconds: 5));
    return 'Login Sucessfull';
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
