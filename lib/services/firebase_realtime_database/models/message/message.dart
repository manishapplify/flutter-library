import 'package:components/exceptions/app_exception.dart';
import 'package:components/services/firebase_realtime_database/models/message/document_message.dart';
import 'package:components/services/firebase_realtime_database/models/message/image_message.dart';
import 'package:components/services/firebase_realtime_database/models/message/text_message.dart';

abstract class FirebaseMessage {
  FirebaseMessage({
    required this.chatDialogId,
    required this.firebaseMessageTime,
    required this.message,
    required this.messageId,
    required this.messageReadStatus,
    required this.messageTime,
    required this.receiverId,
    required this.senderId,
  });

  factory FirebaseMessage.fromMap(Map<dynamic, dynamic> map) {
    final int messageType = map['message_type'];

    if (messageType == 1) {
      return TextMessage.fromMap(map);
    } else if (messageType == 2) {
      return ImageMessage.fromMap(map);
    } else if (messageType == 3) {
      return DocumentMessage.fromMap(map);
    } else {
      throw AppException.unknownMessageType();
    }
  }

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
  int get messageType => throw UnimplementedError();
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

    return other is FirebaseMessage && other.messageId == messageId;
  }

  @override
  int get hashCode {
    return messageId.hashCode;
  }
}
