import 'package:components/Authentication/repo.dart';
import 'package:components/Authentication/form_submission.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/services/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  DeleteAccountBloc({
    required Api api,
    required AuthRepository authRepository,
    required AuthCubit authCubit,
  })  : _authRepository = authRepository,
        super(DeleteAccountState()) {
    on<DeleteAccountSubmitted>(
        (DeleteAccountSubmitted event, Emitter<DeleteAccountState> emit) async {
      emit(
        state.copyWith(
          formStatus: FormSubmitting(),
        ),
      );
      try {
        await _authRepository.deleteAccount();
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
