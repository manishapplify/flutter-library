import 'package:components/base/base_screen.dart';
import 'package:components/widgets/checkbox.dart';
import 'package:flutter/material.dart';

class FeedbackScreenOne extends BaseScreen {
  const FeedbackScreenOne({Key? key}) : super(key: key);

  @override
  State<FeedbackScreenOne> createState() => _FeedbackScreenOneState();
}

class _FeedbackScreenOneState extends BaseScreenState<FeedbackScreenOne> {
  late final FocusNode emailFocusNode;
  late final FocusNode describeFocusNode;
  List<bool> isTypeSelected = <bool>[false, false, false, false, false];

  @override
  void initState() {
    emailFocusNode = FocusNode();
    describeFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    describeFocusNode.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      title: const Text("Feedback"),
    );
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Please select the type of the feedback",
              ),
              const SizedBox(height: 20.0),
              InkWell(
                child: CheckBoxWidget(
                    title: "Suggestions", isChecked: !isTypeSelected[4]),
                onTap: () {
                  setState(() {
                    isTypeSelected[4] = !isTypeSelected[4];
                  });
                },
              ),
              InkWell(
                child: CheckBoxWidget(
                    title: "Login trouble", isChecked: isTypeSelected[0]),
                onTap: () {
                  setState(() {
                    isTypeSelected[0] = !isTypeSelected[0];
                  });
                },
              ),
              InkWell(
                child: CheckBoxWidget(
                    title: "Phone number related",
                    isChecked: isTypeSelected[1]),
                onTap: () {
                  setState(() {
                    isTypeSelected[1] = !isTypeSelected[1];
                  });
                },
              ),
              InkWell(
                child: CheckBoxWidget(
                    title: "Personal profile", isChecked: isTypeSelected[2]),
                onTap: () {
                  setState(() {
                    isTypeSelected[2] = !isTypeSelected[2];
                  });
                },
              ),
              InkWell(
                child: CheckBoxWidget(
                    title: "Other issues", isChecked: isTypeSelected[3]),
                onTap: () {
                  setState(() {
                    isTypeSelected[3] = !isTypeSelected[3];
                  });
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                focusNode: describeFocusNode,
                maxLines: 10,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Please briefly describe the issue',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                focusNode: emailFocusNode,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              // buildNumberField(),
            ],
          )),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              'Send Feedback',
              style: textTheme.headline2,
            ),
          ),
        ),
      ],
    );
  }
}
