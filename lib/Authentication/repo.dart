class AuthRepository {
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

  Future<void> signUp(
      {required String profilePic,
      required String firstName,
      required String lastName,
      required String countryCode,
      required String phoneNumber,
      required String email,
      required String password,
      String? referralCode}) async {
    await Future<dynamic>.delayed(const Duration(seconds: 2));
  }
}
