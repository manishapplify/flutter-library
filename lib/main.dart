import 'package:components/firebase/messaging/initilize.dart';
import 'package:components/routes/navigation.dart';
import 'package:components/screens/screens.dart';
import 'package:components/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FcmService()
    ..registerFCM()
    ..getToken();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: appTheme,
      onGenerateRoute: Navigation.onGenerateRoute,
      initialRoute: Routes.splash,
      home: const LoginScreenTypes(),
    );
  }
}
