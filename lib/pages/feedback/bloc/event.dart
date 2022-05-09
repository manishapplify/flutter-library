part of blocs;

abstract class FeedbackEvent extends BaseEvent {}

class FeedbackCommentChanged extends FeedbackEvent {
  FeedbackCommentChanged({this.comment});
  final String? comment;
}

class FeedbackTitleChanged extends FeedbackEvent {
  FeedbackTitleChanged({this.title});
  final String? title;
}

class FeedbackRatingChanged extends FeedbackEvent {
  FeedbackRatingChanged({this.rating});
  final int? rating;
}

class FeedbackSubmitted extends FeedbackEvent {}

class ResetFeedbackFormStatus extends FeedbackEvent {}

class ResetFeedbackFormState extends FeedbackEvent {}