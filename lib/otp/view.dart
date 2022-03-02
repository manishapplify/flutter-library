import 'package:components/base/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpScreen extends BaseScreen {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OTPState();
}

class _OTPState extends BaseScreenState<OtpScreen> {
  final int otpDigits = 4;
  final RegExp onlyDigitsPattern = RegExp(r'\d');
  late final List<FocusNode> focusNodes;
  late final List<TextEditingController> textEditingControllers;

  @override
  void initState() {
    focusNodes = List<FocusNode>.generate(otpDigits, (_) => FocusNode());
    textEditingControllers = List<TextEditingController>.generate(
        otpDigits, (_) => TextEditingController());
    Future<void>.delayed(Duration.zero)
        .then((_) => focusNodes[0].requestFocus());
    super.initState();
  }

  @override
  void dispose() {
    for (final FocusNode fn in focusNodes) {
      fn.dispose();
    }
    for (final TextEditingController tc in textEditingControllers) {
      tc.dispose();
    }

    super.dispose();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) => AppBar(
        title: const Text('OTP'),
      );

  String get otp {
    String otp = '';
    for (final TextEditingController tc in textEditingControllers) {
      otp += tc.text;
    }
    return otp;
  }

  void onFormSubmitted() async {
    // if (await otpViewModel.validateOTP(otp: otp)) {
    // } else {
    //   showSnackBar(
    //     const SnackBar(
    //       content: Text('Invalid OTP'),
    //     ),
    //   );
    // }
  }

  void valueChangeHandler(int i, String value) {
    // Digit was removed, move back.
    if (value.isEmpty && i > 0) {
      focusNodes[i - 1].requestFocus();
    }
    // Digit was added, move forward.
    else if (value.isNotEmpty && value.length == 1 && i < otpDigits - 1) {
      focusNodes[i + 1].requestFocus();
    }
    // Multiple digits entered, accept the last one.
    else if (value.length > 1) {
      textEditingControllers[i].value = TextEditingValue(
        text: value.substring(value.length - 1),
        selection: const TextSelection.collapsed(offset: 1),
      );
      // Move forward, if possible.
      if (i < otpDigits - 1) {
        focusNodes[i + 1].requestFocus();
      }
    }
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
              Column(
                children: <Widget>[
                  Text(
                    'Enter OTP sent to',
                    style: textTheme.headline2,
                  ),
                  Text(
                    "",
                    style: textTheme.headline1!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  for (int i = 0; i < otpDigits; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: textEditingControllers[i],
                          focusNode: focusNodes[i],
                          autofocus: true,
                          textAlignVertical: TextAlignVertical.top,
                          keyboardType: TextInputType.number,
                          onChanged: (String value) =>
                              valueChangeHandler(i, value),
                          onFieldSubmitted: (_) =>
                              i == otpDigits - 1 ? onFormSubmitted() : null,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              onlyDigitsPattern,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 30,
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
