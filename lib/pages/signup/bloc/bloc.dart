import 'package:components/common/work_status.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:components/common/validators.dart' as validators;

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
        formStatus: const Idle(),
      ),
    );
  }

  void _signUpPhoneNumberChangedHandler(
      SignUpPhoneNumberChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        formStatus: const Idle(),
      ),
    );
  }

  void _signUpEmailChangedHandler(
      SignUpEmailChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        formStatus: const Idle(),
      ),
    );
  }

  void _signUpPasswordChangedHandler(
      SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        password: event.password,
        formStatus: const Idle(),
      ),
    );
  }

  void _signConfirmPasswordChangedHandler(
      SignUpConfirmPasswordChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        confirmPassword: event.confirmPassword,
        formStatus: const Idle(),
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
    }
  }
}
