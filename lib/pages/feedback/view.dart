import 'package:components/common/work_status.dart';
import 'package:components/pages/base_page.dart';
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
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late final TextEditingController descriptionTextEditingController;

  @override
  void initState() {
    feedbackBloc = BlocProvider.of(context);
    descriptionTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    descriptionTextEditingController.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(title: const Text("Feedback"));
  }

  void onFormSubmitted() {
    if (!feedbackBloc.state.isValidTitle) {
      showSnackBar(
        const SnackBar(
          content: Text('Select a topic'),
        ),
      );
      return;
    }

    if (_formkey.currentState!.validate()) {
      feedbackBloc.add(FeedbackSubmitted());
    }
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: BlocBuilder<FeedbackBloc, FeedbackState>(
                builder: (BuildContext context, FeedbackState state) {
              if (state.formStatus is Success) {
                feedbackBloc.add(ResetFormState());
                descriptionTextEditingController.value = TextEditingValue.empty;
                Future<void>.microtask(
                  () => showSnackBar(
                    const SnackBar(
                      content: Text('Feeback submitted successfully'),
                    ),
                  ),
                );
              } else if (state.formStatus is Failure) {
                feedbackBloc.add(ResetFormStatus());

                final Failure failure = state.formStatus as Failure;
                Future<void>.microtask(
                  () => showSnackBar(
                    SnackBar(
                      content: Text(failure.message ?? 'Failure'),
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
                  Form(
                    key: _formkey,
                    child: TextFormField(
                      controller: descriptionTextEditingController,
                      textCapitalization: TextCapitalization.words,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        hintText: 'Please briefly describe the issue',
                        labelText: 'Description',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      onChanged: (String value) => feedbackBloc.add(
                        FeedbackCommentChanged(comment: value),
                      ),
                      validator: (_) => state.commentValidator,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: state.formStatus is InProgress
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
                            onPressed: onFormSubmitted,
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
