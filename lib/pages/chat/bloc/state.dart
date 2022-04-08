part of 'bloc.dart';

@immutable
class ChatState {
  const ChatState({
    this.blocStatus = const InitialFormStatus(),
    this.chats = const <FirebaseChat>[],
  });

  final List<FirebaseChat> chats;
  final FormSubmissionStatus blocStatus;

  ChatState copyWith({
    List<FirebaseChat>? chats,
    FormSubmissionStatus? blocStatus,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      blocStatus: blocStatus ?? this.blocStatus,
    );
  }
}
