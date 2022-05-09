part of blocs;

class ReportBugState extends BaseState {
  const ReportBugState({
    this.title,
    this.description,
    this.screenShot,
    WorkStatus blocStatus = const Idle(),
  }) : super(blocStatus);

  final String? title;
  String? get titleValidator =>
      !validators.notEmptyValidator(description) ? 'Title is required' : null;

  final String? description;
  String? get descriptionValidator => !validators.notEmptyValidator(description)
      ? 'Description is required'
      : null;

  final File? screenShot;
  bool get isValidScreenShot => screenShot is File;

  ReportBugState copyWith({
    String? title,
    String? description,
    File? screenShot,
    WorkStatus? blocStatus,
  }) {
    return ReportBugState(
      title: title ?? this.title,
      description: description ?? this.description,
      screenShot: screenShot ?? this.screenShot,
      blocStatus: blocStatus ?? this.blocStatus,
    );
  }

  @override
  BaseState resetState() => const ReportBugState();

  @override
  BaseState updateStatus(WorkStatus blocStatus) =>
      this.copyWith(blocStatus: blocStatus);
}
