part of 'bloc.dart';

@immutable
class ChatState {
  const ChatState({
    this.blocStatus = const InitialFormStatus(),
    this.chats = const <FirebaseChat>{},
    this.message = '',
    this.messages = const <FirebaseMessage>{},
    this.currentChat,
  });

  final Set<FirebaseChat> chats;
  final FirebaseChat? currentChat;
  final String message;
  final Set<FirebaseMessage> messages;
  final FormSubmissionStatus blocStatus;

  ChatState copyWith({
    Set<FirebaseChat>? chats,
    String? message,
    Set<FirebaseMessage>? messages,
    FormSubmissionStatus? blocStatus,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      messages: messages ?? this.messages,
      blocStatus: blocStatus ?? this.blocStatus,
      message: message ?? this.message,
      currentChat: currentChat ?? this.currentChat,
    );
  }
}
