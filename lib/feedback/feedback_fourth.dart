import 'dart:io';

import 'package:components/base/base_screen.dart';
import 'package:components/dialogs/dialogs.dart';
import 'package:flutter/material.dart';

class FeedbackFourthScreen extends BaseScreen {
  const FeedbackFourthScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackFourthScreen> createState() => _FeedbackFourthScreenState();
}

class _FeedbackFourthScreenState extends BaseScreenState<FeedbackFourthScreen> {
  late final FocusNode emailFocusNode;
  late final FocusNode nameFocusNode;
  late final FocusNode describeFocusNode;
  final List<File> _imageList = <File>[];

  @override
  void initState() {
    emailFocusNode = FocusNode();
    nameFocusNode = FocusNode();
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
                const Text("Email"),
                const SizedBox(height: 10.0),
                TextFormField(
                  focusNode: emailFocusNode,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (String s) => nameFocusNode.requestFocus(),
                ),
                const SizedBox(height: 10.0),
                const Text("Name"),
                const SizedBox(height: 10.0),
                TextFormField(
                  focusNode: nameFocusNode,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                    labelText: 'Name',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (String s) =>
                      describeFocusNode.requestFocus(),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  "How can we improve?",
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  focusNode: describeFocusNode,
                  maxLines: 5,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: 'What would you like us to improve?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                OutlinedButton(
                  onPressed: () {
                    showImagePickerPopup(context, (File selectedImage) {
                      setState(() {
                        if (selectedImage.path.isNotEmpty) {
                          setState(() {
                            _imageList.add(selectedImage);
                          });
                        }
                      });
                    });
                  },
                  child: const Text(
                    "Include Screenshot",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 200.0,
                  child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, mainAxisSpacing: 8.0),
                      itemCount: _imageList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Image.file(File(_imageList[i].path));
                      }),
                )
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
              'Submit Feedback',
              style: textTheme.headline2,
            ),
          ),
        )
      ],
    );
  }
}
