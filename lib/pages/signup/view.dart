import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:components/blocs/blocs.dart';
import 'package:components/common/work_status.dart';
import 'package:components/enums/screen.dart';
import 'package:components/pages/base_page.dart';
import 'package:components/routes/navigation.dart';

class SignupPage extends BasePage {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignupState();
}

class _SignupState extends BasePageState<SignupPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late final FocusNode emailFocusNode;
  late final FocusNode phoneFocusNode;
  late final List<FocusNode> passwordFocusNodes;
  late final SignUpBloc signUpBloc;

  @override
  void initState() {
    emailFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    passwordFocusNodes = List<FocusNode>.generate(2, (_) => FocusNode());
    signUpBloc = BlocProvider.of(context);
    signUpBloc.add(
      SignUpCountryCodeChanged(
        countryCode: '+91',
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    for (final FocusNode fc in passwordFocusNodes) {
      fc.dispose();
    }
    super.dispose();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) => AppBar(
        title: const Text('Signup'),
      );

  void onFormSubmitted() {
    if (_formkey.currentState!.validate() &&
        signUpBloc.state.isValidCountryCode) {
      signUpBloc.add(SignUpSubmitted());
    }
  }

  @override
  Widget body(BuildContext context) {
    return Form(
      key: _formkey,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                focusNode: emailFocusNode,
                textAlignVertical: TextAlignVertical.center,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail),
                ),
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (_) => phoneFocusNode.requestFocus(),
                textInputAction: TextInputAction.next,
                onChanged: (String value) => signUpBloc.add(
                  SignUpEmailChanged(email: value),
                ),
                validator: (_) => signUpBloc.state.emailValidator,
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CountryCodePicker(
                    initialSelection: 'IN',
                    flagDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    onChanged: (CountryCode countryCode) {
                      if (countryCode.dialCode is String) {
                        signUpBloc.add(
                          SignUpCountryCodeChanged(
                            countryCode: countryCode.dialCode!,
                          ),
                        );
                      }
                    },
                  ),
                  Expanded(
                    child: TextFormField(
                      focusNode: phoneFocusNode,
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        hintText: 'Enter your phone number',
                        labelText: 'Phone number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      onFieldSubmitted: (_) =>
                          passwordFocusNodes[0].requestFocus(),
                      textInputAction: TextInputAction.next,
                      onChanged: (String value) => signUpBloc.add(
                        SignUpPhoneNumberChanged(phoneNumber: value),
                      ),
                      validator: (_) => signUpBloc.state.isValidphoneNumber
                          ? null
                          : 'Enter a valid phone number',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              for (int i = 0; i < 2; i++)
                Column(
                  children: <Widget>[
                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      focusNode: passwordFocusNodes[i],
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                        ),
                        hintText: i == 0
                            ? 'Enter your password'
                            : 'Confirm your password',
                        labelText: i == 0 ? 'Password' : 'Confirm Password',
                      ),
                      obscureText: true,
                      onFieldSubmitted: (_) => i == 0
                          ? passwordFocusNodes[1].requestFocus()
                          : onFormSubmitted(),
                      textInputAction:
                          i == 0 ? TextInputAction.next : TextInputAction.done,
                      onChanged: (String value) => i == 0
                          ? signUpBloc.add(
                              SignUpPasswordChanged(password: value),
                            )
                          : signUpBloc.add(
                              SignUpConfirmPasswordChanged(
                                  confirmPassword: value),
                            ),
                      validator: (_) => i == 0
                          ? signUpBloc.state.passwordValidator
                          : signUpBloc.state.confirmNewPasswordValidator,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<SignUpBloc, SignUpState>(
                builder: (BuildContext context, SignUpState state) {
                  if (state.blocStatus is Success) {
                    Future<void>.microtask(
                      () => Navigator.popAndPushNamed(
                        context,
                        Routes.otp,
                        arguments: Screen.verifyEmail,
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

                  return state.blocStatus is InProgress
                      ? const Center(child: CircularProgressIndicator())
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
