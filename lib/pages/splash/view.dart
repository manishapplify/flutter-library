import 'dart:io';

import 'package:components/enums/platform.dart' as enums;
import 'package:components/pages/splash/bloc/bloc.dart';
import 'package:components/routes/navigation.dart';
import 'package:components/base/base_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashPage extends BaseScreen {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends BaseScreenState<SplashPage> {
  bool selected = false;
  late final SplashBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of(context);
    Future<void>.delayed(
      const Duration(
        milliseconds: 500,
      ),
    ).then((_) => setState(() => selected = true));
    PackageInfo.fromPlatform().then(
      (PackageInfo info) {
        bloc.add(
          CurrentVersionFetched(
            version: info.version,
            platform: kIsWeb
                ? enums.Platform.web
                : Platform.isAndroid
                    ? enums.Platform.android
                    : enums.Platform.ios,
          ),
        );
      },
    );

    super.initState();
  }

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<SplashBloc, SplashState>(
      builder: (BuildContext context, SplashState state) {
        if (state is UpdateAvailable) {
          Future<void>.microtask(
            () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Update app to continue.'),
                content: const Text('A new version of the app is available.'),
                actions: <Widget>[
                  if (!state.isForceful)
                    TextButton(
                      onPressed: () {
                        navigator
                          ..popUntil(
                            (_) => true,
                          )
                          ..pushNamed(Routes.login);
                      },
                      child: const Text('Continue'),
                    ),
                ],
              ),
              barrierDismissible: !state.isForceful,
            ),
          );
        } else if (state is LatestApp) {
          Future<void>.microtask(
            () => navigator.popAndPushNamed(
              Routes.login,
            ),
          );
        }

        return Center(
          child: AnimatedContainer(
            width: selected ? 300.0 : 150.0,
            height: selected ? 300.0 : 150.0,
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
            child: const FlutterLogo(),
          ),
        );
      },
    );
  }
}
