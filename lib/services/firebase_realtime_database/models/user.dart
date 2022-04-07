class FirebaseUser {
  FirebaseUser({
    required this.id,
    this.name,
    this.pic,
    this.chatIds,
  });
  
  factory FirebaseUser.fromMap(Map<dynamic, dynamic> map) {
    final List<String>? chatIds = map['chat_dialog_ids'] != null
        ? (map['chat_dialog_ids'] as Map<dynamic, dynamic>)
            .entries
            .map(
              (MapEntry<dynamic, dynamic> e) => (e.key as String),
            )
            .toList()
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
  final List<String>? chatIds;

  @override
  String toString() {
    return 'FirebaseUser(id: $id, name: $name, pic: $pic, chatIds: $chatIds)';
  }
}
