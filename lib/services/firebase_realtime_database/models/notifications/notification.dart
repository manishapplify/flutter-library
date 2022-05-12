abstract class FirebaseNotifications {
  FirebaseNotifications(
      {required this.chatDialogId,
      required this.firebaseMessageTime,
      required this.message,
      required this.messageId,
      required this.messageReadStatus,
      required this.messageTime,
      required this.receiverId,
      required this.senderId,
      required this.messageType});

  final String chatDialogId;
  final DateTime firebaseMessageTime;
  final String message;
  final String messageId;
  final String messageType;

  /// Other user id
  final String messageReadStatus;

  /// Local time
  final DateTime messageTime;

  final String receiverId;
  final String senderId;

  bool isSentByCurrentUser(String currentUserId) => currentUserId == senderId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
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
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is FirebaseNotifications && other.messageId == messageId;
  }

  @override
  int get hashCode {
    return messageId.hashCode;
  }
}
