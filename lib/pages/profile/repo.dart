import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/pages/profile/models/register_user_request.dart';
import 'package:components/services/api.dart';
import 'package:components/services/persistence.dart';
import 'package:components/utils/config.dart';
import 'package:components/enums/signup.dart';
import 'package:dio/dio.dart';

class ProfileRepository {
  ProfileRepository({
    required Api api,
    required Config config,
    required Persistence persistence,
    required AuthCubit authCubit,
  })  : _api = api,
        _config = config,
        _persistence = persistence,
        _authCubit = authCubit;

  final Api _api;
  final Config _config;
  final Persistence _persistence;
  final AuthCubit _authCubit;

  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String countryCode,
    required String phoneNumber,
    required String email,
    required String gender,
    required String profilePic,
    required int age,
    required String address,
    required String city,
    required String notificationEnabled,
    required String refferalCode,
    required Signup signupType,
  }) async {
    if (!_authCubit.state.isAuthorized) {
      throw Exception('not signed in');
    }

    _persistence.saveCountryCode(countryCode);

    final RegisterUserRequest request = RegisterUserRequest(
      authToken: _authCubit.state.user!.accessToken,
      firstName: firstName,
      lastName: lastName,
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      email: email,
      gender: gender,
      profilePic: profilePic,
      age: age,
      address: address,
      city: city,
      notificationEnabled: notificationEnabled,
      platformType: _config.platform.name,
      refferalCode: refferalCode,
      signupType: signupType.name,
    );

    final Response<dynamic> response = await _api.registerUser(request);
    final User user = _authCubit.state.user!.copyWithJson(response.data);
    _authCubit.signupOrLogin(user);
  }
}
