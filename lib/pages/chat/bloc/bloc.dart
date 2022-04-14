import 'dart:async';

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
  })  : _authCubit = authCubit,
        _firebaseRealtimeDatabase = firebaseRealtimeDatabase,
        super(const ChatState()) {
    on<GetChatsEvent>(_getChatsEventHandler);
    on<GetChatSubscriptionsEvent>(_getChatSubscriptionsEventHandler);
    on<RemoveChatEvent>(_removeChatEventHandler);
    on<ChatOpenedEvent>(_chatOpenedEventHandler);
    on<GetCurrentChatMessagesEvent>(_getCurrentChatMessagesEventHandler);
    on<_OnMessagesEvent>(_onMessagesEventHandler);
    on<TextMessageChanged>(_textMessageChangedHandler);
    on<_ClearTextMessageEvent>(_clearTextMessageEventHandler);
    on<SendTextEvent>(_sendTextEventHandler);
    on<SendImageEvent>(_sendImageEventHandler);
    on<SendDocEvent>(_sendDocEventHandler);
    on<ResetBlocStatus>(_resetBlocStatusHandler);
    on<ChatPagePopEvent>(_chatPagePopEventHandler);
    on<ResetBlocState>(_resetBlocStateHandler);
    on<ViewDisposeEvent>(_viewDisposeEventHandler);
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
            final Set<FirebaseChat> chats =
                await _firebaseRealtimeDatabase.getChats(firebaseUser.chatIds!);

            emit(state.copyWith(chats: chats));
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

  void _getChatSubscriptionsEventHandler(
      GetChatSubscriptionsEvent event, Emitter<ChatState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        if (!_authCubit.state.isAuthorized) {
          throw AppException.authenticationException;
        }

        final FirebaseUser? firebaseUser = await _firebaseRealtimeDatabase
            .getFirebaseUser(user: _authCubit.state.user);

        if (firebaseUser is FirebaseUser &&
            firebaseUser.chatIds is Set<String> &&
            firebaseUser.chatIds!.isNotEmpty) {
          final Map<String, Stream<Set<FirebaseMessage>>> messageStreams =
              _firebaseRealtimeDatabase
                  .getChatMessagesSubscription(firebaseUser.chatIds!);

          final List<StreamSubscription<Set<FirebaseMessage>>> subscriptions =
              <StreamSubscription<Set<FirebaseMessage>>>[];

          for (final MapEntry<String, Stream<Set<FirebaseMessage>>> mapEntry
              in messageStreams.entries) {
            final StreamSubscription<Set<FirebaseMessage>> subscription =
                mapEntry.value.listen((Set<FirebaseMessage> messages) {
              add(_OnMessagesEvent(chatId: mapEntry.key, messages: messages));
            });

            subscriptions.add(subscription);
          }

          emit(state.copyWith(
            subscriptions: subscriptions,
            messagesStream: messageStreams,
          ));
        }
      },
      emit: emit,
      emitFailureOnly: true,
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

  void _chatOpenedEventHandler(
      ChatOpenedEvent event, Emitter<ChatState> emit) async {
    emit(
      state.copyWith(
        currentChat: event.chat,
      ),
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

  void _onMessagesEventHandler(
      _OnMessagesEvent event, Emitter<ChatState> emit) {
    if (state.currentChat != null && event.chatId == state.currentChat!.id) {
      emit(state.copyWith(messages: event.messages));
    }
  }

  void _textMessageChangedHandler(
      TextMessageChanged event, Emitter<ChatState> emit) {
    emit(state.copyWith(message: event.message));
  }

  void _clearTextMessageEventHandler(
      _ClearTextMessageEvent event, Emitter<ChatState> emit) {
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

          _firebaseRealtimeDatabase.sendMessage(
            textMessage: state.message,
            chatId: state.currentChat!.id,
            senderId: _authCubit.state.user!.firebaseId,
          );

          add(_ClearTextMessageEvent());
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

  void _chatPagePopEventHandler(
      ChatPagePopEvent event, Emitter<ChatState> emit) {
    emit(ChatState(
      chats: state.chats,
      messagesStream: state.messagesStream,
      subscriptions: state.subscriptions,
    ));
  }

  void _resetBlocStateHandler(ResetBlocState event, Emitter<ChatState> emit) {
    emit(ChatState(
      messagesStream: state.messagesStream,
      subscriptions: state.subscriptions,
    ));
  }

  void _viewDisposeEventHandler(
      ViewDisposeEvent event, Emitter<ChatState> emit) {
    for (final StreamSubscription<Set<FirebaseMessage>> subscription
        in state.subscriptions) {
      subscription.cancel();
    }

    emit(state.copyWith(
      messagesStream: <String, Stream<Set<FirebaseMessage>>>{},
      subscriptions: <StreamSubscription<Set<FirebaseMessage>>>[],
    ));
  }

  Future<void> _commonHandler({
    required Future<void> Function() handlerJob,
    required Emitter<ChatState> emit,
    bool emitFailureOnly = false,
  }) async {
    if (!emitFailureOnly) {
      emit(state.copyWith(blocStatus: FormSubmitting()));
    }

    try {
      await handlerJob();
      if (!emitFailureOnly) {
        emit(state.copyWith(blocStatus: SubmissionSuccess()));
      }
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
