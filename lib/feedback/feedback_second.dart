import 'package:components/Authentication/form_submission.dart';
import 'package:components/base/base_screen.dart';
import 'package:components/feedback/feedback_second/bloc/bloc.dart';
import 'package:components/feedback/feedback_second/bloc/event.dart';
import 'package:components/feedback/feedback_second/bloc/state.dart';
import 'package:components/widgets/chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackScreenSecond extends BaseScreen {
  const FeedbackScreenSecond({Key? key}) : super(key: key);

  @override
  State<FeedbackScreenSecond> createState() => _FeedbackScreenSecondState();
}

class _FeedbackScreenSecondState extends BaseScreenState<FeedbackScreenSecond> {
  late final FeedbackSecondBloc feedbackSecondBloc;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List<bool> isTypeSelected = <bool>[false, false, false, false, false];
  List<String> topics = <String>[
    "Suggestions",
    "Login Trouble",
    "Phone Number Related",
    "Personal Profile",
    "Other Issues"
  ];

  @override
  void initState() {
    feedbackSecondBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(title: const Text("Feedback"));
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: BlocBuilder<FeedbackSecondBloc, FeedbackSecondState>(
                builder: (BuildContext context, FeedbackSecondState state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Rate Your Experience"),
                  const SizedBox(height: 10.0),
                  const Text("Are you Satisfied with the service?"),
                  const SizedBox(height: 16.0),
                  Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    child: RatingBar.builder(
                      initialRating: 5,
                      minRating: 1,
                      unratedColor: Colors.grey.shade400,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (BuildContext context, int i) => Container(
                        height: 60,
                        width: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(6.0),
                        margin: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          (i + 1).toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffe7c763),
                          border: Border.all(color: const Color(0xffe7c763)),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      onRatingUpdate: (double rating) {
                        print(rating);
                        feedbackSecondBloc
                            .add(FeedbackRatingChanged(feedbackRating: rating));
                      },
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const Text("Tell us what can be improved?"),
                  const SizedBox(height: 12.0),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 16.0,
                    children: topics.map(
                      (String tag) {
                        return InkWell(
                          onTap: () {
                            feedbackSecondBloc
                                .add(FeedbackReasonChanged(reason: tag));
                          },
                          child: ChipWidget(
                              title: tag,
                              isChecked:
                                  state.feedbackReason == tag ? true : false),
                        );
                      },
                    ).toList(),

                    /*<Widget>[
                      InkWell(
                        child: ChipWidget(
                            title: "Suggestions", isChecked: isTypeSelected[4]),
                        onTap: () {
                          setState(() {
                            isTypeSelected[4] = !isTypeSelected[4];
                          });
                        },
                      ),
                      InkWell(
                        child: ChipWidget(
                            title: "Login trouble", isChecked: isTypeSelected[0]),
                        onTap: () {
                          setState(() {
                            isTypeSelected[0] = !isTypeSelected[0];
                          });
                        },
                      ),
                      InkWell(
                        child: ChipWidget(
                            title: "Phone number related",
                            isChecked: isTypeSelected[1]),
                        onTap: () {
                          setState(() {
                            isTypeSelected[1] = !isTypeSelected[1];
                          });
                        },
                      ),
                      InkWell(
                        child: ChipWidget(
                            title: "Personal profile",
                            isChecked: isTypeSelected[2]),
                        onTap: () {
                          setState(() {
                            isTypeSelected[2] = !isTypeSelected[2];
                          });
                        },
                      ),
                      InkWell(
                        child: ChipWidget(
                            title: "Other issues", isChecked: isTypeSelected[3]),
                        onTap: () {
                          setState(() {
                            isTypeSelected[3] = !isTypeSelected[3];
                          });
                        },
                      ),
                    ],*/
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Form(
                    key: _formkey,
                    child: TextFormField(
                      maxLines: 10,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        hintText: 'Please briefly describe the issue',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      validator: (_) => state.isValidfeebackIssue
                          ? null
                          : "Must contain 10 digits",
                      onChanged: (String value) => feedbackSecondBloc.add(
                        FeedbackIssueChanged(feebackIssue: value),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              );
            }),
          ),
        ),
        BlocBuilder<FeedbackSecondBloc, FeedbackSecondState>(
            builder: (BuildContext context,FeedbackSecondState state) {
          return state.formStatus is FormSubmitting
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text("Send Feedback")),
                  onPressed: () {
                    if (_formkey.currentState!.validate() &&
                        state.isreasonsempty) {
                      context
                          .read<FeedbackSecondBloc>()
                          .add(FeedbackSubmitted());
                    }
                  },
                );
        }),
        /* ElevatedButton(
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
        ),*/
      ],
    );
  }
}
