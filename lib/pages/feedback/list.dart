import 'package:components/base/base_screen.dart';
import 'package:components/routes/navigation.dart';
import 'package:flutter/material.dart';

class FeedbackScreenTypes extends BaseScreen {
  const FeedbackScreenTypes({Key? key}) : super(key: key);

  @override
  State<FeedbackScreenTypes> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseScreenState<FeedbackScreenTypes> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      title: const Text("Feedback Screens"),
    );
  }

  @override
  Widget body(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text("Feedback 1"),
          onTap: () {
            Future<void>.microtask(
              () => navigator.pushNamed(
                Routes.feedbackOne,
              ),
            );
          },
        ),
        ListTile(
          title: const Text("Feedback 2"),
          onTap: () {
            Future<void>.microtask(
              () => navigator.pushNamed(
                Routes.feedbackSecond,
              ),
            );
          },
        ),
        ListTile(
          title: const Text("Feedback 3"),
          onTap: () {
            Future<void>.microtask(
              () => navigator.pushNamed(
                Routes.feedbackThird,
              ),
            );
          },
        ),
        ListTile(
          title: const Text("Feedback 4"),
          onTap: () {
            Future<void>.microtask(
              () => navigator.pushNamed(
                Routes.feedbackFourth,
              ),
            );
          },
        ),
      ],
    );
  }
}
