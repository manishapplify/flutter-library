import 'package:bloc/bloc.dart';
import 'package:components/authentication/form_submission.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/services/firebase_realtime_database/firebase_realtime_database.dart';
import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:components/services/firebase_realtime_database/models/message.dart';
import 'package:components/services/firebase_realtime_database/models/user.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required this.imageBaseUrl,
    required AuthCubit authCubit,
    required FirebaseRealtimeDatabase firebaseRealtimeDatabase,
    FirebaseChat? currentChat,
  })  : _authCubit = authCubit,
        _firebaseRealtimeDatabase = firebaseRealtimeDatabase,
        super(
          ChatState(currentChat: currentChat),
        ) {
    on<GetChatsEvent>(_getChatsEventHandler);
    on<RemoveChatEvent>(_removeChatEventHandler);
    on<GetCurrentChatMessagesEvent>(_getCurrentChatMessagesEventHandler);
    on<TextMessageChanged>(_textMessageChangedHandler);
    on<ClearTextMessageEvent>(_clearTextMessageEventHandler);
    on<SendTextEvent>(_sendTextEventHandler);
    on<SendImageEvent>(_sendImageEventHandler);
    on<SendDocEvent>(_sendDocEventHandler);
    on<ResetBlocStatus>(_resetBlocStatusHandler);
  }

  final String imageBaseUrl;
  final AuthCubit _authCubit;
  final FirebaseRealtimeDatabase _firebaseRealtimeDatabase;

  void _getChatsEventHandler(
      GetChatsEvent event, Emitter<ChatState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        if (!_authCubit.state.isAuthorized) {
          throw AppException.authenticationException;
        }

        final FirebaseUser? firebaseUser = await _firebaseRealtimeDatabase
            .getFirebaseUser(user: _authCubit.state.user);

        if (firebaseUser is FirebaseUser) {
          if (firebaseUser.chatIds is Set<String> &&
              firebaseUser.chatIds!.isNotEmpty) {
            emit(
              state.copyWith(
                chats: await _firebaseRealtimeDatabase
                    .getChats(firebaseUser.chatIds!),
              ),
            );
          } else {
            throw AppException.noChatsPresent();
          }
        } else {
          throw AppException.couldNotLoadChats();
        }
      },
      emit: emit,
    );
  }

  void _removeChatEventHandler(
      RemoveChatEvent event, Emitter<ChatState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        await _firebaseRealtimeDatabase.removeChat(
          chat: event.chat,
        );

        emit(
          state.copyWith(
            chats: state.chats
              ..removeWhere(
                (FirebaseChat chat) => chat.id == event.chat.id,
              ),
          ),
        );
      },
      emit: emit,
    );
  }

  void _getCurrentChatMessagesEventHandler(
      GetCurrentChatMessagesEvent event, Emitter<ChatState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        final Set<FirebaseMessage> messages =
            await _firebaseRealtimeDatabase.getMessages(state.currentChat!.id);

        emit(
          state.copyWith(
            messages: messages,
          ),
        );
      },
      emit: emit,
    );
  }

  void _textMessageChangedHandler(
      TextMessageChanged event, Emitter<ChatState> emit) {
    emit(state.copyWith(message: event.message));
  }

  void _clearTextMessageEventHandler(
      ClearTextMessageEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(message: ''));
  }

  void _sendTextEventHandler(
      SendTextEvent event, Emitter<ChatState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        if (state.message.isNotEmpty) {
          if (!_authCubit.state.isAuthorized) {
            throw AppException.authenticationException;
          }

          final FirebaseMessage message =
              await _firebaseRealtimeDatabase.sendMessage(
            textMessage: state.message,
            chatId: state.currentChat!.id,
            senderId: _authCubit.state.user!.firebaseId,
          );

          emit(
            state.copyWith(
              messages: state.messages..add(message),
            ),
          );
          add(ClearTextMessageEvent());
        } else {
          throw AppException.messageCannotBeEmpty();
        }
      },
      emit: emit,
    );
  }

  void _sendImageEventHandler(SendImageEvent event, Emitter<ChatState> emit) {
    // TODO: Implement handler
    throw UnimplementedError();
  }

  void _sendDocEventHandler(SendDocEvent event, Emitter<ChatState> emit) {
    // TODO: Implement handler
    throw UnimplementedError();
  }

  void _resetBlocStatusHandler(ResetBlocStatus event, Emitter<ChatState> emit) {
    emit(state.copyWith(blocStatus: const InitialFormStatus()));
  }

  Future<void> _commonHandler(
      {required Future<void> Function() handlerJob,
      required Emitter<ChatState> emit}) async {
    emit(state.copyWith(blocStatus: FormSubmitting()));

    try {
      await handlerJob();
      emit(state.copyWith(blocStatus: SubmissionSuccess()));
    } on AppException catch (e) {
      emit(state.copyWith(
          blocStatus: SubmissionFailed(exception: e, message: e.message)));
    } on Exception catch (_) {
      emit(
        state.copyWith(
          blocStatus: SubmissionFailed(exception: Exception('Failure')),
        ),
      );
    }
  }
}
