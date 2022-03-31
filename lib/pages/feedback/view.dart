import 'package:components/Authentication/form_submission.dart';
import 'package:components/base/base_page.dart';
import 'package:components/pages/feedback/bloc/bloc.dart';
import 'package:components/widgets/chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends BasePage {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends BasePageState<FeedbackPage> {
  late final FeedbackBloc feedbackBloc;
  final List<String> feedbackTitles = <String>[
    "Suggestions",
    "Login Trouble",
    "Phone Number Related",
    "Personal Profile",
    "Other Issues"
  ];

  @override
  void initState() {
    feedbackBloc = BlocProvider.of(context);
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
            child: BlocBuilder<FeedbackBloc, FeedbackState>(
                builder: (BuildContext context, FeedbackState state) {
              if (state.formStatus is SubmissionSuccess) {
                feedbackBloc.add(ResetFormStatus());
                Future<void>.microtask(
                  () => navigator.pop(),
                );
              } else if (state.formStatus is SubmissionFailed) {
                feedbackBloc.add(ResetFormStatus());
                Future<void>.microtask(
                  () => showSnackBar(
                    const SnackBar(
                      content: Text('Failure'),
                    ),
                  ),
                );
              }

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
                      initialRating: state.rating.toDouble(),
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
                        feedbackBloc
                            .add(FeedbackRatingChanged(rating: rating.toInt()));
                      },
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const Text("Tell us what can be improved?"),
                  const SizedBox(height: 12.0),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 16.0,
                    children: feedbackTitles.map(
                      (String title) {
                        return InkWell(
                          onTap: () {
                            feedbackBloc
                                .add(FeedbackTitleChanged(title: title));
                          },
                          child: ChipWidget(
                            title: title,
                            isChecked: state.title == title,
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText: 'Please briefly describe the issue',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      prefixIcon: Icon(Icons.description),
                    ),
                    onChanged: (String value) => feedbackBloc.add(
                      FeedbackCommentChanged(comment: value),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: state.formStatus is FormSubmitting
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  "Send Feedback",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            onPressed: () {
                              if (state.isValidTitle) {
                                feedbackBloc.add(FeedbackSubmitted());
                              } else {
                                showSnackBar(
                                  const SnackBar(
                                    content: Text('Select a topic'),
                                  ),
                                );
                              }
                            },
                          ),
                  )
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
