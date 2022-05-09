part of blocs;

class ChangePasswordBloc
    extends BaseBloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc({
    required Api api,
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const ChangePasswordState()) {
    on<CurrentPasswordChanged>(_currentPasswordChangedHandler);
    on<NewPasswordChanged>(_newPasswordChangedHandler);
    on<ConfirmNewPasswordChanged>(_confirmNewPasswordChangedHandler);
    on<ResetFormState>(
        (ResetFormState event, Emitter<ChangePasswordState> emit) {
      emit(const ChangePasswordState());
    });
    on<ResetChangePasswordBlocStatus>(_resetChangePasswordBlocStatusHandler);
    on<ChangePasswordSubmitted>(_changePasswordEventHandler);
  }

  final AuthRepository _authRepository;

  void _currentPasswordChangedHandler(
      CurrentPasswordChanged event, Emitter<ChangePasswordState> emit) {
    emit(
      state.copyWith(
        currentPassword: event.currentPassword,
        blocStatus: const Idle(),
      ),
    );
  }

  void _newPasswordChangedHandler(
      NewPasswordChanged event, Emitter<ChangePasswordState> emit) {
    emit(
      state.copyWith(
        newPassword: event.newPassword,
        blocStatus: const Idle(),
      ),
    );
  }

  void _confirmNewPasswordChangedHandler(
      ConfirmNewPasswordChanged event, Emitter<ChangePasswordState> emit) {
    emit(
      state.copyWith(
        confirmNewPassword: event.confirmNewPassword,
        blocStatus: const Idle(),
      ),
    );
  }

  void _changePasswordEventHandler(
      ChangePasswordSubmitted event, Emitter<ChangePasswordState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        await _authRepository.changePassword(
          currentPassword: state.currentPassword,
          newPassword: state.newPassword,
        );
      },
      emit: emit,
    );
  }

  void _resetChangePasswordBlocStatusHandler(
          ResetChangePasswordBlocStatus event,
          Emitter<ChangePasswordState> emit) =>
      emit(
        state.copyWith(
          blocStatus: const Idle(),
        ),
      );
}
