import 'package:flutter/material.dart';

abstract class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);
}

abstract class BaseScreenState<T extends BaseScreen> extends State<T> {
  EdgeInsets padding = const EdgeInsets.all(16.0);
  PreferredSizeWidget appBar(BuildContext context);

  Widget body(BuildContext context);
  bool isLoading = false;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
          SnackBar snackBar) =>
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  TextTheme get textTheme => Theme.of(context).textTheme;
  NavigatorState get navigator => Navigator.of(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Padding(
                padding: padding,
                child: body(context),
              ),
              Visibility(
                visible: isLoading,
                child: const CircularProgressIndicator(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
