import 'package:components/Authentication/form_submission.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/feedback/feedback_second/bloc/event.dart';
import 'package:components/feedback/feedback_second/bloc/state.dart';
import 'package:components/services/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackSecondBloc extends Bloc<FeedbackEvent, FeedbackSecondState> {
  FeedbackSecondBloc(
      {required Api api,
      required AuthRepository authRepository,
      required AuthCubit authCubit})
      :       _authRepository = authRepository,
        super(FeedbackSecondState()) {
    on<FeedbackIssueChanged>(
        (FeedbackIssueChanged event, Emitter<FeedbackSecondState> emit) {
      emit(state.copyWith(feebackIssue: event.feebackIssue));
      print(event.feebackIssue);
    });
    on<FeedbackRatingChanged>(
        (FeedbackRatingChanged event, Emitter<FeedbackSecondState> emit) {
      emit(state.copyWith(feedbackRating: event.feedbackRating));
    });
    on<FeedbackReasonChanged>(
        (FeedbackReasonChanged event, Emitter<FeedbackSecondState> emit) {
      emit(state.copyWith(feedbackReason: event.reason));
      print(event.reason);
    });
    on<FeedbackSubmitted>(
        (FeedbackSubmitted event, Emitter<FeedbackSecondState> emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        await _authRepository.feedback2Submit(
            feedbackissue: state.feebackIssue,
            feedbackreason: state.feedbackReason,
            feedbackRating: state.feedbackRating);
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } on Exception catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(exception: e)));
      }
    });
  }

  final AuthRepository _authRepository;
}
