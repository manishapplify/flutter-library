import 'package:components/feedback/feedback_fourth.dart';
import 'package:components/feedback/feedback_one.dart';
import 'package:components/feedback/feedback_second.dart';
import 'package:components/feedback/feedback_third.dart';
import 'package:components/feedback/list.dart';
import 'package:components/login/login_one.dart';
import 'package:components/otp/view.dart';
import 'package:components/pages/signup/view.dart';
import 'package:components/pages/splash/bloc/bloc.dart';
import 'package:components/pages/splash/view.dart';
import 'package:components/password/forgot/forgot_password.dart';
import 'package:components/screens/screens.dart';
import 'package:components/services/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Navigation {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final Api _api = Api(
    baseOptions: BaseOptions(
      baseUrl: 'https://api-lib.applifyapps.com',
    ),
  );

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute<SplashPage>(
          settings: settings,
          builder: (_) => BlocProvider<SplashBloc>(
            create: (BuildContext context) => SplashBloc(
              api: _api,
            ),
            child: const SplashPage(),
          ),
        );
      case Routes.login:
        return MaterialPageRoute<LoginScreenTypes>(
          settings: settings,
          builder: (_) => const LoginScreenTypes(),
        );
      case Routes.loginOne:
        return MaterialPageRoute<LoginScreen>(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case Routes.signupOne:
        return MaterialPageRoute<SignupPage>(
          settings: settings,
          builder: (_) => const SignupPage(),
        );
      case Routes.forgotPasswordOne:
        return MaterialPageRoute<ForgotPasswordScreen>(
          settings: settings,
          builder: (_) => const ForgotPasswordScreen(),
        );
      case Routes.otp:
        return MaterialPageRoute<OtpScreen>(
          settings: settings,
          builder: (_) => const OtpScreen(),
        );

      case Routes.feedbackScreens:
        return MaterialPageRoute<FeedbackScreenTypes>(
          settings: settings,
          builder: (_) => const FeedbackScreenTypes(),
        );
      case Routes.feedbackOne:
        return MaterialPageRoute<FeedbackScreenOne>(
          settings: settings,
          builder: (_) => const FeedbackScreenOne(),
        );
      case Routes.feedbackSecond:
        return MaterialPageRoute<FeedbackScreenSecond>(
          settings: settings,
          builder: (_) => const FeedbackScreenSecond(),
        );
      case Routes.feedbackThird:
        return MaterialPageRoute<FeedbackScreenThird>(
          settings: settings,
          builder: (_) => const FeedbackScreenThird(),
        );
      case Routes.feedbackFourth:
        return MaterialPageRoute<FeedbackFourthScreen>(
          settings: settings,
          builder: (_) => const FeedbackFourthScreen(),
        );
    }

    return MaterialPageRoute<LoginScreenTypes>(
      settings: settings,
      builder: (_) => const LoginScreenTypes(),
    );
  }
}

class Routes {
  static const String splash = "splash";

  static const String login = "loginType";
  static const String loginOne = "loginScreenOne";
  static const String signupOne = "signupScreenOne";
  static const String forgotPasswordOne = "forgotPasswordScreenOne";
  static const String otp = "otpScreen";

  static const String feedbackScreens = "feedbackScreens";
  static const String feedbackOne = "feedbackOneScreen";
  static const String feedbackSecond = "feedbackSecondScreen";
  static const String feedbackThird = "feedbackThirdScreen";
  static const String feedbackFourth = "feedbackFourthScreen";
}
