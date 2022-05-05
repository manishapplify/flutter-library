part of blocs;

abstract class SplashState extends BaseState {
  const SplashState() : super(const Idle());

  @override
  BaseState resetState() => SplashInitial();

  @override
  BaseState updateStatus(WorkStatus blocStatus) => throw UnimplementedError();
}

class SplashInitial extends SplashState {}

class UpdateAvailable extends SplashState {
  const UpdateAvailable({
    required this.isForceful,
  });

  final bool isForceful;
}

class LatestApp extends SplashState {}
