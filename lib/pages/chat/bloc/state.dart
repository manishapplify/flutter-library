part of 'bloc.dart';

@immutable
class ChatState {
  const ChatState({
    this.blocStatus = const InitialFormStatus(),
    this.chats = const <FirebaseChat>[],
    this.messages = const <FirebaseMessage>[],
    this.currentChat,
  });

  final List<FirebaseChat> chats;
  final FirebaseChat? currentChat;
  final List<FirebaseMessage> messages;
  final FormSubmissionStatus blocStatus;

  ChatState copyWith({
    List<FirebaseChat>? chats,
    List<FirebaseMessage>? messages,
    FormSubmissionStatus? blocStatus,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      messages: messages ?? this.messages,
      blocStatus: blocStatus ?? this.blocStatus,
      currentChat: currentChat ?? this.currentChat,
    );
  }
}
