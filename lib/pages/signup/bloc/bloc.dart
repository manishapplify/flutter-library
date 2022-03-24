import 'package:components/Authentication/form_submission.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:components/validators/validators.dart' as validators;

part 'event.dart';
part 'state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    required AuthRepository authRepository,
    required AuthCubit authCubit,
  })  : _authRepo = authRepository,
        super(SignUpState()) {
    on<SignUpCountryCodeChanged>(
        (SignUpCountryCodeChanged event, Emitter<SignUpState> emit) {
      emit(
        state.copyWith(
          countryCode: event.countryCode,
          formStatus: const InitialFormStatus(),
        ),
      );
    });
    on<SignUpPhoneNumberChanged>(
        (SignUpPhoneNumberChanged event, Emitter<SignUpState> emit) {
      emit(
        state.copyWith(
          phoneNumber: event.phoneNumber,
          formStatus: const InitialFormStatus(),
        ),
      );
    });
    on<SignUpEmailChanged>(
        (SignUpEmailChanged event, Emitter<SignUpState> emit) {
      emit(
        state.copyWith(
          email: event.email,
          formStatus: const InitialFormStatus(),
        ),
      );
    });
    on<SignUpPasswordChanged>(
        (SignUpPasswordChanged event, Emitter<SignUpState> emit) {
      emit(
        state.copyWith(
          password: event.password,
          formStatus: const InitialFormStatus(),
        ),
      );
    });
    on<SignUpConfirmPasswordChanged>(
        (SignUpConfirmPasswordChanged event, Emitter<SignUpState> emit) {
      emit(
        state.copyWith(
          confirmPassword: event.confirmPassword,
          formStatus: const InitialFormStatus(),
        ),
      );
    });

    on<SignUpSubmitted>(
        (SignUpSubmitted event, Emitter<SignUpState> emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        await _authRepo.signUp(
          countryCode: state.countryCode,
          phoneNumber: state.phoneNumber,
          email: state.email,
          password: state.password,
          userType: 1,
        );
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } on Exception catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(exception: e)));
      }
    });
  }

  final AuthRepository _authRepo;
}
