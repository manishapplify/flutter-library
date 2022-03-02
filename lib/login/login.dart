// ignore_for_file: always_specify_types

import 'package:components/Authentication/form_submission.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/login/bloc.dart';
import 'package:components/login/event.dart';
import 'package:components/login/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
          authRepo: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>(),
        ),
        child: _loginForm(context),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Form(
      key: _formkey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Login',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40.0),
            BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
              return TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      hintText: 'UserName',
                      prefixIcon: Icon(
                        Icons.email,
                      )),
                  validator: (value) =>
                      state.isValidUsername ? null : "Username is too short",
                  onChanged: (value) => context
                      .read<LoginBloc>()
                      .add(LoginUsernameChanged(username: value)));
            }),
            BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
              return TextFormField(
                obscureText: true,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock,
                    )),
                validator: (value) =>
                    state.isValidPassword ? null : "Password is too short",
                onChanged: (value) => context
                    .read<LoginBloc>()
                    .add(LoginPasswordChanged(password: value)),
              );
            }),
            BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
              return state.formStatus is FormSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      child: const Text('LOGIN',
                          style: TextStyle(
                              color: Colors.black87,
                              // fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          context.read<LoginBloc>().add(LoginSubmitted());
                        }
                      },
                    );
            }),
            const SizedBox(height: 50.0),
            TextButton(
              child: const Text(
                "Don't have an account? Sign Up",
              ),
              onPressed: () => context.read<AuthCubit>().showSignUp(),
            )
          ],
        ),
      ),
    );
  }
}
