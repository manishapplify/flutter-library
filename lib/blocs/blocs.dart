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
import 'package:components/services/image_cropping_service.dart';
import 'package:components/services/image_picking_service.dart';
import 'package:components/services/local_notification_service.dart';
import 'package:components/services/persistence.dart';
import 'package:components/services/s3_image_upload/s3_image_upload.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'package:components/blocs/image_manipulation.dart';

// ChangePassWordPage
part 'package:components/pages/change_password/bloc/bloc.dart';
part 'package:components/pages/change_password/bloc/event.dart';
part 'package:components/pages/change_password/bloc/state.dart';
// ChatPage
part 'package:components/pages/chat/bloc/bloc.dart';
part 'package:components/pages/chat/bloc/event.dart';
part 'package:components/pages/chat/bloc/state.dart';
// FeedbackPage
part 'package:components/pages/feedback/bloc/bloc.dart';
part 'package:components/pages/feedback/bloc/event.dart';
part 'package:components/pages/feedback/bloc/state.dart';
// ForgotPassWordPage
part 'package:components/pages/forgot_password/bloc/bloc.dart';
part 'package:components/pages/forgot_password/bloc/event.dart';
part 'package:components/pages/forgot_password/bloc/state.dart';
// HomePage
part 'package:components/pages/home/bloc/bloc.dart';
part 'package:components/pages/home/bloc/event.dart';
part 'package:components/pages/home/bloc/state.dart';
// LoginPage
part 'package:components/pages/login/bloc/bloc.dart';
part 'package:components/pages/login/bloc/event.dart';
part 'package:components/pages/login/bloc/state.dart';
// NotificationPage
part 'package:components/pages/notifications/bloc/bloc.dart';
part 'package:components/pages/notifications/bloc/event.dart';
part 'package:components/pages/notifications/bloc/state.dart';
// OtpPage
part 'package:components/pages/otp/bloc/bloc.dart';
part 'package:components/pages/otp/bloc/event.dart';
part 'package:components/pages/otp/bloc/state.dart';
// Profile
part 'package:components/pages/profile/bloc/bloc.dart';
part 'package:components/pages/profile/bloc/event.dart';
part 'package:components/pages/profile/bloc/state.dart';
// ReportBugPage
part 'package:components/pages/report_bug/bloc/bloc.dart';
part 'package:components/pages/report_bug/bloc/event.dart';
part 'package:components/pages/report_bug/bloc/state.dart';
// ResetPassWordPage
part 'package:components/pages/reset_password/bloc/bloc.dart';
part 'package:components/pages/reset_password/bloc/event.dart';
part 'package:components/pages/reset_password/bloc/state.dart';
// SignupPage
part 'package:components/pages/signup/bloc/bloc.dart';
part 'package:components/pages/signup/bloc/event.dart';
part 'package:components/pages/signup/bloc/state.dart';
// SplashPage
part 'package:components/pages/splash/bloc/bloc.dart';
part 'package:components/pages/splash/bloc/event.dart';
part 'package:components/pages/splash/bloc/state.dart';
// UsersPage
part 'package:components/pages/users/bloc/bloc.dart';
part 'package:components/pages/users/bloc/event.dart';
part 'package:components/pages/users/bloc/state.dart';

abstract class BaseBloc<E extends BaseEvent, S extends BaseState>
    extends Bloc<E, S> {
  BaseBloc(S initialState) : super(initialState);

  /// Hosts the common logic of exception handling.
  ///
  /// [handlerJob] : Specific job of the handler.
  /// [emit] : Emmiter to be used for sending status updates.
  /// [emitFailureOnly] : If set to `true`, will only provide status updates on failure.
  /// [onStatusUpdate] : Callback to be used when status other than [blocStatus] is to be updated.
  Future<void> _commonHandler({
    required Future<void> Function() handlerJob,
    required Emitter<BaseState> emit,
    bool emitFailureOnly = false,
    Function(WorkStatus status)? onStatusUpdate,
  }) async {
    // _handleStatusUpdate should not be inherited.
    // ignore: prefer_function_declarations_over_variables
    final Function(WorkStatus) _handleStatusUpdate = (WorkStatus workStatus) {
      if (onStatusUpdate == null) {
        emit(state.updateStatus(workStatus));
      } else {
        onStatusUpdate(workStatus);
      }
    };

    try {
      if (!emitFailureOnly) {
        _handleStatusUpdate(InProgress());
      }

      await handlerJob();
      if (!emitFailureOnly) {
        _handleStatusUpdate(Success());
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
      _handleStatusUpdate(failure);
    } on AppException catch (e) {
      final Failure failure = Failure(exception: e, message: e.message);
      _handleStatusUpdate(failure);
    } on Exception catch (_) {
      final Failure failure = Failure(exception: Exception('Failure'));
      _handleStatusUpdate(failure);
    } on Error catch (_) {
      final Failure failure = Failure(exception: Exception('Failure'));
      _handleStatusUpdate(failure);
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
