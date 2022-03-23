import 'package:components/Authentication/form_submission.dart';
import 'package:components/base/base_page.dart';
import 'package:components/pages/change_password/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends BasePage {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends BasePageState<ChangePasswordPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  late final ChangePasswordBloc changePasswordBloc;
  late final FocusNode currentPasswordFocusNode;
  late final FocusNode newPasswordFocusNode;

  @override
  void initState() {
    changePasswordBloc = BlocProvider.of(context);
    currentPasswordFocusNode = FocusNode();
    newPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    currentPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        title: const Text('Change Password'),
      );

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
      key: _formkey,
      child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
          builder: (BuildContext context, ChangePasswordState state) {
        return Column(
          children: <Widget>[
            Text(
              "Your password must be at least 6 characters",
              style: textTheme.headline2,
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextFormField(
              focusNode: currentPasswordFocusNode,
              obscureText: true,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Current Password',
                prefixIcon: Icon(
                  Icons.lock,
                ),
              ),
              validator: (_) =>
                  state.isValidcurrentPassword ? null : "Password is too short",
              onChanged: (String value) => changePasswordBloc
                  .add(CurrentPasswordChanged(currentPassword: value)),
              onFieldSubmitted: (_) => newPasswordFocusNode.requestFocus(),
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextFormField(
              focusNode: newPasswordFocusNode,
              obscureText: true,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'New Password',
                prefixIcon: Icon(
                  Icons.lock,
                ),
              ),
              validator: (_) =>
                  state.isValidnewPassword ? null : "Password is too short",
              onChanged: (String value) => changePasswordBloc.add(
                NewPasswordChanged(newPassword: value),
              ),
              onFieldSubmitted: (_) => onFormSubmitted(),
            ),
            const SizedBox(
              height: 20.0,
            ),
            state.formStatus is FormSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      onFormSubmitted();
                    },
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
      }),
    ));
  }

  void onFormSubmitted() {
    if (_formkey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      changePasswordBloc.add(
        ChangePasswordSubmitted(),
      );
    }
  }
}
