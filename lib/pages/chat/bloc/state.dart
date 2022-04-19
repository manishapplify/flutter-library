part of 'bloc.dart';

@immutable
class ChatState {
  const ChatState({
    this.blocStatus = const InitialFormStatus(),
    this.chats = const <FirebaseChat>{},
    this.chatsSubscription,
    this.message = '',
    this.messageSubscriptions =
        const <String, StreamSubscription<Set<FirebaseMessage>>>{},
    this.currentChatNewMessageReceived = false,
    this.messages = const <FirebaseMessage>{},
    this.currentChat,
    this.currentChatMessagesFetched = false,
  });

  final Set<FirebaseChat> chats;
  final StreamSubscription<Set<FirebaseChat>>? chatsSubscription;
  final FirebaseChat? currentChat;
  final bool currentChatMessagesFetched;
  final String message;
  final Set<FirebaseMessage> messages;
  final bool currentChatNewMessageReceived;

  /// ChatId: Subscription object.
  final Map<String, StreamSubscription<Set<FirebaseMessage>>>
      messageSubscriptions;
  final FormSubmissionStatus blocStatus;

  ChatState copyWith({
    Set<FirebaseChat>? chats,
    StreamSubscription<Set<FirebaseChat>>? chatsSubscription,
    String? message,
    Set<FirebaseMessage>? messages,
    Map<String, StreamSubscription<Set<FirebaseMessage>>>? messageSubscriptions,
    bool? currentChatNewMessageReceived,
    FormSubmissionStatus? blocStatus,
    FirebaseChat? currentChat,
    bool? currentChatMessagesFetched,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      chatsSubscription: chatsSubscription ?? this.chatsSubscription,
      messages: messages ?? this.messages,
      messageSubscriptions: messageSubscriptions ?? this.messageSubscriptions,
      currentChatNewMessageReceived:
          currentChatNewMessageReceived ?? this.currentChatNewMessageReceived,
      blocStatus: blocStatus ?? this.blocStatus,
      message: message ?? this.message,
      currentChat: currentChat ?? this.currentChat,
      currentChatMessagesFetched:
          currentChatMessagesFetched ?? this.currentChatMessagesFetched,
    );
  }
}
