import 'package:components/Authentication/form_submission.dart';
import 'package:components/base/base_page.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/exceptions/app_exception.dart';
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
  late final FocusNode emailFocusNode;
  late final FocusNode passwordFocusNode;
  late final AuthCubit authCubit;

  @override
  void initState() {
    loginBloc = BlocProvider.of(context);
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    authCubit = BlocProvider.of(context);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
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
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (BuildContext context, LoginState state) {
            if (state.formStatus is SubmissionSuccess) {
              loginBloc.add(ResetFormStatus());
              if (!authCubit.state.isAuthorized) {
                throw AppException.authenticationException;
              }

              Navigation.navigateAfterSplashOrLogin(authCubit.state.user);
            } else if (state.formStatus is SubmissionFailed) {
              loginBloc.add(ResetFormStatus());
              final SubmissionFailed failure =
                  state.formStatus as SubmissionFailed;
              Future<void>.microtask(
                () => showSnackBar(
                  SnackBar(
                    content: Text(failure.message ?? 'Login Failed'),
                  ),
                ),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10.0),
                TextFormField(
                  focusNode: emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    errorStyle: TextStyle(height: 0.5),
                    prefixIcon: Icon(
                      Icons.email,
                    ),
                  ),
                  validator: (_) => state.emailValidator,
                  onChanged: (String value) => loginBloc.add(
                    LoginEmailChanged(email: value),
                  ),
                  onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  focusNode: passwordFocusNode,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                  ),
                  onChanged: (String value) => loginBloc.add(
                    LoginPasswordChanged(password: value),
                  ),
                  onFieldSubmitted: (_) => onFormSubmitted(),
                ),
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
                const SizedBox(height: 20.0),
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
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 0.0,
                      width: 126,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                    ),
                    const Text("     or     "),
                    Container(
                      height: 0.0,
                      width: 126,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                InkWell(
                  onTap: () => loginBloc.add(
                    GoogleSignInSummitted(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Material(
                      elevation: 3.0,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 40.0,
                            height: 35.0,
                            child: const Image(
                              image: AssetImage(
                                "assets/images/googlelogo.png",
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 50.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3.0)),
                            child: const Text('Sign in with Google',
                                style: TextStyle(color: Colors.black54)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => loginBloc.add(
                    FacebookSignInSummitted(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Material(
                      elevation: 3.0,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 40.0,
                            height: 35.0,
                            child: const Image(
                              image: AssetImage(
                                "assets/images/fblogo.png",
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 50.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3.0)),
                            child: const Text('Sign in with Facebook',
                                style: TextStyle(color: Colors.black54)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
