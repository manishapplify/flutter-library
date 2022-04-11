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
      lastMessageTime: map['last_message_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_message_time'] as int)
          : null,
      participantIds: (map['participant_ids'] as String).split(',').toSet(),
      participantNames: Map<String, String>.from(map['name']),
      participantProfileImages: map['profile_pic'] != null
          ? Map<String, String>.from(map['profile_pic'])
          : null,
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

  Map<String, dynamic> toFirebaseMap() {
    final Map<String, dynamic> data = <String, dynamic>{
      'chat_dialog_id': id,
      'participant_ids': participantIds.join(','),
      'name': participantNames,
    };

    if (lastMessage is String) {
      data['last_message'] = lastMessage;
    }
    if (lastMessageId is String) {
      data['last_message_id'] = lastMessageId;
    }
    if (lastMessageSenderId is String) {
      data['last_message_sender_id'] = lastMessageSenderId;
    }
    if (lastMessageTime is DateTime) {
      data['last_message_time'] = lastMessageTime!.millisecondsSinceEpoch;
    }
    if (participantProfileImages is Map<String, String>) {
      data['profile_pic'] = participantProfileImages;
    }

    return data;
  }
}
