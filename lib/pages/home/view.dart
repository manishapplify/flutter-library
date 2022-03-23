import 'package:components/base/base_page.dart';
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
