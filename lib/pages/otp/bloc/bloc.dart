part of blocs;

class OtpBloc extends BaseBloc<OtpEvent, OtpState> {
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
    on<ResetOtpFormStatus>(_resetFormStatusHandler);
  }

  final AuthRepository _authRepository;
  final Api _api;
  final AuthCubit _authCubit;

  void _onOtpChangedHandler(OtpChanged event, Emitter<OtpState> emit) => emit(
        state.copyWith(otp: event.otp),
      );

  void _onOtpSubmittedHandler(
      OtpSubmitted event, Emitter<OtpState> emit) async {
    await _commonHandler(
      handlerJob: () async {
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
      },
      emit: emit,
    );
  }

  void _resetFormStatusHandler(
          ResetOtpFormStatus event, Emitter<OtpState> emit) =>
      emit(
        state.copyWith(
          blocStatus: const Idle(),
        ),
      );
}
