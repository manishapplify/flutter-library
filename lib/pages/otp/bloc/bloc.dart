import 'package:bloc/bloc.dart';
import 'package:components/Authentication/form_submission.dart';
import 'package:components/Authentication/repo.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const OtpState()) {
    on<OtpChanged>(_onOtpChangedHandler);
    on<OtpSubmitted>(_onForgotPasswordSubmittedHandler);
  }

  final AuthRepository _authRepository;

  void _onOtpChangedHandler(OtpChanged event, Emitter<OtpState> emit) => emit(
        state.copyWith(otp: event.otp, formStatus: const InitialFormStatus()),
      );

  void _onForgotPasswordSubmittedHandler(
      OtpSubmitted event, Emitter<OtpState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    if (state.isOtpValid) {
      try {
        await _authRepository.verifyForgetPasswordOtp(state.otp!);
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } on Exception catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(exception: e)));
      }
    } else {
      emit(state.copyWith(formStatus: SubmissionFailed()));
    }
  }
}
