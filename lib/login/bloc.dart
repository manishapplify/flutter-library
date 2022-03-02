import 'package:components/Authentication/repo.dart';
import 'package:components/Authentication/form_submission.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/login/event.dart';
import 'package:components/login/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.authRepo, required this.authCubit})
      : super(LoginState()) {
    on<LoginUsernameChanged>(
        (LoginUsernameChanged event, Emitter<LoginState> emit) {
      emit(state.copyWith(username: event.username));
    });
    on<LoginPasswordChanged>(
        (LoginPasswordChanged event, Emitter<LoginState> emit) {
      emit(state.copyWith(password: event.password));
    });
    on<LoginSubmitted>((LoginSubmitted event, Emitter<LoginState> emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        await authRepo.login(
            username: state.username, password: state.password);
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } on Exception catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(e)));
      }
    });
  }

  final AuthRepository authRepo;
  final AuthCubit authCubit;
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