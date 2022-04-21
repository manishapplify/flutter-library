import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/password_auth.dart';
import 'package:components/dependencies/composition_root.dart';
import 'package:components/firebase_options.dart';
import 'package:components/pages/chat/bloc/bloc.dart';
import 'package:components/routes/navigation.dart';
import 'package:components/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AuthCubit>(
          create: (_) => compositionRoot.authCubit,
        ),
        BlocProvider<PasswordAuthCubit>(
          create: (_) => compositionRoot.passwordAuthCubit,
        ),
        BlocProvider<ChatBloc>(
          create: (_) => ChatBloc(
            authCubit: compositionRoot.authCubit,
            firebaseRealtimeDatabase: compositionRoot.firebaseRealtimeDatabase,
            firebaseStorageServices: compositionRoot.firebaseStorageServices,
            imageBaseUrl: compositionRoot.s3imageUpload.s3BaseUrl + 'users/',
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter library',
        theme: appTheme,
        onGenerateRoute: compositionRoot.navigation.onGenerateRoute,
        navigatorKey: Navigation.navigatorKey,
        initialRoute: Routes.splash,
      ),
    );
  }
}
