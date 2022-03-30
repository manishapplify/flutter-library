part of 'bloc.dart';

abstract class FeedbackEvent {}

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

class ResetFormStatus extends FeedbackEvent {}
