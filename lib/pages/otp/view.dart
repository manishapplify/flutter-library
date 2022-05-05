import 'package:components/common/work_status.dart';
import 'package:components/pages/base_page.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/password_auth.dart';
import 'package:components/enums/screen.dart';
import 'package:components/common/app_exception.dart';
import 'package:components/pages/otp/bloc/bloc.dart';
import 'package:components/routes/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpPage extends BasePage {
  const OtpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OTPState();
}

class _OTPState extends BasePageState<OtpPage> {
  final int otpDigits = 4;
  final RegExp onlyDigitsPattern = RegExp(r'\d');
  late final List<FocusNode> focusNodes;
  late final List<TextEditingController> textEditingControllers;
  late final PasswordAuthCubit passwordAuthCubit;
  late final AuthCubit authCubit;
  late final OtpBloc otpBloc;

  @override
  void initState() {
    focusNodes = List<FocusNode>.generate(otpDigits, (_) => FocusNode());
    textEditingControllers = List<TextEditingController>.generate(
        otpDigits, (_) => TextEditingController());
    Future<void>.delayed(Duration.zero)
        .then((_) => focusNodes[0].requestFocus());
    passwordAuthCubit = BlocProvider.of(context);
    authCubit = BlocProvider.of(context);
    otpBloc = BlocProvider.of(context);

    super.initState();
  }

  @override
  void dispose() {
    for (final FocusNode fn in focusNodes) {
      fn.dispose();
    }
    for (final TextEditingController tc in textEditingControllers) {
      tc.dispose();
    }

    super.dispose();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(title: const Text('Verify OTP'));
  }

  String get otp {
    String otp = '';
    for (final TextEditingController tc in textEditingControllers) {
      otp += tc.text;
    }
    return otp;
  }

  void onFormSubmitted() async {
    FocusScope.of(context).unfocus();
    otpBloc.add(
      OtpSubmitted(),
    );
  }

  void valueChangeHandler(int i, String value) {
    // Digit was removed, move back.
    if (value.isEmpty && i > 0) {
      focusNodes[i - 1].requestFocus();
    }
    // Digit was added, move forward.
    else if (value.isNotEmpty && value.length == 1 && i < otpDigits - 1) {
      focusNodes[i + 1].requestFocus();
    }
    // Multiple digits entered, accept the last one.
    else if (value.length > 1) {
      textEditingControllers[i].value = TextEditingValue(
        text: value.substring(value.length - 1),
        selection: const TextSelection.collapsed(offset: 1),
      );
      // Move forward, if possible.
      if (i < otpDigits - 1) {
        focusNodes[i + 1].requestFocus();
      }
    }

    otpBloc.add(OtpChanged(otp));
  }

  @override
  Widget body(BuildContext context) {
    final Screen screen = routeSettings.arguments as Screen;

    if (screen == Screen.forgotPassword &&
        !passwordAuthCubit.state.isTokenGenerated) {
      Future<void>.microtask(
        () => navigator.pop(),
      );
    } else if (screen == Screen.verifyEmail) {
      if (!authCubit.state.isAuthorized) {
        throw AppException.authenticationException();
      }
      if (authCubit.state.user!.isEmailVerified == 1) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text('Verified'),
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            ],
          ),
        );
      }
    }

    return WillPopScope(
      onWillPop: () {
        if (screen == Screen.forgotPassword) {
          passwordAuthCubit.resetToken();
        }
        return Future<bool>.value(true);
      },
      child: Form(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 5,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Enter OTP sent to',
                      style: textTheme.headline2,
                    ),
                    Text(
                      screen == Screen.forgotPassword
                          ? passwordAuthCubit
                                  .state.forgotPasswordToken?.email ??
                              ''
                          : authCubit.state.user!.email ?? '',
                      style: textTheme.headline1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    for (int i = 0; i < otpDigits; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: textEditingControllers[i],
                            focusNode: focusNodes[i],
                            autofocus: true,
                            textAlignVertical: TextAlignVertical.top,
                            keyboardType: TextInputType.number,
                            onChanged: (String value) =>
                                valueChangeHandler(i, value),
                            onFieldSubmitted: (_) =>
                                i == otpDigits - 1 ? onFormSubmitted : null,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                onlyDigitsPattern,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocBuilder<OtpBloc, OtpState>(
                  builder: (_, OtpState state) {
                    if (state.formStatus is Success) {
                      otpBloc.add(ResetFormStatus());
                      if (screen == Screen.forgotPassword) {
                        Future<void>.microtask(
                          () => navigator.popAndPushNamed(Routes.resetPassword),
                        );
                      } else if (screen == Screen.verifyEmail) {
                        Future<void>.microtask(
                          () => navigator.popAndPushNamed(
                            Routes.profile,
                            arguments: Screen.registerUser,
                          ),
                        );
                      }
                    } else if (state.formStatus is Failure) {
                      otpBloc.add(ResetFormStatus());
                      final Failure failure = state.formStatus as Failure;
                      Future<void>.microtask(
                        () => showSnackBar(
                          SnackBar(
                            content: Text(failure.message ?? 'Failure'),
                          ),
                        ),
                      );
                    }

                    return state.formStatus is InProgress
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: onFormSubmitted,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Text(
                                'Submit',
                                style: textTheme.headline2,
                              ),
                            ),
                          );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
