import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:components/authentication/form_submission.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/services/firebase_realtime_database/firebase_realtime_database.dart';
import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:components/services/firebase_realtime_database/models/message.dart';
import 'package:components/services/firebase_realtime_database/models/user.dart';
import 'package:components/services/firebase_storage_services.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required this.imageBaseUrl,
    required AuthCubit authCubit,
    required FirebaseRealtimeDatabase firebaseRealtimeDatabase,
    required FirebaseStorageServices firebaseStorageServices,
  })  : _authCubit = authCubit,
        _firebaseRealtimeDatabase = firebaseRealtimeDatabase,
        _firebaseStorageServices = firebaseStorageServices,
        super(const ChatState()) {
    on<GetChatsEvent>(_getChatsEventHandler);
    on<GetChatsSubscriptionEvent>(_getChatsSubscriptionEventHandler);
    on<_OnChatsEvent>(_onChatsEventHandler);
    on<RemoveChatEvent>(_removeChatEventHandler);
    on<ChatOpenedEvent>(_chatOpenedEventHandler);
    on<GetCurrentChatMessagesEvent>(_getCurrentChatMessagesEventHandler);
    on<ResetCurrentChatMessagesFetched>(
        _resetCurrentChatMessagesFetchedHandler);
    on<GetMessageSubscriptionsEvent>(_getMessageSubscriptionsEventHandler);
    on<_OnMessagesEvent>(_onMessagesEventHandler);
    on<ResetCurrentChatNewMessageReceived>(
        _resetCurrentChatNewMessageReceivedHandler);
    on<TextMessageChanged>(_textMessageChangedHandler);
    on<_ClearTextMessageEvent>(_clearTextMessageEventHandler);
    on<ClearImageMessageEvent>(_clearImageMessageEventHandler);
    on<SendTextEvent>(_sendTextEventHandler);
    on<SendImageEvent>(_sendImageEventHandler);
    on<ImageEvent>(_imageEventHandler);
    on<SendDocEvent>(_sendDocEventHandler);
    on<ResetBlocStatus>(_resetBlocStatusHandler);
    on<ChatPagePopEvent>(_chatPagePopEventHandler);
    on<ResetBlocState>(_resetBlocStateHandler);
    on<ViewDisposeEvent>(_viewDisposeEventHandler);
  }

  final String imageBaseUrl;
  final AuthCubit _authCubit;
  final FirebaseRealtimeDatabase _firebaseRealtimeDatabase;
  final FirebaseStorageServices _firebaseStorageServices;

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

  void _getChatsSubscriptionEventHandler(
      GetChatsSubscriptionEvent event, Emitter<ChatState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        if (!_authCubit.state.isAuthorized) {
          throw AppException.authenticationException;
        }

        final FirebaseUser? firebaseUser = await _firebaseRealtimeDatabase
            .getFirebaseUser(user: _authCubit.state.user);

        if (firebaseUser is FirebaseUser) {
          final Stream<Set<FirebaseChat>> chatsStream =
              _firebaseRealtimeDatabase.getChatsStream(
            firebaseUser: firebaseUser,
          );

          final StreamSubscription<Set<FirebaseChat>> subscription =
              chatsStream.listen((Set<FirebaseChat> chats) {
            add(_OnChatsEvent(chats: chats));
          });
          emit(state.copyWith(chatsSubscription: subscription));
        }
      },
      emit: emit,
    );
  }

  void _onChatsEventHandler(
      _OnChatsEvent event, Emitter<ChatState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        if (event.chats != state.chats) {
          final Set<String> addedChatsIds = event.chats
              .difference(state.chats)
              .map((FirebaseChat chat) => chat.id)
              .toSet();
          final Map<String, Stream<Set<FirebaseMessage>>> messageStreams =
              _firebaseRealtimeDatabase.getMessagesStream(addedChatsIds);
          final Map<String, StreamSubscription<Set<FirebaseMessage>>>
              addedMessageSubscriptions =
              _getMessageSubscriptions(messageStreams);

          final Set<String> removedChatsIds = state.chats
              .difference(event.chats)
              .map((FirebaseChat chat) => chat.id)
              .toSet();
          final Map<String, StreamSubscription<Set<FirebaseMessage>>>
              messageSubscriptions = state.messageSubscriptions;

          bool isCurrentChatRemoved = false;
          // Remove subscriptions of the chats that were removed.
          for (final String id in removedChatsIds) {
            messageSubscriptions.remove(id)?.cancel();
            if (id == state.currentChat?.id) {
              isCurrentChatRemoved = true;
            }
          }
          // Add subscriptioons of the chats that were added.
          messageSubscriptions.addAll(addedMessageSubscriptions);

          emit(state.copyWith(
              chats: event.chats, messageSubscriptions: messageSubscriptions));

          if (isCurrentChatRemoved) {
            throw AppException.currentChatRemoved();
          }
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
        emit(
          state.copyWith(
            currentChatMessagesFetched: true,
          ),
        );
      },
      emit: emit,
    );
  }

  void _resetCurrentChatMessagesFetchedHandler(
      ResetCurrentChatMessagesFetched event, Emitter<ChatState> emit) async {
    emit(state.copyWith(currentChatMessagesFetched: false));
  }

  void _getMessageSubscriptionsEventHandler(
      GetMessageSubscriptionsEvent event, Emitter<ChatState> emit) async {
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
                  .getMessagesStream(firebaseUser.chatIds!);

          final Map<String, StreamSubscription<Set<FirebaseMessage>>>
              subscriptions = _getMessageSubscriptions(messageStreams);

          emit(state.copyWith(
            messageSubscriptions: subscriptions,
          ));
        }
      },
      emit: emit,
      emitFailureOnly: true,
    );
  }

  void _onMessagesEventHandler(
      _OnMessagesEvent event, Emitter<ChatState> emit) {
    if (state.currentChat != null && event.chatId == state.currentChat!.id) {
      emit(
        state.copyWith(
          messages: event.messages,
        ),
      );

      emit(
        state.copyWith(
          currentChatMessagesFetched: true,
        ),
      );
    }
  }

  void _resetCurrentChatNewMessageReceivedHandler(
      ResetCurrentChatNewMessageReceived event, Emitter<ChatState> emit) {
    emit(
      state.copyWith(currentChatNewMessageReceived: false),
    );
  }

  void _textMessageChangedHandler(
      TextMessageChanged event, Emitter<ChatState> emit) {
    emit(state.copyWith(message: event.message));
  }

  void _clearTextMessageEventHandler(
      _ClearTextMessageEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(message: ''));
  }

  void _clearImageMessageEventHandler(
      ClearImageMessageEvent event, Emitter<ChatState> emit) {
    emit(ChatState(
        blocStatus: state.blocStatus,
        chats: state.chats,
        currentChat: state.currentChat,
        message: state.message,
        messages: state.messages,
        messagesStream: state.messagesStream,
        subscriptions: state.subscriptions));
  }

  void _sendTextEventHandler(
      SendTextEvent event, Emitter<ChatState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        if (!_authCubit.state.isAuthorized) {
          throw AppException.authenticationException;
        }
        final String? messageId = _firebaseRealtimeDatabase.getNewMessgeId(
            chatId: state.currentChat!.id);
        if (messageId == null) {
          throw AppException.firebaseCouldNotGenerateKey();
        }
        if (state.message.isEmpty) {
          throw AppException.messageCannotBeEmpty();
        }
        _firebaseRealtimeDatabase.sendMessage(
            textMessage: state.message,
            chatId: state.currentChat!.id,
            senderId: _authCubit.state.user!.firebaseId,
            messageId: messageId,
            messageType: 1);

        add(_ClearTextMessageEvent());
      },
      emit: emit,
    );
  }

  void _sendImageEventHandler(
      SendImageEvent event, Emitter<ChatState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        if (!_authCubit.state.isAuthorized) {
          throw AppException.authenticationException;
        }
        final String? messageId = _firebaseRealtimeDatabase.getNewMessgeId(
            chatId: state.currentChat!.id);
        if (messageId == null) {
          throw AppException.firebaseCouldNotGenerateKey();
        }
        final String? imageUrl = await _firebaseStorageServices.uploadImageFile(
            state.imageFile, messageId);
        if (imageUrl == null) {
          throw AppException.imageCannotBeEmpty();
        }
        _firebaseRealtimeDatabase.sendMessage(
            textMessage: state.message,
            chatId: state.currentChat!.id,
            senderId: _authCubit.state.user!.firebaseId,
            imageUrl: imageUrl,
            messageId: messageId,
            messageType: 2);

        add(ClearImageMessageEvent());
      },
      emit: emit,
    );
  }

  void _imageEventHandler(ImageEvent event, Emitter<ChatState> emit) async {
    emit(
      state.copyWith(imageFile: event.imageFile),
    );
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
      chatsSubscription: state.chatsSubscription,
      messageSubscriptions: state.messageSubscriptions,
    ));
  }

  void _resetBlocStateHandler(ResetBlocState event, Emitter<ChatState> emit) {
    emit(ChatState(
      chatsSubscription: state.chatsSubscription,
      messageSubscriptions: state.messageSubscriptions,
    ));
  }

  void _viewDisposeEventHandler(
      ViewDisposeEvent event, Emitter<ChatState> emit) {
    for (final StreamSubscription<Set<FirebaseMessage>> subscription
        in state.messageSubscriptions.values) {
      subscription.cancel();
    }
    state.chatsSubscription?.cancel();

    emit(const ChatState());
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

  /// {chatId: subscription}
  Map<String, StreamSubscription<Set<FirebaseMessage>>>
      _getMessageSubscriptions(
              Map<String, Stream<Set<FirebaseMessage>>> messageStreams) =>
          messageStreams.map(
            (String key, Stream<Set<FirebaseMessage>> value) =>
                MapEntry<String, StreamSubscription<Set<FirebaseMessage>>>(
              key,
              value.listen(
                (Set<FirebaseMessage> messages) {
                  add(
                    _OnMessagesEvent(chatId: key, messages: messages),
                  );
                },
              ),
            ),
          );
}
