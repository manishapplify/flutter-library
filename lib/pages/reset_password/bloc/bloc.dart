import 'package:bloc/bloc.dart';
import 'package:components/common/work_status.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/common/app_exception.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:components/common/validators.dart' as validators;

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
            newPassword: event.newPassword, formStatus: const Idle()),
      );
  void _onConfirmNewPasswordChangedHandler(
          ConfirmNewPasswordChanged event, Emitter<ResetPasswordState> emit) =>
      emit(
        state.copyWith(
            confirmNewPassword: event.confirmNewPassword,
            formStatus: const Idle()),
      );

  void _onResetPasswordSubmittedHandler(
      ResetPasswordSubmitted event, Emitter<ResetPasswordState> emit) async {
    emit(state.copyWith(formStatus: InProgress()));

    try {
      await _authRepository.resetPassword(state.newPassword);
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
  }
}
