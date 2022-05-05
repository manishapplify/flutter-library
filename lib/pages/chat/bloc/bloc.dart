import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:components/common/work_status.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/common/app_exception.dart';
import 'package:components/services/api/api.dart';
import 'package:components/services/firebase_realtime_database/firebase_realtime_database.dart';
import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:components/services/firebase_realtime_database/models/message/document_message.dart';
import 'package:components/services/firebase_realtime_database/models/message/image_message.dart';
import 'package:components/services/firebase_realtime_database/models/message/message.dart';
import 'package:components/services/firebase_realtime_database/models/message/text_message.dart';
import 'package:components/services/firebase_realtime_database/models/user.dart';
import 'package:components/services/firebase_storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(
      {required this.imageBaseUrl,
      required AuthCubit authCubit,
      required FirebaseRealtimeDatabase firebaseRealtimeDatabase,
      required FirebaseStorageService firebaseStorageService,
      required Api api})
      : _authCubit = authCubit,
        _firebaseRealtimeDatabase = firebaseRealtimeDatabase,
        _firebaseStorageService = firebaseStorageService,
        _api = api,
        super(const ChatState()) {
    on<GetChatsEvent>(_getChatsEventHandler);
    on<GetChatsSubscriptionEvent>(_getChatsSubscriptionEventHandler);
    on<_OnChatEvent>(_onChatEventHandler);
    on<_OnChatsEvent>(_onChatsEventHandler);
    on<RemoveChatEvent>(_removeChatEventHandler);
    on<ChatCreatedEvent>(_chatCreatedEventHandler);
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
    on<ClearDocMessageEvent>(_clearDocMessageEventHandler);
    on<SendTextEvent>(_sendTextEventHandler);
    on<SendImageEvent>(_sendImageEventHandler);
    on<ImageUpdateEvent>(_imageUpdateEventHandler);
    on<PdfUpdateEvent>(_pdfUpdateEventHandler);
    on<SendDocEvent>(_sendDocEventHandler);
    on<OpenDocEvent>(_openDocEventHandler);
    on<OnPdfViewCloseEvent>(_onPdfViewCloseEventHandler);
    on<ResetBlocStatus>(_resetBlocStatusHandler);
    on<ChatPagePopEvent>(_chatPagePopEventHandler);
    on<ResetBlocState>(_resetBlocStateHandler);
    on<ViewDisposeEvent>(_viewDisposeEventHandler);
  }

  final String imageBaseUrl;
  final AuthCubit _authCubit;
  final FirebaseRealtimeDatabase _firebaseRealtimeDatabase;
  final FirebaseStorageService _firebaseStorageService;
  final Api _api;

  void _getChatsEventHandler(
      GetChatsEvent event, Emitter<ChatState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        if (!_authCubit.state.isAuthorized) {
          throw AppException.authenticationException();
        }

        final FirebaseUser? firebaseUser = await _firebaseRealtimeDatabase
            .getFirebaseUser(user: _authCubit.state.user);

        if (firebaseUser is FirebaseUser) {
          if (firebaseUser.chatIds is Set<String> &&
              firebaseUser.chatIds!.isNotEmpty) {
            final Set<FirebaseChat> chats =
                await _firebaseRealtimeDatabase.getChats(firebaseUser.chatIds!);

            emit(state.copyWith(chats: _sortChats(chats)));
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
          throw AppException.authenticationException();
        }

        final FirebaseUser? firebaseUser = await _firebaseRealtimeDatabase
            .getFirebaseUser(user: _authCubit.state.user);

        if (firebaseUser is FirebaseUser) {
          final Stream<Set<FirebaseChat>> chatsStream =
              _firebaseRealtimeDatabase.getChatsStream(
            firebaseUser: firebaseUser,
          );

          final StreamSubscription<Set<FirebaseChat>> chatsSubscription =
              chatsStream.listen((Set<FirebaseChat> chats) {
            add(_OnChatsEvent(chats: chats));
          });

          final Map<String, StreamSubscription<FirebaseChat?>>
              chatUpdateSubscriptions = _getChatUpdateSubscriptions(
            _firebaseRealtimeDatabase
                .getChatUpdateStreams(firebaseUser.chatIds ?? <String>{}),
          );

          emit(state.copyWith(
            chatsSubscription: chatsSubscription,
            chatUpdateSubscriptions: chatUpdateSubscriptions,
          ));
        }
      },
      emit: emit,
      emitFailureOnly: true,
    );
  }

  void _onChatEventHandler(_OnChatEvent event, Emitter<ChatState> emit) async {
    final Set<FirebaseChat> chats = state.chats;

    if (chats.contains(event.chat)) {
      emit(
        state.copyWith(
          chats: _sortChats(
            chats
              ..remove(event.chat)
              ..add(event.chat),
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          chats: chats.isEmpty
              ? <FirebaseChat>{event.chat}
              : _sortChats(
                  chats..add(event.chat),
                ),
        ),
      );
    }
  }

  /// [_onChatsEventHandler] is called when the subscription of
  /// `Users/<user_id>/chat_dialog_ids` emits a new [DatabaseEvent].
  ///
  /// Updates [state.messageSubscriptions] and [state.chatUpdateSubscriptions]
  /// accordingly.
  void _onChatsEventHandler(
      _OnChatsEvent event, Emitter<ChatState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        if (event.chats != state.chats) {
          final Set<String> addedChatsIds = event.chats
              .difference(state.chats)
              .map((FirebaseChat chat) => chat.id)
              .toSet();
          final Set<String> removedChatsIds = state.chats
              .difference(event.chats)
              .map((FirebaseChat chat) => chat.id)
              .toSet();
          final bool isCurrentChatRemoved =
              removedChatsIds.contains(state.currentChat?.id);

          final Map<String, StreamSubscription<Set<FirebaseMessage>>>
              // Fix unmodifiable map error.
              messageSubscriptions = state.messageSubscriptions.isEmpty
                  ? <String, StreamSubscription<Set<FirebaseMessage>>>{}
                  : state.messageSubscriptions;

          // Remove message subscription of the chats that were removed.
          for (final String id in removedChatsIds) {
            messageSubscriptions.remove(id)?.cancel();
          }

          final Map<String, StreamSubscription<Set<FirebaseMessage>>>
              addedMessageSubscriptions = _getMessageSubscriptions(
            _firebaseRealtimeDatabase.getMessageStreams(addedChatsIds),
          );
          // Add message subscription of the chats that were added.
          messageSubscriptions.addAll(addedMessageSubscriptions);

          final Map<String, StreamSubscription<FirebaseChat?>>
              chatUpdateSubscriptions = state.chatUpdateSubscriptions.isEmpty
                  ? <String, StreamSubscription<FirebaseChat?>>{}
                  : state.chatUpdateSubscriptions;

          // Remove chat update subscription of the removed chats.
          for (final String id in removedChatsIds) {
            chatUpdateSubscriptions.remove(id)?.cancel();
          }

          final Map<String, StreamSubscription<FirebaseChat?>>
              addedChatSubscriptions = _getChatUpdateSubscriptions(
            _firebaseRealtimeDatabase.getChatUpdateStreams(addedChatsIds),
          );
          // Add chat update subscription of the added chats.
          chatUpdateSubscriptions.addAll(addedChatSubscriptions);

          emit(
            state.copyWith(
              chats: _sortChats(event.chats),
              messageSubscriptions: messageSubscriptions,
              chatUpdateSubscriptions: chatUpdateSubscriptions,
            ),
          );

          if (isCurrentChatRemoved) {
            throw AppException.currentChatRemoved();
          }
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

  void _chatCreatedEventHandler(
      ChatCreatedEvent event, Emitter<ChatState> emit) async {
    // Clear previous chat, if present.
    if (state.currentChat is FirebaseChat) {
      add(ChatPagePopEvent());
    }
    await _commonHandler(
      handlerJob: () async {
        final FirebaseChat chat =
            await _firebaseRealtimeDatabase.addChatIfNotExists(
          firebaseUserA: event.firebaseUserA,
          firebaseUserB: event.firebaseUserB,
        );

        emit(state.copyWith(currentChat: chat));
        add(GetCurrentChatMessagesEvent());
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
    if (state.currentChat is FirebaseChat) {
      await _commonHandler(
        handlerJob: () async {
          final Set<FirebaseMessage> messages = await _firebaseRealtimeDatabase
              .getMessages(state.currentChat!.id);

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
          throw AppException.authenticationException();
        }

        final FirebaseUser? firebaseUser = await _firebaseRealtimeDatabase
            .getFirebaseUser(user: _authCubit.state.user);

        if (firebaseUser is FirebaseUser &&
            firebaseUser.chatIds is Set<String> &&
            firebaseUser.chatIds!.isNotEmpty) {
          final Map<String, StreamSubscription<Set<FirebaseMessage>>>
              subscriptions = _getMessageSubscriptions(_firebaseRealtimeDatabase
                  .getMessageStreams(firebaseUser.chatIds!));

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
    emit(
      ChatState(
        blocStatus: state.blocStatus,
        chats: state.chats,
        chatsSubscription: state.chatsSubscription,
        chatUpdateSubscriptions: state.chatUpdateSubscriptions,
        message: state.message,
        messageSubscriptions: state.messageSubscriptions,
        currentChatMessagesFetched: state.currentChatMessagesFetched,
        messages: state.messages,
        currentChat: state.currentChat,
        currentChatNewMessageReceived: state.currentChatNewMessageReceived,
        pdfFile: state.pdfFile,
      ),
    );
  }

  void _clearDocMessageEventHandler(
      ClearDocMessageEvent event, Emitter<ChatState> emit) {
    emit(
      ChatState(
        blocStatus: state.blocStatus,
        chats: state.chats,
        imageFile: state.imageFile,
        currentChat: state.currentChat,
        message: state.message,
        messages: state.messages,
        chatsSubscription: state.chatsSubscription,
        chatUpdateSubscriptions: state.chatUpdateSubscriptions,
        messageSubscriptions: state.messageSubscriptions,
        currentChatMessagesFetched: state.currentChatMessagesFetched,
        currentChatNewMessageReceived: state.currentChatNewMessageReceived,
      ),
    );
  }

  void _sendTextEventHandler(
      SendTextEvent event, Emitter<ChatState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        if (!_authCubit.state.isAuthorized) {
          throw AppException.authenticationException();
        }
        if (state.message.isEmpty) {
          throw AppException.messageCannotBeEmpty();
        }

        final _MessageMetadata _messageMetadata = _getNewMessageMetadata();
        final FirebaseMessage message = TextMessage(
          message: state.message,
          chatDialogId: _messageMetadata.chatId,
          senderId: _messageMetadata.senderId,
          messageId: _messageMetadata.messageId,
          firebaseMessageTime: _messageMetadata.messageTime,
          messageTime: _messageMetadata.messageTime,
          receiverId: _messageMetadata.receiverId,
          messageReadStatus: _messageMetadata.receiverId,
        );

        _firebaseRealtimeDatabase.sendMessage(message);
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
          throw AppException.authenticationException();
        }
        if (state.imageFile == null) {
          throw AppException.imageCannotBeEmpty();
        }
        final _MessageMetadata _messageMetadata = _getNewMessageMetadata();
        final String? imageUrl = await _firebaseStorageService.uploadImage(
          file: state.imageFile!,
          messageId: _messageMetadata.messageId,
        );
        if (imageUrl == null) {
          throw AppException.imageCouldNotBeUploaded();
        }

        final FirebaseMessage message = ImageMessage(
          attachmentUrl: imageUrl,
          message: 'Image',
          chatDialogId: _messageMetadata.chatId,
          senderId: _messageMetadata.senderId,
          messageId: _messageMetadata.messageId,
          firebaseMessageTime: _messageMetadata.messageTime,
          messageTime: _messageMetadata.messageTime,
          receiverId: _messageMetadata.receiverId,
          messageReadStatus: _messageMetadata.receiverId,
        );

        _firebaseRealtimeDatabase.sendMessage(message);
        add(ClearImageMessageEvent());
      },
      emit: emit,
    );
  }

  void _imageUpdateEventHandler(
      ImageUpdateEvent event, Emitter<ChatState> emit) async {
    emit(
      state.copyWith(imageFile: event.imageFile),
    );
    add(ClearDocMessageEvent());
  }

  void _pdfUpdateEventHandler(
      PdfUpdateEvent event, Emitter<ChatState> emit) async {
    emit(
      state.copyWith(pdfFile: event.pdfFile),
    );
    add(ClearImageMessageEvent());
  }

  void _sendDocEventHandler(SendDocEvent event, Emitter<ChatState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        if (!_authCubit.state.isAuthorized) {
          throw AppException.authenticationException();
        }
        if (state.pdfFile == null) {
          throw AppException.docCannotBeEmpty();
        }
        final _MessageMetadata _messageMetadata = _getNewMessageMetadata();
        final String? pdfUrl = await _firebaseStorageService.uploadPdf(
            file: File(state.pdfFile!.path!),
            messageId: _messageMetadata.messageId);
        if (pdfUrl == null) {
          throw AppException.documentCouldNotBeUploaded();
        }

        final FirebaseMessage message = DocumentMessage(
          attachmentUrl: pdfUrl,
          message: state.pdfFile!.name,
          chatDialogId: _messageMetadata.chatId,
          senderId: _messageMetadata.senderId,
          messageId: _messageMetadata.messageId,
          firebaseMessageTime: _messageMetadata.messageTime,
          messageTime: _messageMetadata.messageTime,
          receiverId: _messageMetadata.receiverId,
          messageReadStatus: _messageMetadata.receiverId,
        );

        _firebaseRealtimeDatabase.sendMessage(message);
        add(ClearDocMessageEvent());
      },
      emit: emit,
    );
  }

  void _openDocEventHandler(OpenDocEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(pdfViewerStatus: InProgress()));
    try {
      final String filePath =
          await _api.downloadFile(event.docUrl, event.docFilename);

      emit(
        state.copyWith(
          downloadedPdfFilePath: filePath,
          pdfViewerStatus: Success(),
        ),
      );
    } on Exception catch (_) {
      // Show message and override [state.pdfViewerStatus]
      emit(
        state.copyWith(
          blocStatus: Failure(
              message: AppException.documentCouldNotBeDownloaded().message),
          pdfViewerStatus: const Idle(),
        ),
      );

      throw AppException.documentCouldNotBeDownloaded();
    }
  }

  void _onPdfViewCloseEventHandler(
      OnPdfViewCloseEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(
        downloadedPdfFilePath: '', pdfViewerStatus: const Idle()));
  }

  void _resetBlocStatusHandler(ResetBlocStatus event, Emitter<ChatState> emit) {
    emit(state.copyWith(blocStatus: const Idle()));
  }

  void _chatPagePopEventHandler(
      ChatPagePopEvent event, Emitter<ChatState> emit) {
    emit(ChatState(
      chats: state.chats,
      chatUpdateSubscriptions: state.chatUpdateSubscriptions,
      chatsSubscription: state.chatsSubscription,
      messageSubscriptions: state.messageSubscriptions,
    ));
  }

  void _resetBlocStateHandler(ResetBlocState event, Emitter<ChatState> emit) {
    emit(ChatState(
      chatUpdateSubscriptions: state.chatUpdateSubscriptions,
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

    final Map<String, StreamSubscription<FirebaseChat?>>? subscriptionsMap =
        state.chatUpdateSubscriptions;
    if (subscriptionsMap != null) {
      for (final StreamSubscription<FirebaseChat?> subscription
          in subscriptionsMap.values) {
        subscription.cancel();
      }
    }

    emit(const ChatState());
  }

  Future<void> _commonHandler({
    required Future<void> Function() handlerJob,
    required Emitter<ChatState> emit,
    bool emitFailureOnly = false,
  }) async {
    if (!emitFailureOnly) {
      emit(state.copyWith(blocStatus: InProgress()));
    }

    try {
      await handlerJob();
      if (!emitFailureOnly) {
        emit(state.copyWith(blocStatus: Success()));
      }
    } on AppException catch (e) {
      emit(state.copyWith(
          blocStatus: Failure(exception: e, message: e.message)));
    } on Exception catch (_) {
      emit(
        state.copyWith(
          blocStatus: Failure(exception: Exception('Failure')),
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

  Map<String, StreamSubscription<FirebaseChat?>> _getChatUpdateSubscriptions(
          Map<String, Stream<FirebaseChat?>> chatStreams) =>
      chatStreams.map(
        (String key, Stream<FirebaseChat?> value) =>
            MapEntry<String, StreamSubscription<FirebaseChat?>>(
          key,
          value.listen(
            (FirebaseChat? chat) {
              if (chat is FirebaseChat) {
                add(_OnChatEvent(chat: chat));
              }
            },
          ),
        ),
      );

  Set<FirebaseChat> _sortChats(Set<FirebaseChat> chats) {
    final List<FirebaseChat> list = chats.toList()
      ..sort(
        ((FirebaseChat a, FirebaseChat b) {
          if (a.lastMessageTime is DateTime && b.lastMessageTime is DateTime) {
            return b.lastMessageTime!.compareTo(a.lastMessageTime!);
          } else if (a.lastMessageTime is DateTime) {
            return -1;
          } else if (b.lastMessageTime is DateTime) {
            return 1;
          } else {
            return 0;
          }
        }),
      );

    return list.toSet();
  }

  _MessageMetadata _getNewMessageMetadata() {
    final String chatId = state.currentChat!.id;
    final String senderId = _authCubit.state.user!.firebaseId;
    final String receiverId =
        chatId.split(',').firstWhere((String id) => id != senderId);
    final String? messageId =
        _firebaseRealtimeDatabase.getNewMessgeId(chatId: state.currentChat!.id);
    if (messageId == null) {
      throw AppException.firebaseCouldNotGenerateKey();
    }
    return _MessageMetadata(
        chatId: chatId,
        senderId: senderId,
        receiverId: receiverId,
        messageId: messageId,
        messageTime: DateTime.now());
  }
}

class _MessageMetadata {
  _MessageMetadata(
      {required this.chatId,
      required this.senderId,
      required this.receiverId,
      required this.messageId,
      required this.messageTime});
  final String chatId;
  final String senderId;
  final String receiverId;
  final String messageId;
  final DateTime messageTime;
}
