import 'package:bloc/bloc.dart';
import 'package:components/Authentication/repo.dart';
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
      emit(FailedLoggingOut(
        exception: e,
        message: (e.error is String?) ? e.error : 'Failure',
      ));
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
      emit(FailedDeletingAccount(
        exception: e,
        message: (e.error is String?) ? e.error : 'Failure',
      ));
    } on Exception catch (e) {
      emit(FailedDeletingAccount(exception: e));
    }
  }

  void resetState() => emit(InitialState());
}
