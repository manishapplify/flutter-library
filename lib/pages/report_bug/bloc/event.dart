part of 'bloc.dart';

@immutable
abstract class ReportBugEvent {}

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

class ResetFormStatus extends ReportBugEvent {}

class ResetFormState extends ReportBugEvent {}
