part of blocs;

abstract class ReportBugEvent extends BaseEvent {}

class ReportBugTitleChanged extends ReportBugEvent {
  ReportBugTitleChanged({required this.title});
  final String title;
}

class ReportBugDescriptionChanged extends ReportBugEvent {
  ReportBugDescriptionChanged({required this.description});
  final String description;
}

class ReportBugScreenShotChanged extends ReportBugEvent {
  ReportBugScreenShotChanged({required this.screenShot});
  final File screenShot;
}

class ReportBugScreenShotRemoved extends ReportBugEvent {}

class ReportBugSubmitted extends ReportBugEvent {}

class ResetReportBugFormStatus extends ReportBugEvent {}

class ResetReportBugFormState extends ReportBugEvent {}
