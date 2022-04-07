import 'package:bloc/bloc.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(InitialState());

  final AuthRepository _authRepository;

  void logout() async {
    emit(LoggingOut());
    try {
      await _authRepository.logout();
      emit(LogdedOut());
    } on DioError catch (e) {
      late final AppException exception;

      if (e.type == DioErrorType.other && e.error is AppException) {
        exception = e.error;
      } else {
        exception = AppException.api400Exception();
      }

      emit(
        FailedLoggingOut(
          exception: exception,
          message: exception.message,
        ),
      );
    } on Exception catch (e) {
      emit(FailedLoggingOut(exception: e));
    }
  }

  void deleteAccount() async {
    emit(DeletingAccount());
    try {
      await _authRepository.deleteAccount();
      emit(DeletedAccount());
    } on DioError catch (e) {
      late final AppException exception;

      if (e.type == DioErrorType.other && e.error is AppException) {
        exception = e.error;
      } else {
        exception = AppException.api400Exception();
      }

      emit(
        FailedDeletingAccount(
          exception: exception,
          message: exception.message,
        ),
      );
    } on Exception catch (e) {
      emit(FailedDeletingAccount(exception: e));
    }
  }

  void resetState() => emit(InitialState());
}
