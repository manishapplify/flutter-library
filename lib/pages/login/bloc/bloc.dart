import 'package:components/Authentication/repo.dart';
import 'package:components/Authentication/form_submission.dart';
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
    on<LoginEmailChanged>((LoginEmailChanged event, Emitter<LoginState> emit) {
      emit(
        state.copyWith(
          email: event.email,
        ),
      );
    });
    on<LoginPasswordChanged>(
        (LoginPasswordChanged event, Emitter<LoginState> emit) {
      emit(
        state.copyWith(
          password: event.password,
        ),
      );
    });
    on<LoginSubmitted>((LoginSubmitted event, Emitter<LoginState> emit) async {
      emit(
        state.copyWith(
          formStatus: FormSubmitting(),
        ),
      );
      try {
        await _authRepository.login(
          username: state.email,
          password: state.password,
        );
        emit(
          state.copyWith(
            formStatus: SubmissionSuccess(),
          ),
        );
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
    });
    on<SocialSignInSummitted>(
        (SocialSignInSummitted event, Emitter<LoginState> emit) async {
      emit(
        state.copyWith(
          formStatus: FormSubmitting(),
        ),
      );
      try {
        await _authRepository.signInWithGoogle();
        emit(
          state.copyWith(
            formStatus: SubmissionSuccess(),
          ),
        );
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
    });
    on<FacebookSignInSummitted>(
        (FacebookSignInSummitted event, Emitter<LoginState> emit) async {
      emit(
        state.copyWith(
          formStatus: FormSubmitting(),
        ),
      );
      try {
        await _authRepository.signInWithFacebook();
        emit(
          state.copyWith(
            formStatus: SubmissionSuccess(),
          ),
        );
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
    });

    on<ResetFormStatus>(_resetFormStatusHandler);
  }

  final AuthRepository _authRepository;

  void _resetFormStatusHandler(
          ResetFormStatus event, Emitter<LoginState> emit) =>
      emit(
        state.copyWith(
          formStatus: const InitialFormStatus(),
        ),
      );
}
