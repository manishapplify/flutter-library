// TODO: Create a message abstract class and subclasses according to type.

class FirebaseMessage {
  FirebaseMessage({
    this.attachmentUrl,
    required this.chatDialogId,
    required this.firebaseMessageTime,
    required this.message,
    required this.messageId,
    required this.messageReadStatus,
    required this.messageTime,
    required this.messageType,
    required this.receiverId,
    required this.senderId,
  });

  factory FirebaseMessage.fromMap(Map<dynamic, dynamic> map) {
    return FirebaseMessage(
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
      messageType: map['message_type'],
      receiverId: map['receiver_id'],
      senderId: map['sender_id'],
    );
  }

  final String? attachmentUrl;
  final String chatDialogId;
  final DateTime firebaseMessageTime;
  final String message;
  final String messageId;

  /// Other user id
  final String messageReadStatus;

  /// Local time
  final DateTime messageTime;

  /// 1 -> Text message
  /// 2 -> Image
  /// 3 -> Document
  final int messageType;
  final String receiverId;
  final String senderId;

  bool isSentByCurrentUser(String currentUserId) => currentUserId == senderId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'attachment_url': attachmentUrl,
      'chat_dialog_id': chatDialogId,
      'firebase_message_time': firebaseMessageTime.millisecondsSinceEpoch,
      'message': message,
      'message_id': messageId,
      'message_read_status': <String, String>{
        messageReadStatus: messageReadStatus
      },
      'message_time': messageTime.millisecondsSinceEpoch,
      'message_type': messageType,
      'receiver_id': receiverId,
      'sender_id': senderId,
    };
  }

  @override
  String toString() {
    return 'FirebaseMessage(attachmentUrl: $attachmentUrl, chatDialogId: $chatDialogId, firebaseMessageTime: $firebaseMessageTime, message: $message, messageId: $messageId, messageReadStatus: $messageReadStatus, messageTime: $messageTime, messageType: $messageType, receiverId: $receiverId, senderId: $senderId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is FirebaseMessage && other.messageId == messageId;
  }

  @override
  int get hashCode {
    return messageId.hashCode;
  }
}
