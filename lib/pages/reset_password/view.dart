import 'package:components/Authentication/form_submission.dart';
import 'package:components/base/base_page.dart';
import 'package:components/cubits/password_auth.dart';
import 'package:components/pages/reset_password/bloc/bloc.dart';
import 'package:components/routes/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordPage extends BasePage {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends BasePageState<ResetPasswordPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late final FocusNode passwordFocusNode;
  late final TextEditingController passwordTextEditingController;
  late final PasswordAuthCubit passwordAuthCubit;
  late final ResetPasswordBloc resetPasswordBloc;

  @override
  void initState() {
    passwordFocusNode = FocusNode();
    passwordTextEditingController = TextEditingController();
    passwordAuthCubit = BlocProvider.of(context);
    resetPasswordBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  void dispose() {
    passwordTextEditingController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(title: const Text("Reset Password"));
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
              BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                builder: (BuildContext context, ResetPasswordState state) {
                  if (state.formStatus is SubmissionSuccess) {
                    passwordAuthCubit.resetToken();
                    Future<void>.microtask(
                      () =>
                          navigator.popUntil(ModalRoute.withName(Routes.login)),
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
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: passwordTextEditingController,
                        focusNode: passwordFocusNode,
                        autofocus: true,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'New Password',
                          prefixIcon: Icon(
                            Icons.lock,
                          ),
                        ),
                        validator: (_) => state.isValidPassword
                            ? null
                            : "Password is too short",
                        onChanged: (String value) => resetPasswordBloc.add(
                          ResetPasswordChanged(password: value),
                        ),
                        onFieldSubmitted: (_) => onFormSubmitted(),
                      ),
                      const SizedBox(height: 15),
                      state.formStatus is FormSubmitting
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
      resetPasswordBloc.add(
        ResetPasswordSubmitted(),
      );
    }
  }
}
