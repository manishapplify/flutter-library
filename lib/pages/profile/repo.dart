import 'dart:io';

import 'package:dio/dio.dart';
import 'package:components/common/app_exception.dart';
import 'package:components/common/config.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/enums/signup.dart';
import 'package:components/pages/profile/models/register_user_request.dart';
import 'package:components/pages/profile/models/update_profile_request.dart';
import 'package:components/services/api/api.dart';
import 'package:components/services/firebase_realtime_database/firebase_realtime_database.dart';
import 'package:components/services/persistence.dart';
import 'package:components/services/s3_image_upload/s3_image_upload.dart';

class ProfileRepository {
  ProfileRepository({
    required Api api,
    required Config config,
    required Persistence persistence,
    required AuthCubit authCubit,
    required S3ImageUpload s3imageUpload,
    required FirebaseRealtimeDatabase firebaseRealtimeDatabase,
  })  : _api = api,
        _config = config,
        _persistence = persistence,
        _authCubit = authCubit,
        _s3imageUpload = s3imageUpload,
        _firebaseRealtimeDatabase = firebaseRealtimeDatabase;

  final Api _api;
  final Config _config;
  final Persistence _persistence;
  final AuthCubit _authCubit;
  final S3ImageUpload _s3imageUpload;
  final FirebaseRealtimeDatabase _firebaseRealtimeDatabase;

  Future<void> registerUser({
    required String? firstName,
    required String? lastName,
    required String? countryCode,
    required String? phoneNumber,
    required String? email,
    required String? gender,
    required File? profilePicFile,
    required int? age,
    required String? address,
    required String? city,
    required String notificationEnabled,
    required String? referralCode,
    required Signup signupType,
  }) async {
    if (!_authCubit.state.isAuthorized) {
      throw AppException.authenticationException();
    }

    if (countryCode is String) {
      _persistence.saveCountryCode(countryCode);
    }

    final RegisterUserRequest request = RegisterUserRequest(
      firstName: firstName,
      lastName: lastName,
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      email: email,
      gender: gender,
      profilePic: await _s3imageUpload.uploadImage(
        s3Directory: _authCubit.state.user!.s3Folders.users,
        image: profilePicFile,
      ),
      age: age,
      address: address,
      city: city,
      notificationEnabled: notificationEnabled,
      platformType: _config.platform.name,
      referralCode: referralCode,
      signupType: signupType.name,
    );

    final Response<dynamic> response = await _api.registerUser(request);
    final User user =
        _authCubit.state.user!.copyWithJson(response.data['data']);
    _authCubit.signupOrLogin(user);
    _firebaseRealtimeDatabase.updateUser(user: user);
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? countryCode,
    String? phoneNumber,
    String? email,
    String? gender,
    File? profilePicFile,
    int? age,
    String? address,
    String? city,
    required String notificationEnabled,
  }) async {
    if (!_authCubit.state.isAuthorized) {
      throw AppException.authenticationException();
    }

    if (countryCode is String) {
      _persistence.saveCountryCode(countryCode);
    }

    final UpdateProfileRequest request = UpdateProfileRequest(
      firstName: firstName,
      lastName: lastName,
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      email: email,
      gender: gender,
      profilePic: await _s3imageUpload.uploadImage(
        s3Directory: _authCubit.state.user!.s3Folders.users,
        image: profilePicFile,
      ),
      age: age,
      address: address,
      city: city,
      notificationEnabled: notificationEnabled,
    );

    final Response<dynamic> response = await _api.updateProfile(request);
    final User user =
        _authCubit.state.user!.copyWithJson(response.data['data']);
    _authCubit.signupOrLogin(user);
    _firebaseRealtimeDatabase.updateUser(user: user);
  }
}
