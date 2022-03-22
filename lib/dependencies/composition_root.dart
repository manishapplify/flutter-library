import 'dart:io';

import 'package:components/Authentication/repo.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/password_auth.dart';
import 'package:components/services/firebase_cloud_messaging.dart';
import 'package:components/routes/navigation.dart';
import 'package:components/services/api.dart';
import 'package:components/services/persistence.dart';
import 'package:components/utils/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:components/enums/platform.dart' as enums;

class CompositionRoot {
  CompositionRoot({
    required this.authCubit,
    required this.passwordAuthCubit,
    required this.navigation,
  });

  final AuthCubit authCubit;
  final PasswordAuthCubit passwordAuthCubit;
  final Navigation navigation;
}

Future<CompositionRoot> configureDependencies() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final Persistence persistence =
      Persistence(sharedPreferences: sharedPreferences);
  final AuthCubit authCubit = AuthCubit(persistence);
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
      baseUrl: 'https://api-lib.applifyapps.com',
    ),
    interceptorsWrapper: InterceptorsWrapper(
      onRequest: _requestInterceptor,
      onResponse: _responseInterceptor,
      onError: _errorInterceptor,
    ),
  );
  final FirebaseCloudMessaging fcm = FirebaseCloudMessaging()
    ..registerFCM()
    ..getToken();
  final PasswordAuthCubit passwordAuthCubit = PasswordAuthCubit(
    persistence,
  );
  final AuthRepository authRepository = AuthRepository(
    api: api,
    config: config,
    fcm: fcm,
    persistence: persistence,
    authCubit: authCubit,
    passwordAuthCubit: passwordAuthCubit,
  );

  return CompositionRoot(
    authCubit: authCubit,
    passwordAuthCubit: passwordAuthCubit,
    navigation: Navigation(
      api: api,
      authRepository: authRepository,
      authCubit: authCubit,
      config: config,
      persistence: persistence,
    ),
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
  options.headers["Content-Type"] = "application/json";
  print('Request');
  print('(${options.method}) ${options.uri}');
  print('${options.headers} ${options.data}');

  handler.next(options);
}

void _errorInterceptor(DioError error, ErrorInterceptorHandler handler) {
  print('Error');
  print('(${error.requestOptions.uri.path}) $error');

  handler.next(error);
}
