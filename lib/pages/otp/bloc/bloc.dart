import 'package:bloc/bloc.dart';
import 'package:components/common_models/work_status.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/enums/screen.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/services/api/api.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:components/validators/validators.dart' as validators;

part 'event.dart';
part 'state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc({
    required Screen screenType,
    required Api api,
    required AuthRepository authRepository,
    required AuthCubit authCubit,
  })  : _authRepository = authRepository,
        _api = api,
        _authCubit = authCubit,
        super(OtpState(screenType: screenType)) {
    on<OtpChanged>(_onOtpChangedHandler);
    on<OtpSubmitted>(_onOtpSubmittedHandler);
    on<ResetFormStatus>(_resetFormStatusHandler);
  }

  final AuthRepository _authRepository;
  final Api _api;
  final AuthCubit _authCubit;

  void _onOtpChangedHandler(OtpChanged event, Emitter<OtpState> emit) => emit(
        state.copyWith(otp: event.otp),
      );

  void _onOtpSubmittedHandler(
      OtpSubmitted event, Emitter<OtpState> emit) async {
    emit(state.copyWith(formStatus: InProgress()));

    try {
      if (!state.isOtpValid) {
        if (state.isOtpEmpty) {
          throw AppException.otpCannotBeEmpty();
        }
        throw AppException.otpvalid();
      }
      if (state.screenType == Screen.forgotPassword) {
        await _authRepository.verifyForgetPasswordOtp(state.otp!);
      } else if (state.screenType == Screen.verifyEmail) {
        await _api.verifyEmail(state.otp!);
        final User user = _authCubit.state.user!;
        _authCubit.signupOrLogin(
          user.copyWithJson(
            <String, dynamic>{
              "isEmailVerified": 1,
            },
          ),
        );
      }
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

  void _resetFormStatusHandler(ResetFormStatus event, Emitter<OtpState> emit) =>
      emit(
        state.copyWith(
          formStatus: const Idle(),
        ),
      );
}
