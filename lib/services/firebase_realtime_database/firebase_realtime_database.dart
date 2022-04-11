import 'package:components/cubits/models/user.dart';
import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:components/services/firebase_realtime_database/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseRealtimeDatabase {
  FirebaseRealtimeDatabase() {
    _database = FirebaseDatabase.instance;
  }

  final String _userCollection = 'Users/';
  final String _chatsCollection = 'Chats/';
  late final FirebaseDatabase _database;

  Future<void> addUser(User user) async {
    final DatabaseReference userReference =
        _database.ref(_userCollection + user.firebaseId);

    await userReference.set(
      user.toFirebaseMap(),
    );
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

    await userReference.set(firebaseUser.toFirebaseMap());
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

  Future<List<FirebaseChat>> getChats(List<String> chatIds) async {
    final List<FirebaseChat> chats = <FirebaseChat>[];

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

  /// Creates a new chat between [_firebaseUserA] and [_firebaseUserB], if not
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

    final String chaId = '${firebaseUserA.id},${firebaseUserB.id}';

    final DatabaseReference chatReference =
        _database.ref(_chatsCollection + chaId);
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
        id: chaId,
        participantIds: <String>{_firebaseUserA.id, _firebaseUserB.id},
        participantNames: <String, String>{
          _firebaseUserA.id: _firebaseUserA.name ?? 'anonymous',
          _firebaseUserB.id: _firebaseUserB.name ?? 'anonymous',
        },
        participantProfileImages: participantProfileImages,
      );

      // Create new chat.
      await chatReference.set(
        chat.toFirebaseMap(),
      );

      // Update users.
      await updateUser(
        _firebaseUserA.copyWith(
          chatIds: <String>[
            ..._firebaseUserA.chatIds ?? <String>[],
            chat.id,
          ],
        ),
      );
      await updateUser(
        _firebaseUserB.copyWith(
          chatIds: <String>[
            ..._firebaseUserB.chatIds ?? <String>[],
            chat.id,
          ],
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

    await chatReference.remove();

    final List<String> userIds = _chatId.split(',');

    for (String userId in userIds) {
      final FirebaseUser? user = await getFirebaseUser(firebaseId: userId);
      if (user is FirebaseUser &&
          user.chatIds is List<String> &&
          user.chatIds!.isNotEmpty &&
          user.chatIds!.contains(_chatId)) {
        final List<String> updatedChatList = user.chatIds!..remove(_chatId);
        await updateUser(user.copyWith(
          chatIds: updatedChatList,
        ));
      }
    }
  }
}
