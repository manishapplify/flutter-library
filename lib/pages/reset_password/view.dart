import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:components/blocs/blocs.dart';
import 'package:components/common/work_status.dart';
import 'package:components/cubits/password_auth.dart';
import 'package:components/pages/base_page.dart';

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
  late final TextEditingController confirmNewPasswordTextController;
  late final FocusNode confirmNewPasswordFocusNode;

  @override
  void initState() {
    passwordFocusNode = FocusNode();
    passwordTextEditingController = TextEditingController();
    passwordAuthCubit = BlocProvider.of(context);
    resetPasswordBloc = BlocProvider.of(context);
    confirmNewPasswordFocusNode = FocusNode();
    confirmNewPasswordTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    passwordTextEditingController.dispose();
    passwordFocusNode.dispose();
    confirmNewPasswordFocusNode.dispose();
    confirmNewPasswordTextController.dispose();
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
                  if (state.blocStatus is Success) {
                    passwordAuthCubit.resetToken();
                    resetPasswordBloc.add(ResetResetPasswordFormState());
                    passwordTextEditingController.value =
                        TextEditingValue.empty;
                    confirmNewPasswordTextController.value =
                        TextEditingValue.empty;
                    Future<void>.microtask(
                      () => showSnackBar(
                        const SnackBar(
                          content: Text('Password reset successful'),
                        ),
                      ),
                    );
                  } else if (state.blocStatus is Failure) {
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
                        controller: passwordTextEditingController,
                        focusNode: passwordFocusNode,
                        autofocus: true,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                          hintText: 'Enter new password',
                          prefixIcon: Icon(
                            Icons.lock,
                          ),
                        ),
                        validator: (_) => state.newPasswordValidator,
                        onChanged: (String value) => resetPasswordBloc.add(
                          ResetNewPasswordChanged(newPassword: value),
                        ),
                        onFieldSubmitted: (_) =>
                            confirmNewPasswordFocusNode.requestFocus(),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: confirmNewPasswordTextController,
                        focusNode: confirmNewPasswordFocusNode,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          labelText: 'Confirm New Password',
                          hintText: 'Enter new password again',
                          prefixIcon: Icon(
                            Icons.lock,
                          ),
                        ),
                        validator: (_) => state.confirmNewPasswordValidator,
                        onChanged: (String value) => resetPasswordBloc.add(
                          ResetConfirmNewPasswordChanged(
                              confirmNewPassword: value),
                        ),
                        onFieldSubmitted: (_) => onFormSubmitted(),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
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
      resetPasswordBloc.add(
        ResetPasswordSubmitted(),
      );
    }
  }
}
