import 'package:components/enums/platform.dart';

class Config {
  Config({
    required this.appVersion,
    required this.platform,
  });

  final String appVersion;
  final Platform platform;
}
