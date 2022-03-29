import 'dart:io';

import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/pages/profile/models/register_user_request.dart';
import 'package:components/pages/profile/models/update_profile_request.dart';
import 'package:components/services/api.dart';
import 'package:components/services/persistence.dart';
import 'package:components/services/s3_image_upload/request.dart';
import 'package:components/services/s3_image_upload/response.dart';
import 'package:components/services/s3_image_upload/s3_image_upload.dart';
import 'package:components/utils/config.dart';
import 'package:components/enums/signup.dart';
import 'package:dio/dio.dart';

class ProfileRepository {
  ProfileRepository({
    required Api api,
    required Config config,
    required Persistence persistence,
    required AuthCubit authCubit,
    required S3ImageUpload s3imageUpload,
  })  : _api = api,
        _config = config,
        _persistence = persistence,
        _authCubit = authCubit,
        _s3imageUpload = s3imageUpload;

  final Api _api;
  final Config _config;
  final Persistence _persistence;
  final AuthCubit _authCubit;
  final S3ImageUpload _s3imageUpload;

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
      throw Exception('not signed in');
    }

    if (countryCode is String) {
      _persistence.saveCountryCode(countryCode);
    }
    Response<dynamic> response;

    final RegisterUserRequest request = RegisterUserRequest(
      firstName: firstName,
      lastName: lastName,
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      email: email,
      gender: gender,
      profilePic: await _getImageUrl(profilePicFile),
      age: age,
      address: address,
      city: city,
      notificationEnabled: notificationEnabled,
      platformType: _config.platform.name,
      referralCode: referralCode,
      signupType: signupType.name,
    );

    response = await _api.registerUser(request);
    final User user =
        _authCubit.state.user!.copyWithJson(response.data['data']);
    _authCubit.signupOrLogin(user);
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
      throw Exception('not signed in');
    }

    if (countryCode is String) {
      _persistence.saveCountryCode(countryCode);
    }
    Response<dynamic> response;

    final UpdateProfileRequest request = UpdateProfileRequest(
      firstName: firstName,
      lastName: lastName,
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      email: email,
      gender: gender,
      profilePic: await _getImageUrl(profilePicFile),
      age: age,
      address: address,
      city: city,
      notificationEnabled: notificationEnabled,
    );

    response = await _api.updateProfile(request);
    final User user =
        _authCubit.state.user!.copyWithJson(response.data['data']);
    _authCubit.signupOrLogin(user);
  }

  Future<String?> _getImageUrl(
    File? profilePicFile,
  ) async {
    if (profilePicFile == null) {
      return null;
    }

    Response<dynamic> response;
    response = await _api.getS3UploadSignedURL(
      S3SignedUrlRequest(
        directory: _authCubit.state.user!.s3Folders.users,
        fileName: profilePicFile.uri.pathSegments.last,
      ),
    );
    final S3SignedUrlResponse s3imageUploadResponse =
        S3SignedUrlResponse.fromJson(response.data);

    response = await _s3imageUpload.uploadImageToSignedURL(
      s3SignedURL: s3imageUploadResponse.uploadURL,
      image: profilePicFile,
    );

    final Uri? uri = Uri.tryParse(s3imageUploadResponse.uploadURL);
    if (uri == null) {
      throw Exception('Could not parse uploadURL');
    }

    return '${uri.scheme}://${uri.authority}${uri.path}';
  }
}
