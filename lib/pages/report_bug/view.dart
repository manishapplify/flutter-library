import 'dart:io';

import 'package:components/Authentication/form_submission.dart';
import 'package:components/base/base_page.dart';
import 'package:components/dialogs/dialogs.dart';
import 'package:components/pages/report_bug/bloc/bloc.dart';
import 'package:components/widgets/image_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportBugPage extends BasePage {
  const ReportBugPage({Key? key}) : super(key: key);

  @override
  State<ReportBugPage> createState() => _ReportBugState();
}

class _ReportBugState extends BasePageState<ReportBugPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late final FocusNode descriptionFocusNode;
  late final ReportBugBloc reportBugBloc;

  @override
  void initState() {
    descriptionFocusNode = FocusNode();
    reportBugBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      title: const Text("Report Bug"),
    );
  }

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<ReportBugBloc, ReportBugState>(
      builder: (BuildContext context, ReportBugState state) {
        if (state.formStatus is SubmissionSuccess) {
          reportBugBloc.add(ResetFormStatus());
          Future<void>.microtask(() => navigator.pop());
        } else if (state.formStatus is SubmissionFailed) {
          reportBugBloc.add(ResetFormStatus());
          Future<void>.microtask(
            () => showSnackBar(
              const SnackBar(
                content: Text('Failure'),
              ),
            ),
          );
        }

        return Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Enter a title',
                          prefixIcon: Icon(Icons.edit),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (_) =>
                            descriptionFocusNode.requestFocus(),
                        textInputAction: TextInputAction.next,
                        validator: (_) => state.isValidTitle
                            ? null
                            : "Title length too short",
                        onChanged: (String value) => reportBugBloc.add(
                          ReportBugTitleChanged(
                            title: value,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        focusNode: descriptionFocusNode,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Please briefly describe the issue',
                          prefixIcon: Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        onFieldSubmitted: (_) => onFormSubmitted(),
                        validator: (_) => state.isValidTitle
                            ? null
                            : "Description length too short",
                        onChanged: (String value) => reportBugBloc.add(
                          ReportBugDescriptionChanged(
                            description: value,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      OutlinedButton(
                        onPressed: () {
                          showImagePickerPopup(
                            context: context,
                            cameraAllowed: false,
                            onImagePicked: (File selectedScreenShot) {
                              if (!reportBugBloc.isClosed) {
                                reportBugBloc.add(
                                  ReportBugScreenShotChanged(
                                    screenShot: selectedScreenShot,
                                  ),
                                );
                              }
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
                        child: const Text(
                          "Include Screenshot",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      if (state.isValidScreenShot)
                        SizedBox(
                          height: 200.0,
                          child: ImageContainer(
                            imagePath: state.screenShot!.path,
                            circularDecoration: false,
                            onContainerTap: () => reportBugBloc.add(
                              ReportBugScreenShotRemoved(),
                            ),
                            overlayIcon: const Icon(Icons.cancel),
                          ),
                          //  GridView.builder(
                          //     shrinkWrap: true,
                          //     gridDelegate:
                          //         const SliverGridDelegateWithFixedCrossAxisCount(
                          //             crossAxisCount: 3, mainAxisSpacing: 8.0),
                          //     itemCount: _imageList.length,
                          //     itemBuilder: (BuildContext context, int i) {
                          //       return Image.file(File(_imageList[i].path));
                          //     }),
                        )
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onFormSubmitted,
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
      },
    );
  }

  void onFormSubmitted() {
    if (_formkey.currentState!.validate() &&
        reportBugBloc.state.isValidScreenShot) {
      FocusScope.of(context).unfocus();
      reportBugBloc.add(
        ReportBugSubmitted(),
      );
    } else if (!reportBugBloc.state.isValidScreenShot) {
      showSnackBar(
        const SnackBar(
          content: Text('Include a screen shot'),
        ),
      );
    }
  }
}
