part of 'bloc.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class UpgradeAvailable extends SplashState {
  UpgradeAvailable({
    required this.isForceful,
  });

  final bool isForceful;
}

class LatestApp extends SplashState {}
