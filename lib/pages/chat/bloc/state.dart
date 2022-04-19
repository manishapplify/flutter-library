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
    this.messages = const <FirebaseMessage>{},
    this.currentChat,
  });

  final Set<FirebaseChat> chats;
  final StreamSubscription<Set<FirebaseChat>>? chatsSubscription;
  final FirebaseChat? currentChat;
  final String message;
  final Set<FirebaseMessage> messages;
  /// ChatId: Subscription object.
  final Map<String, StreamSubscription<Set<FirebaseMessage>>> messageSubscriptions;
  final FormSubmissionStatus blocStatus;

  ChatState copyWith({
    Set<FirebaseChat>? chats,
    StreamSubscription<Set<FirebaseChat>>? chatsSubscription,
    String? message,
    Set<FirebaseMessage>? messages,
    Map<String, StreamSubscription<Set<FirebaseMessage>>>? messageSubscriptions,
    FormSubmissionStatus? blocStatus,
    FirebaseChat? currentChat,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      chatsSubscription: chatsSubscription ?? this.chatsSubscription,
      messages: messages ?? this.messages,
      messageSubscriptions: messageSubscriptions ?? this.messageSubscriptions,
      blocStatus: blocStatus ?? this.blocStatus,
      message: message ?? this.message,
      currentChat: currentChat ?? this.currentChat,
    );
  }
}
