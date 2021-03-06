import 'package:components/common/work_status.dart';
import 'package:components/pages/base_page.dart';
import 'package:components/cubits/password_auth.dart';
import 'package:components/enums/screen.dart';
import 'package:components/blocs/blocs.dart';
import 'package:components/routes/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends BasePage {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends BasePageState<ForgotPasswordPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late final FocusNode emailFocusNode;
  late final TextEditingController emailTextEditingController;
  late final ForgotPasswordBloc forgotPasswordBloc;
  late final PasswordAuthCubit passwordAuthCubit;

  @override
  void initState() {
    emailFocusNode = FocusNode();
    emailTextEditingController = TextEditingController();
    forgotPasswordBloc = BlocProvider.of(context);
    passwordAuthCubit = BlocProvider.of(context);

    // Token is already present, no need to regenerate.
    if (passwordAuthCubit.state.isTokenGenerated) {
      Future<void>.microtask(
        () => navigator.pushNamed(
          Routes.otp,
          arguments: Screen.forgotPassword,
        ),
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(title: const Text("Forgot Password"));
  }

  @override
  Widget body(BuildContext context) {
    return Form(
      key: _formkey,
      child: Center(
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                builder: (BuildContext context, ForgotPasswordState state) {
                  if (state.blocStatus is Success) {
                    forgotPasswordBloc.add(ResetForgotPasswordFormStatus());
                    Future<void>.microtask(
                      () => navigator.pushNamed(
                        Routes.otp,
                        arguments: Screen.forgotPassword,
                      ),
                    );
                  } else if (state.blocStatus is Failure) {
                    forgotPasswordBloc.add(ResetForgotPasswordFormStatus());
                    final Failure failure = state.blocStatus as Failure;
                    Future<void>.microtask(
                      () => showSnackBar(
                        SnackBar(
                          content: Text(failure.message ?? 'Failure'),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: emailTextEditingController,
                        focusNode: emailFocusNode,
                        autofocus: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (_) => state.emailValidator,
                        onChanged: (String value) => forgotPasswordBloc.add(
                          EmailChanged(value),
                        ),
                        onFieldSubmitted: (_) => onFormSubmitted(),
                      ),
                      const SizedBox(height: 15),
                      state.blocStatus is InProgress
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
                            ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onFormSubmitted() {
    if (_formkey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      forgotPasswordBloc.add(
        ForgotPasswordSubmitted(),
      );
    }
  }
}
