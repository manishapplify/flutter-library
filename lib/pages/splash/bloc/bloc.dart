import 'package:bloc/bloc.dart';
import 'package:components/enums/platform.dart';
import 'package:components/pages/splash/models/response.dart';
import 'package:components/services/api.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc({
    required Api api,
  })  : _api = api,
        super(SplashInitial()) {
    on<CurrentVersionFetched>(_currentVersionFetchedHandler);
  }

  final Api _api;

  Future<void> _currentVersionFetchedHandler(
      CurrentVersionFetched event, Emitter<SplashState> emit) async {
    final Response<dynamic> response =
        await _api.appVersion(event.platform.name);

    final AppVersionResponse appVersionResponse =
        AppVersionResponse.fromJson(response.data);

    if (event.version.compareTo(appVersionResponse.minimumVersion) < 0) {
      emit(
        UpdateAvailable(
          isForceful: true,
        ),
      );
    } else if (event.version.compareTo(appVersionResponse.version) < 0) {
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
