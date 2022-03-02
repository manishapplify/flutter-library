import 'package:components/Authentication/repo.dart';
import 'package:components/base/base_screen.dart';
import 'package:components/login/bloc.dart';
import 'package:components/login/login.dart';
import 'package:components/routes/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreenTypes extends BaseScreen {
  const LoginScreenTypes({Key? key}) : super(key: key);

  @override
  State<LoginScreenTypes> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseScreenState<LoginScreenTypes> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      title: const Text("Components"),
    );
  }

  @override
  Widget body(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text("Login Screen"),
          onTap: () {
            Future<void>.microtask(
              () => navigator.pushNamed(
                Routes.loginOne,
              ),
            );
          },
        ),
        ListTile(
          title: const Text("Feedback Screen"),
          onTap: () {
            Future<void>.microtask(
              () => navigator.pushNamed(
                Routes.feedbackScreens,
              ),
            );
          },
        ),
      ],
    );
  }
}
