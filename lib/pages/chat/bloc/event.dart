part of 'bloc.dart';

@immutable
abstract class ChatEvent {}

class GetChatsEvent extends ChatEvent {}

class RemoveChatEvent extends ChatEvent {
  RemoveChatEvent(this.chat);

  final FirebaseChat chat;
}

class GetCurrentChatMessagesEvent extends ChatEvent {}

class TextMessageChanged extends ChatEvent {
  TextMessageChanged(this.message);

  final String message;
}

class ClearTextMessageEvent extends ChatEvent {}

class SendTextEvent extends ChatEvent {}

class SendImageEvent extends ChatEvent {}

class SendDocEvent extends ChatEvent {}
