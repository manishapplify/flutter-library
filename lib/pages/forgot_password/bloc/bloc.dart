part of blocs;

class ForgotPasswordBloc
    extends BaseBloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    required Persistence persistence,
    required AuthRepository authRepository,
  })  : _persistence = persistence,
        _authRepository = authRepository,
        super(const ForgotPasswordState()) {
    on<EmailChanged>(_onEmailChangedHandler);
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmittedHandler);
    on<ResetForgotPasswordFormStatus>(_resetFormStatusHandler);
  }

  final Persistence _persistence;
  final AuthRepository _authRepository;

  void _onEmailChangedHandler(
          EmailChanged event, Emitter<ForgotPasswordState> emit) =>
      emit(
        state.copyWith(email: event.email, blocStatus: const Idle()),
      );

  void _onForgotPasswordSubmittedHandler(
      ForgotPasswordSubmitted event, Emitter<ForgotPasswordState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        final ForgotPasswordRequest request = ForgotPasswordRequest(
          email: state.email,
          countryCode: _persistence.fetchCountryCode() ?? '+91',
          phoneNumber: null,
        );
        await _authRepository.forgotPassword(request);
      },
      emit: emit,
    );
  }

  void _resetFormStatusHandler(ResetForgotPasswordFormStatus event,
          Emitter<ForgotPasswordState> emit) =>
      emit(
        state.copyWith(
          blocStatus: const Idle(),
        ),
      );
}
