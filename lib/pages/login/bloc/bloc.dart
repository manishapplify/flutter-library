import 'package:components/Authentication/repo.dart';
import 'package:components/common/work_status.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/services/api/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:components/validators/validators.dart' as validators;

part 'event.dart';
part 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required Api api,
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(LoginState()) {
    on<LoginEmailChanged>(_loginEmailChangedHandler);
    on<LoginPasswordChanged>(_loginPasswordChangedHandler);
    on<LoginSubmitted>(_loginEventHandler);
    on<GoogleSignInSummitted>(_googleLoginEventHandler);
    on<FacebookSignInSummitted>(_facebookLoginEventHandler);
    on<ResetFormStatus>(_resetFormStatusHandler);
  }

  final AuthRepository _authRepository;

  void _resetFormStatusHandler(
          ResetFormStatus event, Emitter<LoginState> emit) =>
      emit(
        state.copyWith(
          formStatus: const Idle(),
        ),
      );

  void _loginEmailChangedHandler(
      LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        email: event.email,
      ),
    );
  }

  void _loginPasswordChangedHandler(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        password: event.password,
      ),
    );
  }

  void _loginEventHandler(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        await _authRepository.login(
          username: state.email,
          password: state.password,
        );
      },
      emit: emit,
    );
  }

  void _googleLoginEventHandler(
      GoogleSignInSummitted event, Emitter<LoginState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        await _authRepository.signInWithGoogle();
      },
      emit: emit,
    );
  }

  void _facebookLoginEventHandler(
      FacebookSignInSummitted event, Emitter<LoginState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        await _authRepository.signInWithFacebook();
      },
      emit: emit,
    );
  }

  Future<void> _commonHandler(
      {required Future<void> Function() handlerJob,
      required Emitter<LoginState> emit}) async {
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
    } on Error catch (_) {
      print('error');
    }
  }
}
