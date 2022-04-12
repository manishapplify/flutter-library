class FirebaseUser {
  FirebaseUser({
    required this.id,
    this.name,
    this.pic,
    this.chatIds,
  });

  factory FirebaseUser.fromMap(Map<dynamic, dynamic> map) {
    final Set<String>? chatIds = map['chat_dialog_ids'] != null
        ? (map['chat_dialog_ids'] as Map<dynamic, dynamic>)
            .entries
            .map(
              (MapEntry<dynamic, dynamic> e) => (e.key as String),
            )
            .toSet()
        : null;

    return FirebaseUser(
      id: map['user_id'],
      name: map['user_name'],
      pic: map['user_pic'],
      chatIds: chatIds,
    );
  }

  final String id;
  final String? name;
  final String? pic;
  final Set<String>? chatIds;

  Map<String, dynamic> toFirebaseMap() {
    final Map<String, dynamic> data = <String, dynamic>{
      'user_id': id,
    };

    if (name is String) {
      data['user_name'] = name;
    }
    if (pic is String) {
      data['user_pic'] = pic;
    }
    if (chatIds is List<String> && chatIds!.isNotEmpty) {
      final Map<String, String> map = <String, String>{};
      for (String chatId in chatIds!) {
        map[chatId] = chatId;
      }

      data['chat_dialog_ids'] = map;
    }
    return data;
  }

  @override
  String toString() {
    return 'FirebaseUser(id: $id, name: $name, pic: $pic, chatIds: $chatIds)';
  }

  FirebaseUser copyWith({
    String? id,
    String? name,
    String? pic,
    Set<String>? chatIds,
  }) {
    return FirebaseUser(
      id: id ?? this.id,
      name: name ?? this.name,
      pic: pic ?? this.pic,
      chatIds: chatIds ?? this.chatIds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is FirebaseUser && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
