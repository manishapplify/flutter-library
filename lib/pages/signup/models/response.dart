import 'package:components/base/base_response.dart';

class SignupResponse extends BaseResponse {
  SignupResponse({
    required int statusCode,
    required String message,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.countryCode,
    required this.phoneNumber,
    required this.isEmailVerified,
    required this.profilePic,
    required this.gender,
    required this.registrationStep,
    required this.notificationEnabled,
    required this.isBlocked,
    required this.accessToken,
    required this.s3Folders,
  }) : super(statusCode, message);

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    final S3Folders? s3Folders = json['data']['s3Folders'] != null
        ? S3Folders.fromJson(json['data']['s3Folders'])
        : null;

    return SignupResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      id: json['data']['id'],
      firstName: json['data']['firstName'],
      lastName: json['data']['lastName'],
      email: json['data']['email'],
      countryCode: json['data']['countryCode'],
      phoneNumber: json['data']['phoneNumber'],
      isEmailVerified: json['data']['isEmailVerified'],
      profilePic: json['data']['profilePic'],
      gender: json['data']['gender'],
      registrationStep: json['data']['registrationStep'],
      notificationEnabled: json['data']['notificationEnabled'],
      isBlocked: json['data']['isBlocked'],
      accessToken: json['data']['accessToken'],
      s3Folders: s3Folders,
    );
  }

  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? countryCode;
  final String? phoneNumber;
  final int isEmailVerified;
  final String? profilePic;
  final String gender;
  final int registrationStep;
  final int notificationEnabled;
  final int isBlocked;
  final String accessToken;
  final S3Folders? s3Folders;
}

class S3Folders {
  S3Folders({required this.users, required this.admin});

  factory S3Folders.fromJson(Map<String, dynamic> json) {
    return S3Folders(
      users: json['users'],
      admin: json['admin'],
    );
  }

  final String users;
  final String admin;
}
