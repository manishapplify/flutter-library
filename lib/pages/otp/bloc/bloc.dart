import 'package:bloc/bloc.dart';
import 'package:components/Authentication/form_submission.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/enums/screen.dart';
import 'package:components/services/api/api.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

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
        state.copyWith(otp: event.otp, formStatus: const InitialFormStatus()),
      );

  void _onOtpSubmittedHandler(
      OtpSubmitted event, Emitter<OtpState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    if (state.isOtpValid) {
      try {
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
        emit(state.copyWith(formStatus: SubmissionSuccess()));
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
    } else {
      emit(state.copyWith(formStatus: SubmissionFailed()));
    }
  }

  void _resetFormStatusHandler(ResetFormStatus event, Emitter<OtpState> emit) =>
      emit(
        state.copyWith(
          formStatus: const InitialFormStatus(),
        ),
      );
}
