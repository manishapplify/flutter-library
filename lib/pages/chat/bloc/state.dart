part of 'bloc.dart';

@immutable
class ChatState {
  const ChatState({
    this.blocStatus = const InitialFormStatus(),
    this.chats = const <FirebaseChat>{},
    this.message = '',
    this.messagesStream = const <String, Stream<Set<FirebaseMessage>>>{},
    this.subscriptions = const <StreamSubscription<Set<FirebaseMessage>>>[],
    this.messages = const <FirebaseMessage>{},
    this.currentChat,
  });

  final Set<FirebaseChat> chats;
  final FirebaseChat? currentChat;
  final String message;
  final Set<FirebaseMessage> messages;
  final Map<String, Stream<Set<FirebaseMessage>>> messagesStream;
  final List<StreamSubscription<Set<FirebaseMessage>>> subscriptions;
  final FormSubmissionStatus blocStatus;

  ChatState copyWith({
    Set<FirebaseChat>? chats,
    String? message,
    Set<FirebaseMessage>? messages,
    Map<String, Stream<Set<FirebaseMessage>>>? messagesStream,
    List<StreamSubscription<Set<FirebaseMessage>>>? subscriptions,
    FormSubmissionStatus? blocStatus,
    FirebaseChat? currentChat,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      messages: messages ?? this.messages,
      messagesStream: messagesStream ?? this.messagesStream,
      subscriptions: subscriptions ?? this.subscriptions,
      blocStatus: blocStatus ?? this.blocStatus,
      message: message ?? this.message,
      currentChat: currentChat ?? this.currentChat,
    );
  }
}
