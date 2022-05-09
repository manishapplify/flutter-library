part of blocs;

class ResetPasswordBloc
    extends BaseBloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const ResetPasswordState()) {
    on<ResetNewPasswordChanged>(_onResetNewPasswordChangedHandler);
    on<ResetConfirmNewPasswordChanged>(_onConfirmNewPasswordChangedHandler);
    on<ResetPasswordSubmitted>(_onResetPasswordSubmittedHandler);
    on<ResetResetPasswordFormState>(
        (ResetResetPasswordFormState event, Emitter<ResetPasswordState> emit) {
      emit(const ResetPasswordState());
    });
  }
  final AuthRepository _authRepository;

  void _onResetNewPasswordChangedHandler(
          ResetNewPasswordChanged event, Emitter<ResetPasswordState> emit) =>
      emit(
        state.copyWith(
            newPassword: event.newPassword, blocStatus: const Idle()),
      );
  void _onConfirmNewPasswordChangedHandler(ResetConfirmNewPasswordChanged event,
          Emitter<ResetPasswordState> emit) =>
      emit(
        state.copyWith(
            confirmNewPassword: event.confirmNewPassword,
            blocStatus: const Idle()),
      );

  void _onResetPasswordSubmittedHandler(
      ResetPasswordSubmitted event, Emitter<ResetPasswordState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        await _authRepository.resetPassword(state.newPassword);
      },
      emit: emit,
    );
  }
}
