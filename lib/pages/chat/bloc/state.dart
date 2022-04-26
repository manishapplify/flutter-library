part of 'bloc.dart';

@immutable
class ChatState {
  const ChatState({
    this.blocStatus = const InitialFormStatus(),
    this.chats = const <FirebaseChat>{},
    this.chatsSubscription,
    this.chatUpdateSubscriptions =
        const <String, StreamSubscription<FirebaseChat?>>{},
    this.message = '',
    this.messageSubscriptions =
        const <String, StreamSubscription<Set<FirebaseMessage>>>{},
    this.currentChatNewMessageReceived = false,
    this.messages = const <FirebaseMessage>{},
    this.currentChat,
    this.currentChatMessagesFetched = false,
    this.imageFile,
    this.pdfFile,
  });

  final Set<FirebaseChat> chats;

  /// Keeps track of new and removed chats.
  final StreamSubscription<Set<FirebaseChat>>? chatsSubscription;

  /// Keeps track of latest messages received in a particular chat.
  final Map<String, StreamSubscription<FirebaseChat?>> chatUpdateSubscriptions;

  final FirebaseChat? currentChat;
  final bool currentChatMessagesFetched;
  final String message;
  final Set<FirebaseMessage> messages;
  final bool currentChatNewMessageReceived;

  /// ChatId: Subscription object.
  final Map<String, StreamSubscription<Set<FirebaseMessage>>>
      messageSubscriptions;
  final FormSubmissionStatus blocStatus;
  final File? imageFile;
  final PlatformFile? pdfFile;

  ChatState copyWith({
    Set<FirebaseChat>? chats,
    StreamSubscription<Set<FirebaseChat>>? chatsSubscription,
    Map<String, StreamSubscription<FirebaseChat?>>? chatUpdateSubscriptions,
    String? message,
    Set<FirebaseMessage>? messages,
    Map<String, StreamSubscription<Set<FirebaseMessage>>>? messageSubscriptions,
    bool? currentChatNewMessageReceived,
    FormSubmissionStatus? blocStatus,
    FirebaseChat? currentChat,
    bool? currentChatMessagesFetched,
    File? imageFile,
    PlatformFile? pdfFile,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      chatsSubscription: chatsSubscription ?? this.chatsSubscription,
      chatUpdateSubscriptions:
          chatUpdateSubscriptions ?? this.chatUpdateSubscriptions,
      messages: messages ?? this.messages,
      messageSubscriptions: messageSubscriptions ?? this.messageSubscriptions,
      currentChatNewMessageReceived:
          currentChatNewMessageReceived ?? this.currentChatNewMessageReceived,
      blocStatus: blocStatus ?? this.blocStatus,
      message: message ?? this.message,
      currentChat: currentChat ?? this.currentChat,
      currentChatMessagesFetched:
          currentChatMessagesFetched ?? this.currentChatMessagesFetched,
      imageFile: imageFile ?? this.imageFile,
      pdfFile: pdfFile ?? this.pdfFile,
    );
  }
}
