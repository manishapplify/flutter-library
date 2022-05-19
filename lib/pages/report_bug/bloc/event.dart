part of blocs;

abstract class ReportBugEvent extends BaseEvent
    implements BaseImageManipulationEvent {}

class ReportBugTitleChanged extends ReportBugEvent {
  ReportBugTitleChanged({required this.title});
  final String title;
}

class ReportBugDescriptionChanged extends ReportBugEvent {
  ReportBugDescriptionChanged({required this.description});
  final String description;
}

class ReportBugSubmitted extends ReportBugEvent {}

class ResetReportBugFormStatus extends ReportBugEvent {}

class ResetReportBugFormState extends ReportBugEvent {}

class ReportBugImagePickEvent extends ReportBugEvent
    implements BaseImagePickEvent {
  ReportBugImagePickEvent(this.imagePickerConfiguration);

  @override
  final ImagePickerConfiguration imagePickerConfiguration;
}

class ReportBugCropImageEvent extends ReportBugEvent
    implements BaseImageCropEvent {
  ReportBugCropImageEvent(this.imageCropperConfiguration);

  @override
  final ImageCropperConfiguration imageCropperConfiguration;
}

class ReportBugResetImageEvent extends ReportBugEvent
    implements ResetPickImageState {}

class ReportBugResetImageCropEvent extends ReportBugEvent
    implements ResetCropImageState {}
