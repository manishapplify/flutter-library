import 'package:components/cubits/auth_cubit.dart';
import 'package:components/pages/splash/bloc/bloc.dart';
import 'package:components/routes/navigation.dart';
import 'package:components/pages/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends BasePage {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends BasePageState<SplashPage> {
  bool expand = false;
  late final SplashBloc bloc;
  late final AuthCubit authCubit;

  @override
  void initState() {
    bloc = BlocProvider.of(context)..add(OnAppOpened());
    authCubit = BlocProvider.of(context);
    Future<void>.delayed(
      const Duration(
        milliseconds: 500,
      ),
    ).then((_) => setState(() => expand = true));

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
                      onPressed: navigateToNextScreen,
                      child: const Text('Skip'),
                    ),
                ],
              ),
              barrierDismissible: !state.isForceful,
            ),
          );
        } else if (state is LatestApp) {
          navigateToNextScreen();
        }

        return Center(
          child: AnimatedContainer(
            width: expand ? 300.0 : 150.0,
            height: expand ? 300.0 : 150.0,
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
            child: const FlutterLogo(),
          ),
        );
      },
    );
  }

  void navigateToNextScreen() {
    Future<void>.microtask(
      () => navigator.popUntil(
        (_) => false,
      ),
    );
    Navigation.navigateAfterSplashOrLogin(authCubit.state.user);
  }
}
