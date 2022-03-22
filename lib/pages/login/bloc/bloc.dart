import 'package:components/Authentication/repo.dart';
import 'package:components/Authentication/form_submission.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/services/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required Api api,
    required AuthRepository authRepository,
    required AuthCubit authCubit,
  })  : _authRepository = authRepository,
        super(LoginState()) {
    on<LoginUsernameChanged>(
        (LoginUsernameChanged event, Emitter<LoginState> emit) {
      emit(
        state.copyWith(username: event.username),
      );
    });
    on<LoginPasswordChanged>(
        (LoginPasswordChanged event, Emitter<LoginState> emit) {
      emit(
        state.copyWith(password: event.password),
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
          username: state.username,
          password: state.password,
        );
        emit(
          state.copyWith(
            formStatus: SubmissionSuccess(),
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            formStatus: SubmissionFailed(exception: e),
          ),
        );
      }
    });
  }

  final AuthRepository _authRepository;
}

 /* @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    // Username updated
    if (event is LoginUsernameChanged) {
      yield state.copyWith(username: event.username);

      // Password updated
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: event.password);

      // Form submitted
    } else if (event is LoginSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        await authRepo.login();
        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }
}*/