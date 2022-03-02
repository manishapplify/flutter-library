import 'package:components/base/base_screen.dart';
import 'package:flutter/material.dart';

class FeedbackScreenThird extends BaseScreen {
  const FeedbackScreenThird({Key? key}) : super(key: key);

  @override
  State<FeedbackScreenThird> createState() => _FeedbackScreenThirdState();
}

class _FeedbackScreenThirdState extends BaseScreenState<FeedbackScreenThird> {
  late final FocusNode emailFocusNode;
  late final FocusNode describeFocusNode;
  String? value;

  List<String> topics = <String>[
    "Suggestions",
    "Login Trouble",
    "Phone Number Related",
    "Personal Profile",
    "Other Issues"
  ];

  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );

  @override
  void initState() {
    emailFocusNode = FocusNode();
    describeFocusNode = FocusNode();
    super.initState();
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
                const Text("We'd Love To Know Your Experience"),
                const SizedBox(height: 10.0),
                const Text("Email(optional)"),
                const SizedBox(height: 10.0),
                TextFormField(
                  focusNode: emailFocusNode,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (String s) =>
                      describeFocusNode.requestFocus(),
                ),
                const SizedBox(height: 10.0),
                const Text("What was the reason for your visit?"),
                const SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        value: value,
                        hint: const Text("Please give your reason"),
                        icon: const Icon(Icons.arrow_drop_down),
                        isExpanded: true,
                        items: topics.map(buildMenuItem).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            this.value = value;
                          });
                        }),
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text("Describe your experience"),
                const SizedBox(height: 10.0),
                TextFormField(
                  focusNode: describeFocusNode,
                  maxLines: 10,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: 'Tell us your experience...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              'Share Experience',
              style: textTheme.headline2,
            ),
          ),
        )
      ],
    );
  }
}
