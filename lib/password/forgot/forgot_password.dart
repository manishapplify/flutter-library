import 'package:components/base/base_screen.dart';
import 'package:components/routes/navigation.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends BaseScreen {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends BaseScreenState<ForgotPasswordScreen> {
  late final FocusNode emailFocusNode;
  late final TextEditingController emailTextEditingController;

  @override
  void initState() {
    emailFocusNode = FocusNode();
    emailTextEditingController = TextEditingController();
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
      child: Center(
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: emailTextEditingController,
                    focusNode: emailFocusNode,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onFormSubmitted() async {
    Future<void>.microtask(() => navigator.pushNamed(Routes.otp));
  }
}
