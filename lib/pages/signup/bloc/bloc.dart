part of blocs;

class SignUpBloc extends BaseBloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    required AuthRepository authRepository,
    required AuthCubit authCubit,
  })  : _authRepo = authRepository,
        super(const SignUpState()) {
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
        blocStatus: const Idle(),
      ),
    );
  }

  void _signUpPhoneNumberChangedHandler(
      SignUpPhoneNumberChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        blocStatus: const Idle(),
      ),
    );
  }

  void _signUpEmailChangedHandler(
      SignUpEmailChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        blocStatus: const Idle(),
      ),
    );
  }

  void _signUpPasswordChangedHandler(
      SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        password: event.password,
        blocStatus: const Idle(),
      ),
    );
  }

  void _signConfirmPasswordChangedHandler(
      SignUpConfirmPasswordChanged event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        confirmPassword: event.confirmPassword,
        blocStatus: const Idle(),
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

}
