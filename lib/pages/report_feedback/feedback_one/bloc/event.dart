part of 'bloc.dart';

abstract class FeedbackEvent {}

class FeedbackReasonChanged extends FeedbackEvent {
  FeedbackReasonChanged({this.reason});
  List<String>? reason;
}

class FeedbackIssueChanged extends FeedbackEvent {
  FeedbackIssueChanged({this.feebackIssue});
  final String? feebackIssue;
}

class FeedbackEmailChanged extends FeedbackEvent {
  FeedbackEmailChanged({this.feedbackEmail});
  final String? feedbackEmail;
}

class FeedbackSubmitted extends FeedbackEvent {}
