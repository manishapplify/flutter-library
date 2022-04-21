import 'dart:io';

import 'package:components/services/firebase_storage_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:components/Authentication/repo.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/password_auth.dart';
import 'package:components/enums/platform.dart' as enums;
import 'package:components/exceptions/app_exception.dart';
import 'package:components/pages/profile/repo.dart';
import 'package:components/routes/navigation.dart';
import 'package:components/services/api/api.dart';
import 'package:components/services/firebase_cloud_messaging.dart';
import 'package:components/services/firebase_realtime_database/firebase_realtime_database.dart';
import 'package:components/services/persistence.dart';
import 'package:components/services/s3_image_upload/s3_image_upload.dart';
import 'package:components/utils/config.dart';

class CompositionRoot {
  CompositionRoot({
    required this.authCubit,
    required this.passwordAuthCubit,
    required this.navigation,
    required this.firebaseRealtimeDatabase,
    required this.firebaseStorageServices,
    required this.s3imageUpload,
  });

  final AuthCubit authCubit;
  final PasswordAuthCubit passwordAuthCubit;
  final Navigation navigation;
  final FirebaseRealtimeDatabase firebaseRealtimeDatabase;
  final FirebaseStorageServices firebaseStorageServices;
  final S3ImageUpload s3imageUpload;
}

Future<CompositionRoot> configureDependencies() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final Persistence persistence =
      Persistence(sharedPreferences: sharedPreferences);
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final Config config = Config(
    appVersion: packageInfo.version,
    platform: kIsWeb
        ? enums.Platform.WEB
        : Platform.isAndroid
            ? enums.Platform.ANDROID
            : enums.Platform.IOS,
  );
  final Api api = Api(
    baseOptions: BaseOptions(
      baseUrl: const String.fromEnvironment(
        'baseUrl',
        defaultValue: 'https://api-lib.applifyapps.com',
      ),
      contentType: "application/json",
    ),
    interceptorsWrapper: InterceptorsWrapper(
      onRequest: _requestInterceptor,
      onResponse: _responseInterceptor,
      onError: _errorInterceptor,
    ),
  );
  final AuthCubit authCubit = AuthCubit(
    persistence: persistence,
    api: api,
  );
  final FirebaseCloudMessaging fcm = FirebaseCloudMessaging()
    ..registerFCM()
    ..getToken();
  final PasswordAuthCubit passwordAuthCubit = PasswordAuthCubit(
    persistence,
  );
  final FirebaseRealtimeDatabase firebaseRealtimeDatabase =
      FirebaseRealtimeDatabase();
  final FirebaseStorageServices firebaseStorageServices = FirebaseStorageServices();    
  final AuthRepository authRepository = AuthRepository(
    api: api,
    config: config,
    fcm: fcm,
    persistence: persistence,
    authCubit: authCubit,
    passwordAuthCubit: passwordAuthCubit,
    firebaseRealtimeDatabase: firebaseRealtimeDatabase,
  );

  final S3ImageUpload s3imageUpload = S3ImageUpload(
    baseOptions: BaseOptions(
      baseUrl: const String.fromEnvironment(
        'baseUrl',
        defaultValue: 'https://api-lib.applifyapps.com',
      ),
    ),
    api: api,
    interceptorsWrapper: InterceptorsWrapper(
      onRequest: _requestInterceptor,
      onResponse: _responseInterceptor,
      onError: _errorInterceptor,
    ),
    s3BaseUrl: const String.fromEnvironment(
      's3BaseUrl',
      defaultValue: 'https://applify-library.s3.ap-southeast-1.amazonaws.com/',
    ),
  );
  final ProfileRepository profileRepository = ProfileRepository(
    api: api,
    config: config,
    persistence: persistence,
    authCubit: authCubit,
    s3imageUpload: s3imageUpload,
    firebaseRealtimeDatabase: firebaseRealtimeDatabase,
  );

  return CompositionRoot(
    authCubit: authCubit,
    passwordAuthCubit: passwordAuthCubit,
    navigation: Navigation(
      api: api,
      authRepository: authRepository,
      profileRepository: profileRepository,
      authCubit: authCubit,
      config: config,
      persistence: persistence,
      s3imageUpload: s3imageUpload,
      firebaseRealtimeDatabase: firebaseRealtimeDatabase,
    ),
    firebaseRealtimeDatabase: firebaseRealtimeDatabase,
    firebaseStorageServices: firebaseStorageServices,
    s3imageUpload: s3imageUpload,
  );
}

void _responseInterceptor(
    Response<dynamic> response, ResponseInterceptorHandler handler) {
  print('Response');
  print('(${response.realUri.path}) $response');

  handler.next(response);
}

void _requestInterceptor(
    RequestOptions options, RequestInterceptorHandler handler) async {
  print('Request');
  print('(${options.method}) ${options.uri}');
  print('${options.headers} ${options.data}');

  handler.next(options);
}

void _errorInterceptor(DioError error, ErrorInterceptorHandler handler) {
  print('Error');
  print('(${error.requestOptions.uri.path}) ${error.response}');

  final dynamic response = error.response?.data;

  if (response is Map<String, dynamic>) {
    if (response['statusCode'] == 400) {
      throw AppException.api400Exception(message: response['message']);
    } else if (response['statusCode'] == 401) {
      final BuildContext context = Navigation.navigatorKey.currentContext!;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Unauthorized'),
            content: const Text(
                'Your access token has been revoked, please log in again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context)
                  ..popUntil((_) => false)
                  ..pushNamed(Routes.login),
                child: const Text(
                  'Okay',
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  handler.next(error);
}
