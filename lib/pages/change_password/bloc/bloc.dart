import 'package:components/Authentication/repo.dart';
import 'package:components/Authentication/form_submission.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/services/api/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    on<CurrentPasswordChanged>(
        (CurrentPasswordChanged event, Emitter<ChangePasswordState> emit) {
      emit(
        state.copyWith(
            currentPassword: event.currentPassword,
            formStatus: const InitialFormStatus()),
      );
    });
    on<NewPasswordChanged>(
        (NewPasswordChanged event, Emitter<ChangePasswordState> emit) {
      emit(
        state.copyWith(
            newPassword: event.newPassword,
            formStatus: const InitialFormStatus()),
      );
    });
    on<ChangePasswordSubmitted>((ChangePasswordSubmitted event,
        Emitter<ChangePasswordState> emit) async {
      emit(
        state.copyWith(
          formStatus: FormSubmitting(),
        ),
      );
      try {
        await _authRepository.changePassword(
          currentPassword: state.currentPassword,
          newPassword: state.newPassword,
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
