import 'package:components/common/work_status.dart';
import 'package:components/pages/base_page.dart';
import 'package:components/pages/report_feedback/feedback_one/bloc/bloc.dart';
import 'package:components/widgets/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackScreenOne extends BasePage {
  const FeedbackScreenOne({Key? key}) : super(key: key);

  @override
  State<FeedbackScreenOne> createState() => _FeedbackScreenOneState();
}

class _FeedbackScreenOneState extends BasePageState<FeedbackScreenOne> {
  late final FocusNode emailFocusNode;
  late final FocusNode describeFocusNode;
  List<bool> isTypeSelected = <bool>[false, false, false, false, false];
  late final FeedbackOneBloc feedbackOneBloc;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List<String> reasons = <String>["Suggestions"];
  List<String> topics = <String>[
    "Suggestions",
    "Login Trouble",
    "Phone Number Related",
    "Personal Profile",
    "Other Issues"
  ];

  @override
  void initState() {
    emailFocusNode = FocusNode();
    describeFocusNode = FocusNode();
    feedbackOneBloc = BlocProvider.of(context);
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
    return BlocBuilder<FeedbackOneBloc, FeedbackOneState>(
        builder: (BuildContext context, FeedbackOneState state) {
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
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: topics.length,
                    itemBuilder: (_, int index) => InkWell(
                          child: CheckBoxWidget(
                              title: topics[index],
                              isChecked: state.reasons.contains(topics[index])
                                  ? true
                                  : false),
                          onTap: () {
                            feedbackOneBloc.add(FeedbackReasonChanged(
                                reason: selectOption(topics[index])));
                          },
                        )),
                /*InkWell(
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
                ),*/
                const SizedBox(
                  height: 20.0,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        focusNode: describeFocusNode,
                        maxLines: 10,
                        validator: (String? value) => state.isValidfeebackIssue
                            ? null
                            : "Minimum 10 characters required",
                        onChanged: (String? value) => context
                            .read<FeedbackOneBloc>()
                            .add(FeedbackIssueChanged(feebackIssue: value)),
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(height: 0.5),
                          hintText: 'Please briefly describe the issue',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        focusNode: emailFocusNode,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(height: 0.5),
                          hintText: 'Enter your email',
                          labelText: 'Email',
                        ),
                        onChanged: (String value) => context
                            .read<FeedbackOneBloc>()
                            .add(FeedbackEmailChanged(feedbackEmail: value)),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                ),

                // buildNumberField(),
              ],
            )),
          ),
          state.formStatus is InProgress
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate() &&
                        state.isreasonsempty) {
                      context.read<FeedbackOneBloc>().add(FeedbackSubmitted());
                    }
                  },
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
                )
        ],
      );
    });
  }

  List<String> selectOption(String optionName) {
    if (reasons.contains(optionName)) {
      reasons.remove(optionName);
    } else {
      reasons.add(optionName);
    }
    return reasons;
  }
}
