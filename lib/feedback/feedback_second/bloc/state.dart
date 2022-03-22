import 'package:components/Authentication/form_submission.dart';

class FeedbackSecondState {
  FeedbackSecondState({
    this.feebackIssue = '',
    this.feedbackReason = '',
    this.feedbackRating = 5,
    this.formStatus = const InitialFormStatus(),
  });
  final String feebackIssue;
  bool get isValidfeebackIssue => feebackIssue.length > 9;
  final double feedbackRating;
  final String feedbackReason;
  bool get isreasonsempty => feedbackReason.isNotEmpty;

  final FormSubmissionStatus formStatus;

  FeedbackSecondState copyWith({
    String? feebackIssue,
    double? feedbackRating,
    String? feedbackReason,
    FormSubmissionStatus? formStatus,
  }) {
    return FeedbackSecondState(
      feebackIssue: feebackIssue ?? this.feebackIssue,
      feedbackRating: feedbackRating ?? this.feedbackRating,
      feedbackReason: feedbackReason ?? this.feedbackReason,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
