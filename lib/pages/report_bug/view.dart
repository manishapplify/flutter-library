import 'dart:io';

import 'package:components/services/image_cropping_service.dart';
import 'package:components/services/image_picking_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:components/blocs/blocs.dart';
import 'package:components/common/dialogs.dart';
import 'package:components/common/widgets/image_container.dart';
import 'package:components/common/work_status.dart';
import 'package:components/pages/base_page.dart';

class ReportBugPage extends BasePage {
  const ReportBugPage({Key? key}) : super(key: key);

  @override
  State<ReportBugPage> createState() => _ReportBugState();
}

class _ReportBugState extends BasePageState<ReportBugPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late final FocusNode descriptionFocusNode;
  late final ReportBugBloc reportBugBloc;
  late final TextEditingController titleTextEditingController;
  late final TextEditingController descriptionTextEditingController;

  @override
  void initState() {
    descriptionFocusNode = FocusNode();
    reportBugBloc = BlocProvider.of(context);
    titleTextEditingController = TextEditingController();
    descriptionTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleTextEditingController.dispose();
    descriptionTextEditingController.dispose();
    super.dispose();
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
        if (state.blocStatus is Success) {
          reportBugBloc.add(ResetReportBugFormState());
          titleTextEditingController.value = TextEditingValue.empty;
          descriptionTextEditingController.value = TextEditingValue.empty;
          Future<void>.microtask(
            () => showSnackBar(
              const SnackBar(
                content: Text('Bug reported successfully'),
              ),
            ),
          );
        } else if (state.blocStatus is Failure) {
          reportBugBloc.add(ResetReportBugFormStatus());
          final Failure failure = state.blocStatus as Failure;
          Future<void>.microtask(
            () => showSnackBar(
              SnackBar(
                content: Text(failure.message ?? 'Failure'),
              ),
            ),
          );
        }

        if (state.pickImageStatus is Success) {
          reportBugBloc
            ..add(ReportBugCropImageEvent(
                ImageCropperConfiguration(imagePath: state.pickedImage!.path)))
            ..add(ReportBugResetImageEvent());
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
                        controller: titleTextEditingController,
                        textCapitalization: TextCapitalization.words,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Enter a title',
                          labelText: 'Title',
                          prefixIcon: Icon(Icons.edit),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (_) =>
                            descriptionFocusNode.requestFocus(),
                        textInputAction: TextInputAction.next,
                        validator: (_) => state.titleValidator,
                        onChanged: (String value) => reportBugBloc.add(
                          ReportBugTitleChanged(
                            title: value,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: descriptionTextEditingController,
                        textCapitalization: TextCapitalization.words,
                        focusNode: descriptionFocusNode,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Please briefly describe the issue',
                          labelText: 'Description',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        onFieldSubmitted: (_) => onFormSubmitted(),
                        validator: (_) => state.descriptionValidator,
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
                             
                              },
                              onCameraSelected: () {
                                reportBugBloc.add(ReportBugImagePickEvent(
                                    ImagePickerConfiguration(
                                        source: ImageSources.camera)));
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              onGallerySelected: () {
                                reportBugBloc.add(ReportBugImagePickEvent(
                                    ImagePickerConfiguration(
                                        source: ImageSources.gallery)));
                                if (mounted) {
                                  Navigator.pop(context);
                                }
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
                      if (state.isValidScreenShot)
                        SizedBox(
                          height: 200.0,
                          child: ImageContainer(
                            imagePath: state.croppedImage!.path,
                            iconAlignment: Alignment.topRight,
                            circularDecoration: false,
                            onContainerTap: () => reportBugBloc.add(
                              ReportBugResetImageCropEvent()
                            ),
                            overlayIcon: const Icon(Icons.cancel),
                          ),
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
