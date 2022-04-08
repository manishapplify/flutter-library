class FirebaseChat {
  FirebaseChat({
    required this.id,
    this.lastMessage,
    this.lastMessageId,
    this.lastMessageSenderId,
    this.lastMessageTime,
    required this.participantIds,
    required this.participantNames,
    required this.participantProfileImages,
  });

  factory FirebaseChat.fromMap(Map<dynamic, dynamic> map) {
    return FirebaseChat(
      id: map['chat_dialog_id'],
      lastMessage: map['last_message'],
      lastMessageId: map['last_message_id'],
      lastMessageSenderId: map['last_message_sender_id'],
      lastMessageTime:
          DateTime.fromMillisecondsSinceEpoch(map['last_message_time'] as int),
      participantIds: (map['participant_ids'] as String).split(',').toSet(),
      participantNames: Map<String, String>.from(map['name']),
      participantProfileImages: Map<String, String>.from(map['profile_pic']),
    );
  }

  final String id;
  final String? lastMessage;
  final String? lastMessageId;
  final String? lastMessageSenderId;
  final DateTime? lastMessageTime;
  final Set<String> participantIds;
  final Map<String, String> participantNames;
  final Map<String, String>? participantProfileImages;
}
