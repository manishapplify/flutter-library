import 'package:components/services/firebase_realtime_database/models/message/message.dart';

class DocumentMessage extends FirebaseMessage {
  DocumentMessage({
    required this.attachmentUrl,
    required String chatDialogId,
    required DateTime firebaseMessageTime,
    required String message,
    required String messageId,
    required String messageReadStatus,
    required DateTime messageTime,
    required String receiverId,
    required String senderId,
  }) : super(
          chatDialogId: chatDialogId,
          firebaseMessageTime: firebaseMessageTime,
          message: message,
          messageId: messageId,
          messageReadStatus: messageReadStatus,
          messageTime: messageTime,
          receiverId: receiverId,
          senderId: senderId,
        );

  factory DocumentMessage.fromMap(Map<dynamic, dynamic> map) {
    return DocumentMessage(
      attachmentUrl: map['attachment_url'],
      chatDialogId: map['chat_dialog_id'],
      firebaseMessageTime: DateTime.fromMillisecondsSinceEpoch(
          map['firebase_message_time'] as int),
      message: map['message'],
      messageId: map['message_id'],
      messageReadStatus: (map['message_read_status'] as Map<dynamic, dynamic>)
          .entries
          .first
          .key,
      messageTime:
          DateTime.fromMillisecondsSinceEpoch(map['message_time'] as int),
      receiverId: map['receiver_id'],
      senderId: map['sender_id'],
    );
  }

  final String attachmentUrl;

  @override
  int get messageType => 3;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = super.toMap();
    map['attachment_url'] = attachmentUrl;
    return map;
  }
}
