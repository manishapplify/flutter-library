import 'package:bloc/bloc.dart';
import 'package:components/Authentication/form_submission.dart';
import 'package:components/Authentication/repo.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(ResetPasswordState()) {
    on<ResetPasswordChanged>(_onResetPasswordChangedHandler);
    on<ResetPasswordSubmitted>(_onResetPasswordSubmittedHandler);
  }
  final AuthRepository _authRepository;

  void _onResetPasswordChangedHandler(
          ResetPasswordChanged event, Emitter<ResetPasswordState> emit) =>
      emit(
        state.copyWith(
            password: event.password, formStatus: const InitialFormStatus()),
      );

  void _onResetPasswordSubmittedHandler(
      ResetPasswordSubmitted event, Emitter<ResetPasswordState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    if (state.isValidPassword) {
      try {
        await _authRepository.resetPassword(state.password);
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } on DioError catch (e) {
        emit(
          state.copyWith(
            formStatus: SubmissionFailed(
              exception: e,
              message: (e.error is String?) ? e.error : 'Failure',
            ),
          ),
        );
      } on Exception catch (_) {
        emit(
          state.copyWith(
            formStatus: SubmissionFailed(exception: Exception('Failure')),
          ),
        );
      }
    } else {
      emit(state.copyWith(formStatus: SubmissionFailed()));
    }
  }
}
