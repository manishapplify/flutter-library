library blocs;

import 'package:bloc/bloc.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/common/app_exception.dart';
import 'package:components/common/config.dart';
import 'package:components/common/validators.dart' as validators;
import 'package:components/common/work_status.dart';
import 'package:components/pages/splash/models/response.dart';
import 'package:components/services/api/api.dart';
import 'package:dio/dio.dart';
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
      if (onFailure == null) {
        emit(state.updateStatus(failure));
      } else {
        onFailure(failure);
      }
    } on AppException catch (e) {
      final Failure failure = Failure(exception: e, message: e.message);
      if (onFailure == null) {
        emit(state.updateStatus(failure));
      } else {
        onFailure(failure);
      }
    } on Exception catch (_) {
      final Failure failure = Failure(exception: Exception('Failure'));
      if (onFailure == null) {
        emit(state.updateStatus(failure));
      } else {
        onFailure(failure);
      }
    } on Error catch (_) {
      final Failure failure = Failure(exception: Exception('Failure'));
      if (onFailure == null) {
        emit(state.updateStatus(failure));
      } else {
        onFailure(failure);
      }
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
