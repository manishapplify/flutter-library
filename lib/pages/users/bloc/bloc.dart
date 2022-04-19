import 'package:bloc/bloc.dart';
import 'package:components/Authentication/form_submission.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/services/firebase_realtime_database/firebase_realtime_database.dart';
import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:components/services/firebase_realtime_database/models/user.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

part 'event.dart';
part 'state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc({
    required FirebaseRealtimeDatabase firebaseRealtimeDatabase,
    required AuthCubit authCubit,
    required this.imageBaseUrl,
  })  : _firebaseRealtimeDatabase = firebaseRealtimeDatabase,
        _authCubit = authCubit,
        super(const UsersState()) {
    on<GetUsersEvent>(_getUsersEventHandler);
    on<MessageIconTapEvent>(_messageIconTapHandler);
    on<ResetChatState>(_resetChatStateHandler);
  }

  final FirebaseRealtimeDatabase _firebaseRealtimeDatabase;
  final AuthCubit _authCubit;
  final String imageBaseUrl;

  void _getUsersEventHandler(
      GetUsersEvent event, Emitter<UsersState> emit) async {
    emit(state.copyWith(blocStatus: FormSubmitting()));
    await _commonHandler(
      handlerJob: () async {
        final List<FirebaseUser> users =
            await _firebaseRealtimeDatabase.getUsers();
        if (!_authCubit.state.isAuthorized) {
          throw AppException.authenticationException;
        }

        // Don't show self in the list.
        final String currentUserId = _authCubit.state.user!.firebaseId;
        users.removeWhere((FirebaseUser user) => user.id == currentUserId);

        emit(state.copyWith(
          users: users,
          blocStatus: SubmissionSuccess(),
        ));
      },
      onFailure: () {
        emit(
          state.copyWith(
            blocStatus: SubmissionFailed(exception: Exception('Failure')),
          ),
        );
      },
      emit: emit,
    );
  }

  void _messageIconTapHandler(
      MessageIconTapEvent event, Emitter<UsersState> emit) async {
    emit(state.copyWith(chatStatus: FormSubmitting()));
    await _commonHandler(
      handlerJob: () async {
        final FirebaseChat chat =
            await _firebaseRealtimeDatabase.addChatIfNotExists(
          firebaseUserA: event.firebaseUserA,
          firebaseUserB: event.firebaseUserB,
        );

        emit(state.copyWith(
          chat: chat,
          chatStatus: SubmissionSuccess(),
        ));
      },
      onFailure: () {
        emit(
          state.copyWith(
            chatStatus: SubmissionFailed(exception: Exception('Failure')),
          ),
        );
      },
      emit: emit,
    );
  }

  Future<void> _commonHandler(
      {required Future<void> Function() handlerJob,
      required Function() onFailure,
      required Emitter<UsersState> emit}) async {
    try {
      await handlerJob();
    } on DioError catch (e) {
      late final AppException exception;

      if (e.type == DioErrorType.other && e.error is AppException) {
        exception = e.error;
      } else {
        exception = AppException.api400Exception();
      }

      emit(
        state.copyWith(
          blocStatus: SubmissionFailed(
            exception: exception,
            message: exception.message,
          ),
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(
          blocStatus: SubmissionFailed(exception: e, message: e.message)));
    } on Exception catch (_) {
      onFailure();
    }
  }

  void _resetChatStateHandler(
      ResetChatState event, Emitter<UsersState> emit) async {
    emit(
      UsersState(
        blocStatus: state.blocStatus,
        users: state.users,
      ),
    );
  }
}
