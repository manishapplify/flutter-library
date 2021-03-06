import 'package:components/common/work_status.dart';
import 'package:components/pages/base_page.dart';
import 'package:components/blocs/blocs.dart';
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
  late final FocusNode confirmNewPasswordFocusNode;
  late final TextEditingController currentPasswordTextController;
  late final TextEditingController newPasswordTextController;
  late final TextEditingController confirmNewPasswordTextController;

  @override
  void initState() {
    changePasswordBloc = BlocProvider.of(context);
    currentPasswordFocusNode = FocusNode();
    newPasswordFocusNode = FocusNode();
    confirmNewPasswordFocusNode = FocusNode();
    currentPasswordTextController = TextEditingController();
    newPasswordTextController = TextEditingController();
    confirmNewPasswordTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    currentPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmNewPasswordFocusNode.dispose();
    currentPasswordTextController.dispose();
    newPasswordTextController.dispose();
    confirmNewPasswordTextController.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        title: const Text('Change Password'),
      );

  @override
  Widget body(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          child: Form(
        key: _formkey,
        child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
            builder: (BuildContext context, ChangePasswordState state) {
          if (state.blocStatus is Success) {
            changePasswordBloc.add(ResetFormState());
            currentPasswordTextController.value = TextEditingValue.empty;
            newPasswordTextController.value = TextEditingValue.empty;
            confirmNewPasswordTextController.value = TextEditingValue.empty;
            Future<void>.microtask(
              () => showSnackBar(
                const SnackBar(
                  content: Text('Successfully updated password'),
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
            changePasswordBloc.add(ResetChangePasswordBlocStatus());
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: currentPasswordTextController,
                focusNode: currentPasswordFocusNode,
                obscureText: true,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  hintText: 'Enter current password',
                  prefixIcon: Icon(
                    Icons.lock,
                  ),
                ),
                validator: (_) => state.currentPasswordValidator,
                onChanged: (String value) => changePasswordBloc
                    .add(CurrentPasswordChanged(currentPassword: value)),
                onFieldSubmitted: (_) => newPasswordFocusNode.requestFocus(),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: newPasswordTextController,
                focusNode: newPasswordFocusNode,
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
                onChanged: (String value) => changePasswordBloc.add(
                  NewPasswordChanged(newPassword: value),
                ),
                onFieldSubmitted: (_) =>
                    confirmNewPasswordFocusNode.requestFocus(),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 16.0,
              ),
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
                onChanged: (String value) => changePasswordBloc.add(
                  ConfirmNewPasswordChanged(confirmNewPassword: value),
                ),
                onFieldSubmitted: (_) => onFormSubmitted(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              state.blocStatus is InProgress
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
      )),
    );
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
