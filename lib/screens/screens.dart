import 'package:components/base/base_page.dart';
import 'package:components/routes/navigation.dart';
import 'package:flutter/material.dart';

class LoginScreenTypes extends BasePage {
  const LoginScreenTypes({Key? key}) : super(key: key);

  @override
  State<LoginScreenTypes> createState() => _LoginScreenState();
}

class _LoginScreenState extends BasePageState<LoginScreenTypes> {
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
        ListTile(
          title: const Text("Comment"),
          onTap: () {
            Future<void>.microtask(
              () => navigator.pushNamed(
                Routes.comments,
              ),
            );
          },
        ),
        ListTile(
          title: const Text("One-One Chat"),
          onTap: () {
            Future<void>.microtask(
              () => navigator.pushNamed(
                Routes.chat,
              ),
            );
          },
        ),
      ],
    );
  }
}
