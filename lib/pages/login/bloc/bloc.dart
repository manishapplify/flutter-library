import 'package:components/Authentication/repo.dart';
import 'package:components/Authentication/form_submission.dart';
import 'package:components/cubits/auth_cubit.dart';
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
    required AuthCubit authCubit,
  })  : _authRepository = authRepository,
        super(LoginState()) {
    on<LoginEmailChanged>((LoginEmailChanged event, Emitter<LoginState> emit) {
      emit(
        state.copyWith(
            email: event.email, formStatus: const InitialFormStatus()),
      );
    });
    on<LoginPasswordChanged>(
        (LoginPasswordChanged event, Emitter<LoginState> emit) {
      emit(
        state.copyWith(
            password: event.password, formStatus: const InitialFormStatus()),
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
    });

    on<GoogleSignInPressed>(_googleSignInPressedHandler);
  }

  final AuthRepository _authRepository;

  void _googleSignInPressedHandler(
      GoogleSignInPressed event, Emitter<LoginState> emit) async {
    await _authRepository.signInWithGoogle();
  }
}
