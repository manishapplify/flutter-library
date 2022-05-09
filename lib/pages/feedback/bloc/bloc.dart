part of blocs;

class FeedbackBloc extends BaseBloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc({
    required Api api,
  })  : _api = api,
        super(const FeedbackState()) {
    on<FeedbackTitleChanged>(_feedbackTitleChangedHandler);
    on<FeedbackRatingChanged>(_feedbackRatingChangedHandler);
    on<FeedbackCommentChanged>(_feedbackCommentChangedHandler);
    on<FeedbackSubmitted>(_feedbackSubmittedEventHandler);
    on<ResetFeedbackFormStatus>(_resetFormStatusHandler);
    on<ResetFeedbackFormState>(_resetFormStateHandler);
  }

  final Api _api;
  void _feedbackTitleChangedHandler(
      FeedbackTitleChanged event, Emitter<FeedbackState> emit) {
    emit(
      state.copyWith(
        title: event.title,
      ),
    );
  }

  void _feedbackRatingChangedHandler(
      FeedbackRatingChanged event, Emitter<FeedbackState> emit) {
    emit(
      state.copyWith(
        rating: event.rating,
      ),
    );
  }

  void _feedbackCommentChangedHandler(
      FeedbackCommentChanged event, Emitter<FeedbackState> emit) {
    emit(
      state.copyWith(
        comment: event.comment,
      ),
    );
  }

  void _feedbackSubmittedEventHandler(
      FeedbackSubmitted event, Emitter<FeedbackState> emit) async {
    final FeedbackRequest request = FeedbackRequest(
      comment: state.comment,
      rating: state.rating,
      title: state.title!,
      type: 'USER',
    );
    await _commonHandler(
      handlerJob: () async {
        await _api.reportFeedback(request);
      },
      emit: emit,
    );
  }

  void _resetFormStatusHandler(
          ResetFeedbackFormStatus event, Emitter<FeedbackState> emit) =>
      emit(
        state.copyWith(
          blocStatus: const Idle(),
        ),
      );

  void _resetFormStateHandler(
          ResetFeedbackFormState event, Emitter<FeedbackState> emit) =>
      emit(const FeedbackState());
}
