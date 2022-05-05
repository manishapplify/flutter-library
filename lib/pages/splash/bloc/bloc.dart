part of blocs;

class SplashBloc extends BaseBloc<SplashEvent, SplashState> {
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
       const UpdateAvailable(
          isForceful: true,
        ),
      );
    } else if (_config.appVersion.compareTo(appVersionResponse.version) < 0) {
      emit(
      const  UpdateAvailable(
          isForceful: false,
        ),
      );
    } else {
      emit(LatestApp());
    }
  }
}
