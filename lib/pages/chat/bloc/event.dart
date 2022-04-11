part of 'bloc.dart';

@immutable
abstract class ChatEvent {}

class GetChatsEvent extends ChatEvent {}

class RemoveChatEvent extends ChatEvent {
  RemoveChatEvent(this.chat);

  final FirebaseChat chat;
}
