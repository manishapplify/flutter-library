import 'package:bloc/bloc.dart';
import 'package:components/common_models/form_submission.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/pages/forgot_password/models/request.dart';
import 'package:components/services/persistence.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:components/validators/validators.dart' as validators;

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
    on<ResetFormStatus>(_resetFormStatusHandler);
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
      late final AppException exception;

      if (e.type == DioErrorType.other && e.error is AppException) {
        exception = e.error;
      } else {
        exception = AppException.api400Exception();
      }

      emit(
        state.copyWith(
          formStatus: SubmissionFailed(
            exception: exception,
            message: exception.message,
          ),
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(
          formStatus: SubmissionFailed(exception: e, message: e.message)));
    } on Exception catch (_) {
      emit(
        state.copyWith(
          formStatus: SubmissionFailed(exception: Exception('Failure')),
        ),
      );
    }
  }

  void _resetFormStatusHandler(
          ResetFormStatus event, Emitter<ForgotPasswordState> emit) =>
      emit(
        state.copyWith(
          formStatus: const InitialFormStatus(),
        ),
      );
}
