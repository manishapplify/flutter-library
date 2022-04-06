part of 'bloc.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class UpdateAvailable extends SplashState {
  UpdateAvailable({
    required this.isForceful,
  });

  final bool isForceful;
}

class LatestApp extends SplashState {}
