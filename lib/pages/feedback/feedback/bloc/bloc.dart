import 'package:components/Authentication/form_submission.dart';
import 'package:components/pages/feedback/feedback/models/request.dart';
import 'package:components/services/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:components/validators/validators.dart' as validators;

part 'event.dart';
part 'state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc({
    required Api api,
  })  : _api = api,
        super(FeedbackState()) {
    on<FeedbackTitleChanged>(
        (FeedbackTitleChanged event, Emitter<FeedbackState> emit) {
      emit(state.copyWith(title: event.title));
    });
    on<FeedbackRatingChanged>(
        (FeedbackRatingChanged event, Emitter<FeedbackState> emit) {
      emit(state.copyWith(rating: event.rating));
    });
    on<FeedbackCommentChanged>(
        (FeedbackCommentChanged event, Emitter<FeedbackState> emit) {
      emit(state.copyWith(comment: event.comment));
    });
    on<FeedbackSubmitted>(
        (FeedbackSubmitted event, Emitter<FeedbackState> emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        final FeedbackRequest request = FeedbackRequest(
          comment: state.comment,
          rating: state.rating,
          title: state.title!,
          type: 'USER',
        );

        await _api.reportFeedback(request);
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } on Exception catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(exception: e)));
      }
    });
    on<ResetFormStatus>(_resetFormStatusHandler);
  }

  final Api _api;

  void _resetFormStatusHandler(
          ResetFormStatus event, Emitter<FeedbackState> emit) =>
      emit(
        state.copyWith(
          formStatus: const InitialFormStatus(),
        ),
      );
}
