import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/common/app_exception.dart';
import 'package:components/common/work_status.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/services/api/api.dart';

part 'event.dart';
part 'state.dart';

class FeedbackOneBloc extends Bloc<FeedbackEvent, FeedbackOneState> {
  FeedbackOneBloc(
      {required Api api,
      required AuthRepository authRepository,
      required AuthCubit authCubit})
      : _authRepository = authRepository,
        super(FeedbackOneState()) {
    on<FeedbackIssueChanged>(
        (FeedbackIssueChanged event, Emitter<FeedbackOneState> emit) {
      emit(state.copyWith(feebackIssue: event.feebackIssue));
    });
    on<FeedbackEmailChanged>(
        (FeedbackEmailChanged event, Emitter<FeedbackOneState> emit) {
      emit(state.copyWith(feedbackEmail: event.feedbackEmail));
    });
    on<FeedbackReasonChanged>(
        (FeedbackReasonChanged event, Emitter<FeedbackOneState> emit) {
      emit(state.copyWith(reasons: event.reason));
    });
    on<FeedbackSubmitted>(
        (FeedbackSubmitted event, Emitter<FeedbackOneState> emit) async {
      emit(state.copyWith(formStatus: InProgress()));
      try {
        await _authRepository.feedbackSubmit(
            feedbackissue: state.feebackIssue, feedbackreasons: state.reasons);
        emit(state.copyWith(formStatus: Success()));
      } on DioError catch (e) {
        late final AppException exception;

        if (e.type == DioErrorType.other && e.error is AppException) {
          exception = e.error;
        } else {
          exception = AppException.api400Exception();
        }

        emit(
          state.copyWith(
            formStatus: Failure(
              exception: exception,
              message: exception.message,
            ),
          ),
        );
      } on AppException catch (e) {
        emit(state.copyWith(
            formStatus: Failure(exception: e, message: e.message)));
      } on Exception catch (_) {
        emit(
          state.copyWith(
            formStatus: Failure(exception: Exception('Failure')),
          ),
        );
      }
    });
  }
  final AuthRepository _authRepository;
}
