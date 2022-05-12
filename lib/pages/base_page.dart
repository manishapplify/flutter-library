import 'package:flutter/material.dart';

abstract class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);
}

abstract class BasePageState<T extends BasePage> extends State<T> {
  EdgeInsets padding = const EdgeInsets.all(16.0);
  PreferredSizeWidget? appBar(BuildContext context) => null;
  Widget? drawer(BuildContext context) => null;

  Widget body(BuildContext context);
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
          SnackBar snackBar) =>
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  TextTheme get textTheme => Theme.of(context).textTheme;
  ColorScheme get colorScheme => Theme.of(context).colorScheme;
  NavigatorState get navigator => Navigator.of(context);
  RouteSettings get routeSettings => ModalRoute.of(context)!.settings;
  void openDrawer(BuildContext context) => Scaffold.of(context).openDrawer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      drawer: drawer(context),
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
              if (_isLoading)
                const Material(
                  color: Colors.transparent,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
