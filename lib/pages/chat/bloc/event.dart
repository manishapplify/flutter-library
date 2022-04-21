part of 'bloc.dart';

@immutable
abstract class ChatEvent {}

class GetChatsEvent extends ChatEvent {}

class GetChatsSubscriptionEvent extends ChatEvent {}

class _OnChatsEvent extends ChatEvent {
  _OnChatsEvent({
    required this.chats,
  });

  final Set<FirebaseChat> chats;
}

class RemoveChatEvent extends ChatEvent {
  RemoveChatEvent(this.chat);

  final FirebaseChat chat;
}

class ChatOpenedEvent extends ChatEvent {
  ChatOpenedEvent(this.chat);

  final FirebaseChat chat;
}

class GetCurrentChatMessagesEvent extends ChatEvent {}

class GetMessageSubscriptionsEvent extends ChatEvent {}

class _OnMessagesEvent extends ChatEvent {
  _OnMessagesEvent({
    required this.chatId,
    required this.messages,
  });

  final String chatId;
  final Set<FirebaseMessage> messages;
}

class TextMessageChanged extends ChatEvent {
  TextMessageChanged(this.message);

  final String message;
}

class _ClearTextMessageEvent extends ChatEvent {}
class ClearImageMessageEvent extends ChatEvent {}

class SendTextEvent extends ChatEvent {}

class ImageEvent extends ChatEvent {
  ImageEvent({required this.imageFile});
  final File imageFile;
}
class SendImageEvent extends ChatEvent {}

class SendDocEvent extends ChatEvent {}

class ResetBlocStatus extends ChatEvent {}

class ResetBlocState extends ChatEvent {}

class ChatPagePopEvent extends ChatEvent {}

class ViewDisposeEvent extends ChatEvent {}

class ResetCurrentChatMessagesFetched extends ChatEvent {}

class ResetCurrentChatNewMessageReceived extends ChatEvent {}
