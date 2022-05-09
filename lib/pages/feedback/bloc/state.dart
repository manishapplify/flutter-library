part of blocs;

class FeedbackState extends BaseState {
 const FeedbackState({
    this.title,
    this.comment,
    this.rating = 5,
    WorkStatus blocStatus = const Idle(),
  }) : super(blocStatus);
  final String? title;
  bool get isValidTitle =>
      validators.notEmptyValidator(title) && title!.length > 9;
  final int rating;
  final String? comment;
  String? get commentValidator =>
      !validators.notEmptyValidator(comment) ? 'Description is required' : null;


  FeedbackState copyWith({
    String? title,
    int? rating,
    String? comment,
    WorkStatus? blocStatus,
  }) {
    return FeedbackState(
      title: title ?? this.title,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      blocStatus: blocStatus ?? this.blocStatus,
    );
  }
   @override
  BaseState resetState() => const FeedbackState();

  @override
  BaseState updateStatus(WorkStatus blocStatus) =>
      this.copyWith(blocStatus: blocStatus);
}
