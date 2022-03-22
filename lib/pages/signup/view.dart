import 'dart:io';
import 'package:components/routes/navigation.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:components/base/base_page.dart';
import 'package:components/dialogs/dialogs.dart';
import 'package:components/widgets/image_avtar.dart';
import 'package:flutter/material.dart';

class SignupPage extends BasePage {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignupState();
}

class _SignupState extends BasePageState<SignupPage> {
  late final FocusNode firstNameFocusNode;
  late final FocusNode lastNameFocusNode;
  late final FocusNode emailFocusNode;
  late final FocusNode phoneFocusNode;
  late final List<FocusNode> passwordFocusNodes;
  late final TextEditingController firstNameTextEditingController;
  late final TextEditingController lastNameTextEditingController;
  late final TextEditingController emailTextEditingController;

  late final TextEditingController phoneTextEditingController;
  late final List<TextEditingController> passwordTextEditingControllers;

  String image = "";
  @override
  void initState() {
    firstNameFocusNode = FocusNode();
    lastNameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    firstNameTextEditingController = TextEditingController();
    lastNameTextEditingController = TextEditingController();
    emailTextEditingController = TextEditingController();
    phoneTextEditingController = TextEditingController();
    passwordFocusNodes = List<FocusNode>.generate(2, (_) => FocusNode());
    passwordTextEditingControllers =
        List<TextEditingController>.generate(2, (_) => TextEditingController());
    super.initState();
  }

  @override
  void dispose() {
    phoneTextEditingController.dispose();
    phoneFocusNode.dispose();
    for (final TextEditingController tc in passwordTextEditingControllers) {
      tc.dispose();
    }
    for (final FocusNode fc in passwordFocusNodes) {
      fc.dispose();
    }
    super.dispose();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) => AppBar(
        title: const Text('Signup'),
      );

  void onFormSubmitted() async {
    Future<void>.microtask(() => navigator.pushNamed(Routes.otp));
  }

  @override
  Widget body(BuildContext context) {
    return Form(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 5,
              ),
              UserProfileImage(
                image: image,
                edit: () {
                  showImagePickerPopup(
                      context: context,
                      onImagePicked: (File file) {
                        setState(() {
                          image = file.path;
                        });

                        if (mounted) {
                          Navigator.pop(context);
                        }
                      });
                },
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: firstNameTextEditingController,
                focusNode: firstNameFocusNode,
                autofocus: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Enter your first name',
                  labelText: 'First name',
                ),
                keyboardType: TextInputType.text,
                onFieldSubmitted: (_) => lastNameFocusNode.requestFocus(),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: lastNameTextEditingController,
                focusNode: lastNameFocusNode,
                autofocus: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Enter your last name',
                  labelText: 'Last name',
                ),
                keyboardType: TextInputType.text,
                onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
              ),
              const SizedBox(height: 15),
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
                onFieldSubmitted: (_) => phoneFocusNode.requestFocus(),
              ),
              const SizedBox(height: 15),
              Row(
                children: <Widget>[
                  CountryCodePicker(
                    initialSelection: 'US',
                    flagDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: phoneTextEditingController,
                      focusNode: phoneFocusNode,
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        hintText: 'Enter your phone number',
                        labelText: 'Phone number',
                      ),
                      keyboardType: TextInputType.phone,
                      onFieldSubmitted: (_) =>
                          passwordFocusNodes[0].requestFocus(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              for (int i = 0; i < 2; i++)
                Column(
                  children: <Widget>[
                    TextFormField(
                      controller: passwordTextEditingControllers[i],
                      focusNode: passwordFocusNodes[i],
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: i == 0
                            ? 'Enter your password'
                            : 'Confirm your password',
                        labelText: i == 0 ? 'Password' : 'Confirm Password',
                      ),
                      obscureText: true,
                      onFieldSubmitted: (_) => i == 0
                          ? passwordFocusNodes[1].requestFocus()
                          : onFormSubmitted(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              const SizedBox(
                height: 10,
              ),
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
        ),
      ),
    );
  }
}
