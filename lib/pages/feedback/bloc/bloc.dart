import 'package:components/Authentication/form_submission.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/pages/feedback/models/request.dart';
import 'package:components/services/api/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:components/validators/validators.dart' as validators;

part 'event.dart';
part 'state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc({
    required Api api,
  })  : _api = api,
        super(FeedbackState()) {
    on<FeedbackTitleChanged>(_feedbackTitleChangedHandler);
    on<FeedbackRatingChanged>(_feedbackRatingChangedHandler);
    on<FeedbackCommentChanged>(_feedbackCommentChangedHandler);
    on<FeedbackSubmitted>(_feedbackSubmittedEventHandler);
    on<ResetFormStatus>(_resetFormStatusHandler);
    on<ResetFormState>(_resetFormStateHandler);
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

  Future<void> _commonHandler(
      {required Future<void> Function() handlerJob,
      required Emitter<FeedbackState> emit}) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    try {
      await handlerJob();
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } on DioError catch (e) {
      late final AppException exception;

      if (e.type == DioErrorType.other && e.error is AppException) {
        exception = e.error;
      } else {
        exception = AppException.api400Exception();
      }

      emit(
        state.copyWith(
          formStatus: SubmissionFailed(
            exception: exception,
            message: exception.message,
          ),
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(
          formStatus: SubmissionFailed(exception: e, message: e.message)));
    } on Exception catch (_) {
      emit(
        state.copyWith(
          formStatus: SubmissionFailed(exception: Exception('Failure')),
        ),
      );
    }
  }

  void _resetFormStatusHandler(
          ResetFormStatus event, Emitter<FeedbackState> emit) =>
      emit(
        state.copyWith(
          formStatus: const InitialFormStatus(),
        ),
      );

  void _resetFormStateHandler(
          ResetFormState event, Emitter<FeedbackState> emit) =>
      emit(FeedbackState());
}
