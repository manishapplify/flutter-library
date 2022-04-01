import 'package:bloc/bloc.dart';
import 'package:components/Authentication/form_submission.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/pages/forgot_password/models/request.dart';
import 'package:components/services/persistence.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    required Persistence persistence,
    required AuthRepository authRepository,
  })  : _persistence = persistence,
        _authRepository = authRepository,
        super(const ForgotPasswordState()) {
    on<EmailChanged>(_onEmailChangedHandler);
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmittedHandler);
  }

  final Persistence _persistence;
  final AuthRepository _authRepository;

  void _onEmailChangedHandler(
          EmailChanged event, Emitter<ForgotPasswordState> emit) =>
      emit(
        state.copyWith(
            email: event.email, formStatus: const InitialFormStatus()),
      );

  void _onForgotPasswordSubmittedHandler(
      ForgotPasswordSubmitted event, Emitter<ForgotPasswordState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    final ForgotPasswordRequest request = ForgotPasswordRequest(
      email: state.email,
      countryCode: _persistence.fetchCountryCode() ?? '+91',
      phoneNumber: null,
    );

    try {
      await _authRepository.forgotPassword(request);
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } on DioError catch (e) {
      emit(
        state.copyWith(
          formStatus: SubmissionFailed(
            exception: e,
            message: e.error,
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
  }
}
