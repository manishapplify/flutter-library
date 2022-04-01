import 'package:components/Authentication/form_submission.dart';
import 'package:components/base/base_page.dart';
import 'package:components/pages/login/bloc/bloc.dart';
import 'package:components/routes/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends BasePage {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends BasePageState<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  late final LoginBloc loginBloc;
  late final FocusNode userNameFocusNode;
  late final FocusNode passwordFocusNode;

  @override
  void initState() {
    loginBloc = BlocProvider.of(context);
    userNameFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    userNameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) => AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      );

  @override
  Widget body(BuildContext context) {
    return Form(
      key: _formkey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (BuildContext context, LoginState state) {
            if (state.formStatus is SubmissionSuccess) {
              Future<void>.microtask(
                () => navigator.popAndPushNamed(Routes.home),
              );
            } else if (state.formStatus is SubmissionFailed) {
              final SubmissionFailed failure =
                  state.formStatus as SubmissionFailed;
              Future<void>.microtask(
                () => showSnackBar(
                  SnackBar(
                    content: Text(failure.message ?? 'Failure'),
                  ),
                ),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  focusNode: userNameFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: 'UserName',
                    prefixIcon: Icon(
                      Icons.email,
                    ),
                  ),
                  validator: (_) =>
                      state.isValidUsername ? null : "Username is too short",
                  onChanged: (String value) => loginBloc.add(
                    LoginUsernameChanged(username: value),
                  ),
                  onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  focusNode: passwordFocusNode,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                  ),
                  validator: (_) =>
                      state.isValidPassword ? null : "Password is too short",
                  onChanged: (String value) => loginBloc.add(
                    LoginPasswordChanged(password: value),
                  ),
                  onFieldSubmitted: (_) => onFormSubmitted(),
                ),
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      navigator.pushNamed(
                        Routes.forgotPassword,
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: textTheme.headline4,
                    ),
                  ),
                ),
                state.formStatus is FormSubmitting
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: onFormSubmitted,
                      ),
                const SizedBox(height: 50.0),
                TextButton(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: textTheme.headline2,
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    navigator.pushNamed(
                      Routes.signup,
                    );
                  },
                ),
                ElevatedButton(
                    onPressed: () => loginBloc.add(GoogleSignInPressed()),
                    child: const Text('google'))
              ],
            );
          },
        ),
      ),
    );
  }

  void onFormSubmitted() {
    if (_formkey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      loginBloc.add(
        LoginSubmitted(),
      );
    }
  }
}
