library blocs;

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/common/app_exception.dart';
import 'package:components/common/config.dart';
import 'package:components/common/validators.dart' as validators;
import 'package:components/common/work_status.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/enums/gender.dart';
import 'package:components/enums/screen.dart';
import 'package:components/enums/signup.dart';
import 'package:components/pages/feedback/models/request.dart';
import 'package:components/pages/forgot_password/models/request.dart';
import 'package:components/pages/profile/repo.dart';
import 'package:components/pages/report_bug/models/request.dart';
import 'package:components/pages/splash/models/response.dart';
import 'package:components/services/api/api.dart';
import 'package:components/services/firebase_realtime_database/firebase_realtime_database.dart';
import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:components/services/firebase_realtime_database/models/message/document_message.dart';
import 'package:components/services/firebase_realtime_database/models/message/image_message.dart';
import 'package:components/services/firebase_realtime_database/models/message/message.dart';
import 'package:components/services/firebase_realtime_database/models/message/text_message.dart';
import 'package:components/services/firebase_realtime_database/models/user.dart';
import 'package:components/services/firebase_storage_service.dart';
import 'package:components/services/persistence.dart';
import 'package:components/services/s3_image_upload/s3_image_upload.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

// LoginPage
part 'package:components/pages/login/bloc/bloc.dart';
part 'package:components/pages/login/bloc/event.dart';
part 'package:components/pages/login/bloc/state.dart';
// SplashPage
part 'package:components/pages/splash/bloc/bloc.dart';
part 'package:components/pages/splash/bloc/event.dart';
part 'package:components/pages/splash/bloc/state.dart';
// ChangePassWordPage
part 'package:components/pages/change_password/bloc/bloc.dart';
part 'package:components/pages/change_password/bloc/event.dart';
part 'package:components/pages/change_password/bloc/state.dart';
// ForgotPassWordPage
part 'package:components/pages/forgot_password/bloc/bloc.dart';
part 'package:components/pages/forgot_password/bloc/event.dart';
part 'package:components/pages/forgot_password/bloc/state.dart';
// ResetPassWordPage
part 'package:components/pages/reset_password/bloc/bloc.dart';
part 'package:components/pages/reset_password/bloc/event.dart';
part 'package:components/pages/reset_password/bloc/state.dart';
// OtpPage
part 'package:components/pages/otp/bloc/bloc.dart';
part 'package:components/pages/otp/bloc/event.dart';
part 'package:components/pages/otp/bloc/state.dart';
// FeedbackPage
part 'package:components/pages/feedback/bloc/bloc.dart';
part 'package:components/pages/feedback/bloc/event.dart';
part 'package:components/pages/feedback/bloc/state.dart';
// ReportBugPage
part 'package:components/pages/report_bug/bloc/bloc.dart';
part 'package:components/pages/report_bug/bloc/event.dart';
part 'package:components/pages/report_bug/bloc/state.dart';
// SignupPage
part 'package:components/pages/signup/bloc/bloc.dart';
part 'package:components/pages/signup/bloc/event.dart';
part 'package:components/pages/signup/bloc/state.dart';
// UsersPage
part 'package:components/pages/users/bloc/bloc.dart';
part 'package:components/pages/users/bloc/event.dart';
part 'package:components/pages/users/bloc/state.dart';
// ChatPage
part 'package:components/pages/chat/bloc/bloc.dart';
part 'package:components/pages/chat/bloc/event.dart';
part 'package:components/pages/chat/bloc/state.dart';
// Profile
part 'package:components/pages/profile/bloc/bloc.dart';
part 'package:components/pages/profile/bloc/event.dart';
part 'package:components/pages/profile/bloc/state.dart';
abstract class BaseBloc<E extends BaseEvent, S extends BaseState>
    extends Bloc<E, S> {
  BaseBloc(S initialState) : super(initialState);

  /// Hosts the common logic of exception handling.
  ///
  /// [handlerJob] : Specific job of the handler.
  /// [emit] : Emmiter to be used for sending status updates.
  /// [emitFailureOnly] : If set to `true`, will only provide status updates on failure.
  /// [onFailure] : Callback to be used when status other than [blocStatus] is to be updated.
  Future<void> _commonHandler({
    required Future<void> Function() handlerJob,
    required Emitter<BaseState> emit,
    bool emitFailureOnly = false,
    Function(WorkStatus status)? onFailure,
  }) async {
    // _handleFailure should not be inherited.
    // ignore: prefer_function_declarations_over_variables
    final Function(Failure) _handleFailure = (Failure failure) {
      if (onFailure == null) {
        emit(state.updateStatus(failure));
      } else {
        onFailure(failure);
      }
    };

    try {
      if (!emitFailureOnly) {
        emit(state.updateStatus(InProgress()));
      }

      await handlerJob();
      if (!emitFailureOnly) {
        emit(state.updateStatus(Success()));
      }
    } on DioError catch (e) {
      late final AppException exception;

      if (e.type == DioErrorType.other && e.error is AppException) {
        exception = e.error;
      } else {
        exception = AppException.api400Exception();
      }

      final Failure failure = Failure(
        exception: exception,
        message: exception.message,
      );
      _handleFailure(failure);
    } on AppException catch (e) {
      final Failure failure = Failure(exception: e, message: e.message);
      _handleFailure(failure);
    } on Exception catch (_) {
      final Failure failure = Failure(exception: Exception('Failure'));
      _handleFailure(failure);
    } on Error catch (_) {
      final Failure failure = Failure(exception: Exception('Failure'));
      _handleFailure(failure);
    }
  }
}

@immutable
abstract class BaseEvent {}

@immutable
abstract class BaseState {
  const BaseState(this.blocStatus);

  final WorkStatus blocStatus;

  BaseState updateStatus(WorkStatus blocStatus);

  BaseState resetState();
}
