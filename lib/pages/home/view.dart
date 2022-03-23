import 'package:components/base/base_page.dart';
import 'package:components/routes/navigation.dart';
import 'package:flutter/material.dart';

class HomePage extends BasePage {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends BasePageState<HomePage> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                navigator.pushNamed(
                  Routes.settings,
                );
              },
              icon: const Icon(Icons.settings))
        ],
      );

  @override
  Widget body(BuildContext context) {
    return Center(
      child: Text(
        'Home',
        style: textTheme.headline1,
      ),
    );
  }
}
