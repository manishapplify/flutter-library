part of 'bloc.dart';

class FeedbackState {
  FeedbackState({
    this.title,
    this.comment,
    this.rating = 5,
    this.formStatus = const InitialFormStatus(),
  });
  final String? title;
  bool get isValidTitle =>
      validators.notEmptyValidator(title) && title!.length > 9;
  final int rating;
  final String? comment;
  String? get commentValidator =>
      !validators.notEmptyValidator(comment) ? 'Description is required' : null;

  final FormSubmissionStatus formStatus;

  FeedbackState copyWith({
    String? title,
    int? rating,
    String? comment,
    FormSubmissionStatus? formStatus,
  }) {
    return FeedbackState(
      title: title ?? this.title,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
