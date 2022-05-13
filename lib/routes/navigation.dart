import 'package:components/Authentication/repo.dart';
import 'package:components/blocs/blocs.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/enums/screen.dart';
import 'package:components/pages/change_password/view.dart';
import 'package:components/pages/chat/chat.dart';
import 'package:components/pages/chat/chats.dart';
import 'package:components/pages/chat/widgets/pdf_viewer.dart';
import 'package:components/pages/comments/comment_ui.dart';
import 'package:components/pages/feedback/view.dart';
import 'package:components/pages/forgot_password/view.dart';
import 'package:components/pages/home/view.dart';
import 'package:components/pages/login/view.dart';
import 'package:components/pages/notifications/view.dart';
import 'package:components/pages/otp/view.dart';
import 'package:components/pages/profile/repo.dart';
import 'package:components/pages/profile/view.dart';
import 'package:components/pages/report_bug/view.dart';
import 'package:components/pages/report_feedback/feedback_one.dart';
import 'package:components/pages/report_feedback/feedback_one/bloc/bloc.dart';
import 'package:components/pages/report_feedback/feedback_third.dart';
import 'package:components/pages/report_feedback/list.dart';
import 'package:components/pages/reset_password/view.dart';
import 'package:components/pages/settings/cubit/cubit.dart';
import 'package:components/pages/settings/view.dart';
import 'package:components/pages/signup/view.dart';
import 'package:components/pages/splash/view.dart';
import 'package:components/pages/users/view.dart';
import 'package:components/services/api/api.dart';
import 'package:components/services/persistence.dart';
import 'package:components/services/s3_image_upload/s3_image_upload.dart';
import 'package:components/common/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Navigation {
  Navigation({
    required Api api,
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
    required AuthCubit authCubit,
    required Config config,
    required Persistence persistence,
    required S3ImageUpload s3imageUpload,
  })  : _api = api,
        _authRepository = authRepository,
        _profileRepository = profileRepository,
        _authCubit = authCubit,
        _config = config,
        _persistence = persistence,
        _s3imageUpload = s3imageUpload {
    _authCubit.stream.listen(
      (AuthState event) {
        if (!event.isAuthorized) {
          Navigator.popUntil(
            navigatorKey.currentContext!,
            (_) => false,
          );
          Navigator.pushNamed(
            navigatorKey.currentContext!,
            Routes.login,
          );
        }
      },
    );
  }

  final Api _api;
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;
  final AuthCubit _authCubit;
  final Config _config;
  final Persistence _persistence;
  final S3ImageUpload _s3imageUpload;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute<SplashPage>(
          settings: settings,
          builder: (_) => BlocProvider<SplashBloc>(
            create: (_) => SplashBloc(
              api: _api,
              config: _config,
            ),
            child: const SplashPage(),
          ),
        );
      case Routes.login:
        return MaterialPageRoute<LoginPage>(
          settings: settings,
          builder: (_) => BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(
              api: _api,
              authRepository: _authRepository,
            ),
            child: const LoginPage(),
          ),
        );
      case Routes.signup:
        return MaterialPageRoute<SignupPage>(
          settings: settings,
          builder: (_) => BlocProvider<SignUpBloc>(
            create: (_) => SignUpBloc(
              authRepository: _authRepository,
              authCubit: _authCubit,
            ),
            child: const SignupPage(),
          ),
        );
      case Routes.forgotPassword:
        return MaterialPageRoute<ForgotPasswordPage>(
          settings: settings,
          builder: (_) => BlocProvider<ForgotPasswordBloc>(
            create: (_) => ForgotPasswordBloc(
              authRepository: _authRepository,
              persistence: _persistence,
            ),
            child: const ForgotPasswordPage(),
          ),
        );
      case Routes.otp:
        return MaterialPageRoute<OtpPage>(
          settings: settings,
          builder: (_) => BlocProvider<OtpBloc>(
            create: (_) => OtpBloc(
              screenType: settings.arguments as Screen,
              authRepository: _authRepository,
              api: _api,
              authCubit: _authCubit,
            ),
            child: const OtpPage(),
          ),
        );
      case Routes.resetPassword:
        return MaterialPageRoute<ResetPasswordPage>(
          settings: settings,
          builder: (_) => BlocProvider<ResetPasswordBloc>(
            create: (_) => ResetPasswordBloc(
              authRepository: _authRepository,
            ),
            child: const ResetPasswordPage(),
          ),
        );
      case Routes.profile:
        return MaterialPageRoute<ProfilePage>(
          settings: settings,
          builder: (_) => BlocProvider<ProfileBloc>(
            create: (_) => ProfileBloc(
              screenType: settings.arguments as Screen,
              profileRepository: _profileRepository,
              imageBaseUrl: _s3imageUpload.s3BaseUrl + 'users/',
            ),
            child: const ProfilePage(),
          ),
        );
      case Routes.home:
        return MaterialPageRoute<ResetPasswordPage>(
          settings: settings,
          builder: (_) => BlocProvider<HomeBloc>(
            create: (_) => HomeBloc(
              s3imageUpload: _s3imageUpload,
              authCubit: _authCubit,imageBaseUrl: _s3imageUpload.s3BaseUrl + 'users/',
              persistence: _persistence,
            ),
            child: const HomePage(),
          ),
        );
      case Routes.settings:
        return MaterialPageRoute<SettingsPage>(
          settings: settings,
          builder: (_) => BlocProvider<SettingsCubit>(
            create: (_) => SettingsCubit(
              authRepository: _authRepository,
            ),
            child: const SettingsPage(),
          ),
        );
      case Routes.changePassword:
        return MaterialPageRoute<ChangePasswordPage>(
          settings: settings,
          builder: (_) => BlocProvider<ChangePasswordBloc>(
            create: (_) => ChangePasswordBloc(
              api: _api,
              authRepository: _authRepository,
            ),
            child: const ChangePasswordPage(),
          ),
        );
      case Routes.feedback:
        return MaterialPageRoute<FeedbackPage>(
          settings: settings,
          builder: (_) => BlocProvider<FeedbackBloc>(
            create: (_) => FeedbackBloc(
              api: _api,
            ),
            child: const FeedbackPage(),
          ),
        );
      case Routes.reportBug:
        return MaterialPageRoute<ReportBugPage>(
          settings: settings,
          builder: (_) => BlocProvider<ReportBugBloc>(
            create: (_) => ReportBugBloc(
              api: _api,
              authCubit: _authCubit,
              s3imageUpload: _s3imageUpload,
            ),
            child: const ReportBugPage(),
          ),
        );
      case Routes.users:
        return MaterialPageRoute<UsersPage>(
          settings: settings,
          builder: (_) => const UsersPage(),
        );
      case Routes.chats:
        return MaterialPageRoute<ChatsPage>(
          settings: settings,
          builder: (_) => const ChatsPage(),
        );
      case Routes.chat:
        return MaterialPageRoute<ChatPage>(
          settings: settings,
          builder: (_) => const ChatPage(),
        );
      case Routes.comments:
        return MaterialPageRoute<CommentScreen>(
          builder: (_) => const CommentScreen(),
        );

      case Routes.feedbackScreens:
        return MaterialPageRoute<FeedbackScreenTypes>(
          settings: settings,
          builder: (_) => const FeedbackScreenTypes(),
        );
      case Routes.feedbackOne:
        return MaterialPageRoute<FeedbackScreenOne>(
          settings: settings,
          builder: (_) => BlocProvider<FeedbackOneBloc>(
            create: (BuildContext context) => FeedbackOneBloc(
              api: _api,
              authRepository: _authRepository,
              authCubit: _authCubit,
            ),
            child: const FeedbackScreenOne(),
          ),
        );
      case Routes.feedbackThird:
        return MaterialPageRoute<FeedbackScreenThird>(
          settings: settings,
          builder: (_) => const FeedbackScreenThird(),
        );
      case Routes.pdfViewerPage:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) => const PdfViewerPage(),
        );
      case Routes.notifications:
        return MaterialPageRoute<NotificationPage>(
          settings: settings,
          builder: (_) => const NotificationPage(),
        );
    }

    return MaterialPageRoute<LoginPage>(
      settings: settings,
      builder: (_) => BlocProvider<LoginBloc>(
        create: (BuildContext context) => LoginBloc(
          api: _api,
          authRepository: _authRepository,
        ),
        child: const LoginPage(),
      ),
    );
  }

  static void navigateAfterSplashOrLogin(User? user) {
    final NavigatorState navigator = Navigator.of(navigatorKey.currentContext!);

    Future<void>.microtask(
      () => navigator.popUntil(
        (_) => false,
      ),
    );

    if (user == null) {
      Future<void>.microtask(
        () => navigator.pushNamed(
          Routes.login,
        ),
      );
    } else {
      if (user.isEmailVerified == 0) {
        Future<void>.microtask(
          () => navigator.pushNamed(
            Routes.otp,
            arguments: Screen.verifyEmail,
          ),
        );
      } else if (user.registrationStep == 1) {
        Future<void>.microtask(
          () => navigator.pushNamed(
            Routes.profile,
            arguments: Screen.registerUser,
          ),
        );
      } else {
        Future<void>.microtask(
          () => navigator.pushNamed(
            Routes.home,
          ),
        );
      }
    }
  }
}

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgotPassword';
  static const String otp = '/otp';
  static const String resetPassword = '/resetPassword';
  static const String profile = '/profile';
  static const String home = '/home';
  static const String feedback = '/feedback';
  static const String reportBug = '/reportBug';
  static const String settings = '/settings';
  static const String changePassword = '/changePassword';
  static const String users = '/users';
  static const String chats = '/chats';
  static const String chat = '/chat';
  static const String comments = '/comments';
  static const String multiImageSelectionBottomSheet =
      '/multiImageSelectionBottomSheet';

  static const String loginOne = "/loginScreenOne";
  static const String feedbackScreens = "/feedbackScreens";
  static const String feedbackOne = "/feedbackOneScreen";
  static const String feedbackThird = "/feedbackThirdScreen";
  static const String pdfViewerPage = "/pdfViewerPage";
  static const String notifications = '/notifications';
}
