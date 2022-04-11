import 'package:bloc/bloc.dart';
import 'package:components/Authentication/form_submission.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:components/validators/validators.dart' as validators;

part 'event.dart';
part 'state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(ResetPasswordState()) {
    on<ResetNewPasswordChanged>(_onResetNewPasswordChangedHandler);
    on<ConfirmNewPasswordChanged>(_onConfirmNewPasswordChangedHandler);
    on<ResetPasswordSubmitted>(_onResetPasswordSubmittedHandler);
    on<ResetFormState>(
        (ResetFormState event, Emitter<ResetPasswordState> emit) {
      emit(ResetPasswordState());
    });
  }
  final AuthRepository _authRepository;

  void _onResetNewPasswordChangedHandler(
          ResetNewPasswordChanged event, Emitter<ResetPasswordState> emit) =>
      emit(
        state.copyWith(
            newPassword: event.newPassword,
            formStatus: const InitialFormStatus()),
      );
  void _onConfirmNewPasswordChangedHandler(
          ConfirmNewPasswordChanged event, Emitter<ResetPasswordState> emit) =>
      emit(
        state.copyWith(
            confirmNewPassword: event.confirmNewPassword,
            formStatus: const InitialFormStatus()),
      );

  void _onResetPasswordSubmittedHandler(
      ResetPasswordSubmitted event, Emitter<ResetPasswordState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    try {
      await _authRepository.resetPassword(state.newPassword);
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
}
