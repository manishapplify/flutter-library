import 'package:components/base/base_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends BaseScreen {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends BaseScreenState<HomePage> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        title: const Text('Home'),
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
