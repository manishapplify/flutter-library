import 'package:components/cubits/auth_cubit.dart';
import 'package:components/dependencies/composition_root.dart';
import 'package:components/routes/navigation.dart';
import 'package:components/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final CompositionRoot compositionRoot = await configureDependencies();
  runApp(
    MyApp(
      compositionRoot: compositionRoot,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    required this.compositionRoot,
    Key? key,
  }) : super(key: key);

  final CompositionRoot compositionRoot;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => compositionRoot.authCubit,
      child: MaterialApp(
        title: 'Flutter library',
        theme: appTheme,
        onGenerateRoute: compositionRoot.navigation.onGenerateRoute,
        navigatorKey: compositionRoot.navigation.navigatorKey,
        initialRoute: Routes.splash,
      ),
    );
  }
}
