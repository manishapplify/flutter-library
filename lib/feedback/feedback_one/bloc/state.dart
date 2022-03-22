import 'package:components/Authentication/form_submission.dart';

class FeedbackOneState {
  FeedbackOneState({
    this.feebackIssue = '',
    this.reasons = const <String>['Suggestions'],
    this.feedbackEmail = '',
    this.formStatus = const InitialFormStatus(),
  });
  final String feebackIssue;
  bool get isValidfeebackIssue => feebackIssue.length > 9;
  final String feedbackEmail;
  final List<String> reasons;
  bool get isreasonsempty => reasons.isNotEmpty;

  final FormSubmissionStatus formStatus;

  FeedbackOneState copyWith({
    String? feebackIssue,
    List<String>? reasons,
    String? feedbackEmail,
    FormSubmissionStatus? formStatus,
  }) {
    return FeedbackOneState(
      feebackIssue: feebackIssue ?? this.feebackIssue,
      feedbackEmail: feedbackEmail ?? this.feebackIssue,
      reasons: reasons ?? this.reasons,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
