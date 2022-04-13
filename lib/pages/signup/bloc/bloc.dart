import 'package:components/Authentication/form_submission.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:dio/dio.dart';
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
    on<SignUpCountryCodeChanged>(_signUpCountryCodeChangedHandler);
    on<SignUpPhoneNumberChanged>(_signUpPhoneNumberChangedHandler);
    on<SignUpEmailChanged>(_signUpEmailChangedHandler);
    on<SignUpPasswordChanged>(_signUpPasswordChangedHandler);
    on<SignUpConfirmPasswordChanged>(_signConfirmPasswordChangedHandler);

    on<SignUpSubmitted>(_signUpEventHandler);
  }

  final AuthRepository _authRepo;

  void _signUpCountryCodeChangedHandler(
      SignUpCountryCodeChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        countryCode: event.countryCode,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _signUpPhoneNumberChangedHandler(
      SignUpPhoneNumberChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _signUpEmailChangedHandler(
      SignUpEmailChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _signUpPasswordChangedHandler(
      SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        password: event.password,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _signConfirmPasswordChangedHandler(
      SignUpConfirmPasswordChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        confirmPassword: event.confirmPassword,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _signUpEventHandler(
      SignUpSubmitted event, Emitter<SignUpState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        await _authRepo.signUp(
          countryCode: state.countryCode,
          phoneNumber: state.phoneNumber,
          email: state.email,
          password: state.password,
          userType: 1,
        );
      },
      emit: emit,
    );
  }

  Future<void> _commonHandler(
      {required Future<void> Function() handlerJob,
      required Emitter<SignUpState> emit}) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    try {
      await handlerJob();
      emit(state.copyWith(formStatus: SubmissionSuccess()));
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
  }
}
