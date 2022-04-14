import 'package:components/cubits/models/user.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:components/services/firebase_realtime_database/models/message.dart';
import 'package:components/services/firebase_realtime_database/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseRealtimeDatabase {
  FirebaseRealtimeDatabase() {
    _database = FirebaseDatabase.instance;
  }

  final String _userCollection = 'Users/';
  final String _chatsCollection = 'Chats/';
  final String _messagesCollection = 'Messages/';
  final String _notificationsCollection = 'Notifications/';
  late final FirebaseDatabase _database;

  Future<void> addUser(User user) async {
    final DatabaseReference userReference =
        _database.ref(_userCollection + user.firebaseId);
    if (!(await userReference.once()).snapshot.exists) {
      await userReference.set(
        user.toFirebaseMap(),
      );
    }
  }

  Future<void> removeUser({
    User? user,
    String? firebaseId,
  }) async {
    final DatabaseReference userReference =
        _database.ref(_userCollection + (user?.firebaseId ?? firebaseId!));

    await userReference.remove();
  }

  Future<void> updateUser(FirebaseUser firebaseUser) async {
    final DatabaseReference userReference =
        _database.ref(_userCollection + firebaseUser.id);

    await userReference.set(firebaseUser.toMap());
  }

  Future<FirebaseUser?> getFirebaseUser({
    User? user,
    String? firebaseId,
  }) async {
    final DatabaseReference userReference =
        _database.ref(_userCollection + (user?.firebaseId ?? firebaseId!));
    final DatabaseEvent event = await userReference.once();

    if (event.snapshot.value != null) {
      return FirebaseUser.fromMap(
          event.snapshot.value as Map<dynamic, dynamic>);
    }

    return null;
  }

  Future<List<FirebaseUser>> getUsers() async {
    final DatabaseReference usersReference = _database.ref(_userCollection);

    final DatabaseEvent event = await usersReference.once();
    List<FirebaseUser> users = <FirebaseUser>[];
    if (event.snapshot.value != null) {
      final Map<dynamic, dynamic> map =
          event.snapshot.value as Map<dynamic, dynamic>;

      users = map.entries
          .map(
            (MapEntry<dynamic, dynamic> e) => FirebaseUser.fromMap(e.value),
          )
          .toList();
    }

    return users;
  }

  Future<Set<FirebaseChat>> getChats(Set<String> chatIds) async {
    final Set<FirebaseChat> chats = <FirebaseChat>{};

    for (final String chatId in chatIds) {
      final DatabaseReference chatReference =
          _database.ref(_chatsCollection + chatId);
      final DatabaseEvent event = await chatReference.once();

      if (event.snapshot.value != null) {
        final Map<dynamic, dynamic> map =
            event.snapshot.value as Map<dynamic, dynamic>;
        chats.add(FirebaseChat.fromMap(map));
      }
    }
    return chats;
  }

  /// Returns a map of streams according to the following scheme {ChatId: Stream}
  Map<String, Stream<Set<FirebaseMessage>>> getChatMessagesSubscription(
      Set<String> chatIds) {
    final Map<String, Stream<Set<FirebaseMessage>>> streams =
        <String, Stream<Set<FirebaseMessage>>>{};
    for (final String chatId in chatIds) {
      streams[chatId] = _database
          .ref(_messagesCollection + chatId)
          .onValue
          .map(_parseMessagesDatabaseEvent);
    }

    return streams;
  }

  /// Creates a new chat between [firebaseUserA] and [firebaseUserB], if not
  /// present already.
  Future<FirebaseChat> addChatIfNotExists({
    required FirebaseUser firebaseUserA,
    required FirebaseUser firebaseUserB,
  }) async {
    // Sort users.
    if (firebaseUserA.id.compareTo(firebaseUserB.id) > 0) {
      final FirebaseUser temp = firebaseUserA;
      firebaseUserA = firebaseUserB;
      firebaseUserB = temp;
    }

    final String chatId = '${firebaseUserA.id},${firebaseUserB.id}';

    final DatabaseReference chatReference =
        _database.ref(_chatsCollection + chatId);
    final DatabaseEvent event = await chatReference.once();

    if (event.snapshot.exists) {
      final FirebaseChat chat =
          FirebaseChat.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      return chat;
    } else {
      final FirebaseUser _firebaseUserA =
          (await getFirebaseUser(firebaseId: firebaseUserA.id))!;
      final FirebaseUser _firebaseUserB =
          (await getFirebaseUser(firebaseId: firebaseUserB.id))!;

      Map<String, String>? participantProfileImages;
      if (_firebaseUserA.pic != null && _firebaseUserB.pic != null) {
        participantProfileImages = <String, String>{};
        participantProfileImages[_firebaseUserA.id] = _firebaseUserA.pic!;
        participantProfileImages[_firebaseUserB.id] = _firebaseUserB.pic!;
      } else if (_firebaseUserA.pic != null) {
        participantProfileImages = <String, String>{};
        participantProfileImages[_firebaseUserA.id] = _firebaseUserA.pic!;
      } else if (_firebaseUserB.pic != null) {
        participantProfileImages = <String, String>{};
        participantProfileImages[_firebaseUserB.id] = _firebaseUserB.pic!;
      }

      final FirebaseChat chat = FirebaseChat(
        id: chatId,
        participantIds: <String>{_firebaseUserA.id, _firebaseUserB.id},
        participantNames: <String, String>{
          _firebaseUserA.id: _firebaseUserA.name ?? 'anonymous',
          _firebaseUserB.id: _firebaseUserB.name ?? 'anonymous',
        },
        participantProfileImages: participantProfileImages,
      );

      // Create new chat.
      await chatReference.set(
        chat.toMap(),
      );

      // Update users.
      await updateUser(
        _firebaseUserA.copyWith(
          chatIds: <String>{
            ..._firebaseUserA.chatIds ?? <String>{},
            chat.id,
          },
        ),
      );
      await updateUser(
        _firebaseUserB.copyWith(
          chatIds: <String>{
            ..._firebaseUserB.chatIds ?? <String>{},
            chat.id,
          },
        ),
      );

      return chat;
    }
  }

  Future<void> removeChat({
    FirebaseChat? chat,
    String? chatId,
  }) async {
    final String _chatId = (chat?.id ?? chatId!);

    final DatabaseReference chatReference =
        _database.ref(_chatsCollection + _chatId);
    final DatabaseReference messagesReference =
        _database.ref(_messagesCollection + _chatId);

    await chatReference.remove();
    await messagesReference.remove();

    final List<String> userIds = _chatId.split(',');

    for (String userId in userIds) {
      final FirebaseUser? user = await getFirebaseUser(firebaseId: userId);
      if (user is FirebaseUser &&
          user.chatIds is Set<String> &&
          user.chatIds!.isNotEmpty &&
          user.chatIds!.contains(_chatId)) {
        final Set<String> updatedChatList = user.chatIds!..remove(_chatId);
        await updateUser(user.copyWith(
          chatIds: updatedChatList,
        ));
      }
    }
  }

  Future<Set<FirebaseMessage>> getMessages(String chatId) async {
    final DatabaseReference messagesReference =
        _database.ref(_messagesCollection + chatId);

    final DatabaseEvent event = await messagesReference.once();
    return _parseMessagesDatabaseEvent(event);
  }

  Future<FirebaseMessage> sendMessage({
    required String textMessage,
    required String chatId,
    required String senderId,
  }) async {
    final DatabaseReference messageReference =
        _database.ref(_messagesCollection + chatId).push();
    final String? messageId = messageReference.key;
    if (messageId is String) {
      final DateTime dateTime = DateTime.now().toUtc();
      final String receiverId =
          chatId.split(',').firstWhere((String id) => id != senderId);

      final FirebaseMessage message = FirebaseMessage(
        message: textMessage,
        chatDialogId: chatId,
        messageId: messageId,
        messageTime: dateTime,
        firebaseMessageTime: dateTime,
        messageReadStatus: receiverId,
        messageType: 1,
        receiverId: receiverId,
        senderId: senderId,
      );

      // Update message reference.
      await messageReference.set(message.toMap());

      // Update corresponding chat.
      final FirebaseChat chat = (await getChats(<String>{chatId})).first;
      await _updateChatOnMessageSend(
        chat: chat,
        message: message,
      );

      // Update notifications collection.
      await _updateNotificationsCollectionOnMessageSend(message);

      return message;
    } else {
      throw AppException.firebaseCouldNotGenerateKey();
    }
  }

  Future<void> _updateChatOnMessageSend({
    required FirebaseChat chat,
    required FirebaseMessage message,
  }) async {
    final DatabaseReference chatReference =
        _database.ref(_chatsCollection + chat.id);

    final FirebaseChat latestChat = chat.copyWith(
      lastMessage: message.message,
      lastMessageId: message.messageId,
      lastMessageSenderId: message.senderId,
      lastMessageTime: message.messageTime,
      lastMessageType: message.messageType,
    );

    await chatReference.set(
      latestChat.toMap(),
    );
  }

  Future<void> _updateNotificationsCollectionOnMessageSend(
      FirebaseMessage message) async {
    final DatabaseReference notificationsReference =
        _database.ref(_notificationsCollection + message.messageId);

    await notificationsReference.set(message.toMap());
  }

  Set<FirebaseMessage> _parseMessagesDatabaseEvent(DatabaseEvent event) {
    Set<FirebaseMessage> messages = <FirebaseMessage>{};
    if (event.snapshot.value != null) {
      final Map<dynamic, dynamic> map =
          event.snapshot.value as Map<dynamic, dynamic>;

      final List<FirebaseMessage> _messages = map.entries
          .map(
            (MapEntry<dynamic, dynamic> e) => FirebaseMessage.fromMap(e.value),
          )
          .toList()
        ..sort(((FirebaseMessage a, FirebaseMessage b) =>
            a.messageTime.compareTo(b.messageTime)));

      messages = _messages.toSet();
    }

    return messages;
  }
}
