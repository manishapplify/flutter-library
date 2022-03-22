import 'package:components/Authentication/form_submission.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/feedback/feedback_one/bloc/event.dart';
import 'package:components/feedback/feedback_one/bloc/state.dart';
import 'package:components/services/api.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackOneBloc extends Bloc<FeedbackEvent, FeedbackOneState> {
  FeedbackOneBloc(
      {required Api api,
      required AuthRepository authRepository,
      required AuthCubit authCubit})
      : _api = api,
        _authRepository = authRepository,
        _authCubit = authCubit,
        super(FeedbackOneState()) {
    on<FeedbackIssueChanged>((FeedbackIssueChanged event, Emitter<FeedbackOneState> emit) {
      emit(state.copyWith(feebackIssue: event.feebackIssue));
      print(event.feebackIssue);
    });
    on<FeedbackEmailChanged>((FeedbackEmailChanged event, Emitter<FeedbackOneState> emit) {
      emit(state.copyWith(feedbackEmail: event.feedbackEmail));
    });
    on<FeedbackReasonChanged>((FeedbackReasonChanged event, Emitter<FeedbackOneState> emit) {
      emit(state.copyWith(reasons: event.reason));
      print(event.reason);
    });
    on<FeedbackSubmitted>((FeedbackSubmitted event, Emitter<FeedbackOneState> emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        await _authRepository.feedbackSubmit(
            feedbackissue: state.feebackIssue, feedbackreasons: state.reasons);
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } on Exception catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(e)));
      }
    });
  }
  final Api _api;
  final AuthRepository _authRepository;
  final AuthCubit _authCubit;
}
