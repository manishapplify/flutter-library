abstract class FeedbackEvent {}

class FeedbackReasonChanged extends FeedbackEvent {
  FeedbackReasonChanged({this.reason});
  final String? reason;
}

class FeedbackIssueChanged extends FeedbackEvent {
  FeedbackIssueChanged({this.feebackIssue});
  final String? feebackIssue;
}

class FeedbackRatingChanged extends FeedbackEvent {
  FeedbackRatingChanged({this.feedbackRating});
  final double? feedbackRating;
}

class FeedbackSubmitted extends FeedbackEvent {}
