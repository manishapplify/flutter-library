part of 'bloc.dart';

class ReportBugState {
  ReportBugState({
    this.title,
    this.description,
    this.screenShot,
    this.formStatus = const Idle(),
  });

  final String? title;
  String? get titleValidator =>
      !validators.notEmptyValidator(description) ? 'Title is required' : null;

  final String? description;
  String? get descriptionValidator => !validators.notEmptyValidator(description)
      ? 'Description is required'
      : null;

  final File? screenShot;
  bool get isValidScreenShot => screenShot is File;
  final WorkStatus formStatus;

  ReportBugState copyWith({
    String? title,
    String? description,
    File? screenShot,
    WorkStatus? formStatus,
  }) {
    return ReportBugState(
      title: title ?? this.title,
      description: description ?? this.description,
      screenShot: screenShot ?? this.screenShot,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
