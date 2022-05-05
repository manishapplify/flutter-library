part of blocs;

class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  LoginBloc({
    required Api api,
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const LoginState()) {
    on<LoginEmailChanged>(_loginEmailChangedHandler);
    on<LoginPasswordChanged>(_loginPasswordChangedHandler);
    on<LoginSubmitted>(_loginEventHandler);
    on<GoogleSignInSummitted>(_googleLoginEventHandler);
    on<FacebookSignInSummitted>(_facebookLoginEventHandler);
    on<AppleSignInSummitted>(_appleLoginEventHandler);
    on<ResetLoginBlocStatus>(_resetFormStatusHandler);
  }

  final AuthRepository _authRepository;

  void _resetFormStatusHandler(
          ResetLoginBlocStatus event, Emitter<LoginState> emit) =>
      emit(state.copyWith(blocStatus: const Idle()));

  void _loginEmailChangedHandler(
      LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        email: event.email,
      ),
    );
  }

  void _loginPasswordChangedHandler(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        password: event.password,
      ),
    );
  }

  void _loginEventHandler(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        await _authRepository.login(
          username: state.email,
          password: state.password,
        );
      },
      emit: emit,
    );
  }

  void _googleLoginEventHandler(
      GoogleSignInSummitted event, Emitter<LoginState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        await _authRepository.signInWithGoogle();
      },
      emit: emit,
    );
  }

  void _facebookLoginEventHandler(
      FacebookSignInSummitted event, Emitter<LoginState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        await _authRepository.signInWithFacebook();
      },
      emit: emit,
    );
  }

  void _appleLoginEventHandler(
      AppleSignInSummitted event, Emitter<LoginState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        await _authRepository.signInWithApple();
      },
      emit: emit,
    );
  }
}
