part of 'bloc.dart';

@immutable
abstract class SplashEvent {}

class CurrentVersionFetched extends SplashEvent {
  CurrentVersionFetched({
    required this.version,
    required this.platform,
  });

  final String version;
  final Platform platform;
}
