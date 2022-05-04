import 'package:bloc/bloc.dart';
import 'package:components/common/work_status.dart';
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
    on<QueryChangedEvent>(_queryChangedEventHandler);
    on<ResetChatState>(_resetChatStateHandler);
  }

  final FirebaseRealtimeDatabase _firebaseRealtimeDatabase;
  final AuthCubit _authCubit;
  final String imageBaseUrl;

  void _getUsersEventHandler(
      GetUsersEvent event, Emitter<UsersState> emit) async {
    emit(state.copyWith(blocStatus: InProgress()));
    await _commonHandler(
      handlerJob: () async {
        final List<FirebaseUser> users =
            await _firebaseRealtimeDatabase.getUsers();
        if (!_authCubit.state.isAuthorized) {
          throw AppException.authenticationException();
        }

        // Don't show self in the list.
        final String currentUserId = _authCubit.state.user!.firebaseId;
        users.removeWhere((FirebaseUser user) => user.id == currentUserId);

        emit(state.copyWith(
          users: users,
          usersMatchingQuery: users,
          blocStatus: Success(),
        ));
      },
      onFailure: (WorkStatus status) {
        emit(
          state.copyWith(
            blocStatus: status,
          ),
        );
      },
      emit: emit,
    );
  }

  void _messageIconTapHandler(
      MessageIconTapEvent event, Emitter<UsersState> emit) async {
    emit(state.copyWith(chatStatus: InProgress()));
    await _commonHandler(
      handlerJob: () async {
        final FirebaseChat chat =
            await _firebaseRealtimeDatabase.addChatIfNotExists(
          firebaseUserA: event.firebaseUserA,
          firebaseUserB: event.firebaseUserB,
        );

        emit(state.copyWith(
          chat: chat,
          chatStatus: Success(),
        ));
      },
      onFailure: (WorkStatus status) {
        emit(
          state.copyWith(
            chatStatus: status,
          ),
        );
      },
      emit: emit,
    );
  }

  void _queryChangedEventHandler(
      QueryChangedEvent event, Emitter<UsersState> emit) {
    final List<FirebaseUser> usersMatchingQuery = event.query.isEmpty
        ? state.users
        : state.users
            .where((FirebaseUser user) =>
                user.name?.toLowerCase().contains(event.query.toLowerCase()) ??
                false)
            .toList();

    emit(
      state.copyWith(
        usersMatchingQuery: usersMatchingQuery,
      ),
    );
  }

  Future<void> _commonHandler(
      {required Future<void> Function() handlerJob,
      required Function(WorkStatus status) onFailure,
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

      onFailure(
        Failure(
          exception: exception,
          message: exception.message,
        ),
      );
    } on AppException catch (e) {
      onFailure(Failure(exception: e, message: e.message));
    } on Exception catch (_) {
      onFailure(Failure(exception: Exception('Failure')));
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
