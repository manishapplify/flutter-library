import 'dart:io';

import 'package:components/common_models/s3_image_upload/request.dart';
import 'package:components/common_models/s3_image_upload/response.dart';
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
    // Get signed url for the profilePic
    // Upload it to that url, save the returned url of s3
    // pass that url in RegisterUserRequest

    if (!_authCubit.state.isAuthorized) {
      throw Exception('not signed in');
    }

    if (countryCode is String) {
      _persistence.saveCountryCode(countryCode);
    }

    String? profilePicUrl;
    Response<dynamic> response;
    
    if (profilePicFile is File) {
      response = await _api.getS3UploadSignedURL(
        S3ImageUploadRequest(
          directory: _authCubit.state.user!.s3Folders.users,
          fileName: profilePicFile.uri.pathSegments.last,
        ),
      );
      final S3ImageUploadResponse s3imageUploadResponse =
          S3ImageUploadResponse.fromJson(response.data);

      response = await _api.uploadImageToS3SignedURL(
        s3SignedURL: s3imageUploadResponse.uploadURL,
        image: profilePicFile,
      );

      final Uri? uri = Uri.tryParse(s3imageUploadResponse.uploadURL);
      if (uri == null) {
        throw Exception('Could not parse uploadURL');
      }

      profilePicUrl = '${uri.scheme}://${uri.authority}${uri.path}';
    }
    final RegisterUserRequest request = RegisterUserRequest(
      firstName: firstName,
      lastName: lastName,
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      email: email,
      gender: gender,
      profilePic: profilePicUrl,
      age: age,
      address: address,
      city: city,
      notificationEnabled: notificationEnabled,
      platformType: _config.platform.name,
      referralCode: referralCode,
      signupType: signupType.name,
    );

    response = await _api.registerUser(request);
    final User user = _authCubit.state.user!.copyWithJson(response.data);
    _authCubit.signupOrLogin(user);
  }
}
