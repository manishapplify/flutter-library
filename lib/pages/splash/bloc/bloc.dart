import 'package:bloc/bloc.dart';
import 'package:components/pages/splash/models/response.dart';
import 'package:components/services/api/api.dart';
import 'package:components/common_models/config.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc({
    required Api api,
    required Config config,
  })  : _api = api,
        _config = config,
        super(SplashInitial()) {
    on<OnAppOpened>(_onAppOpenedHandler);
  }

  final Api _api;
  final Config _config;

  Future<void> _onAppOpenedHandler(
      OnAppOpened event, Emitter<SplashState> emit) async {
    final Response<dynamic> response =
        await _api.appVersion(_config.platform.name);

    final AppVersionResponse appVersionResponse =
        AppVersionResponse.fromJson(response.data);

    if (_config.appVersion.compareTo(appVersionResponse.minimumVersion) < 0) {
      emit(
        UpdateAvailable(
          isForceful: true,
        ),
      );
    } else if (_config.appVersion.compareTo(appVersionResponse.version) < 0) {
      emit(
        UpdateAvailable(
          isForceful: false,
        ),
      );
    } else {
      emit(LatestApp());
    }
  }
}
