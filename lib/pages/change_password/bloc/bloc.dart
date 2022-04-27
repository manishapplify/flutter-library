import 'package:components/Authentication/repo.dart';
import 'package:components/common_models/work_status.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/services/api/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:components/validators/validators.dart' as validators;

part 'event.dart';
part 'state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc({
    required Api api,
    required AuthRepository authRepository,
    required AuthCubit authCubit,
  })  : _authRepository = authRepository,
        super(ChangePasswordState()) {
    on<CurrentPasswordChanged>(_currentPasswordChangedHandler);
    on<NewPasswordChanged>(_newPasswordChangedHandler);
    on<ConfirmNewPasswordChanged>(_confirmNewPasswordChangedHandler);
    on<ResetFormState>(
        (ResetFormState event, Emitter<ChangePasswordState> emit) {
      emit(ChangePasswordState());
    });
    on<ResetFormStatus>(_resetFormStatusHandler);
    on<ChangePasswordSubmitted>(_changePasswordEventHandler);
  }

  final AuthRepository _authRepository;

  void _currentPasswordChangedHandler(
      CurrentPasswordChanged event, Emitter<ChangePasswordState> emit) {
    emit(
      state.copyWith(
        currentPassword: event.currentPassword,
        formStatus: const Idle(),
      ),
    );
  }

  void _newPasswordChangedHandler(
      NewPasswordChanged event, Emitter<ChangePasswordState> emit) {
    emit(
      state.copyWith(
        newPassword: event.newPassword,
        formStatus: const Idle(),
      ),
    );
  }

  void _confirmNewPasswordChangedHandler(
      ConfirmNewPasswordChanged event, Emitter<ChangePasswordState> emit) {
    emit(
      state.copyWith(
        confirmNewPassword: event.confirmNewPassword,
        formStatus: const Idle(),
      ),
    );
  }

  void _changePasswordEventHandler(
      ChangePasswordSubmitted event, Emitter<ChangePasswordState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        await _authRepository.changePassword(
          currentPassword: state.currentPassword,
          newPassword: state.newPassword,
        );
      },
      emit: emit,
    );
  }

  void _resetFormStatusHandler(
          ResetFormStatus event, Emitter<ChangePasswordState> emit) =>
      emit(
        state.copyWith(
          formStatus: const Idle(),
        ),
      );

  Future<void> _commonHandler(
      {required Future<void> Function() handlerJob,
      required Emitter<ChangePasswordState> emit}) async {
    emit(state.copyWith(formStatus: InProgress()));

    try {
      await handlerJob();
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
