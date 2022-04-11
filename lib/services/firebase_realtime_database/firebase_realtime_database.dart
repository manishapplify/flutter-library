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

  Future<void> removeUser(User user) async {
    final DatabaseReference userReference =
        _database.ref(_userCollection + user.firebaseId);

    await userReference.remove();
  }

  Future<FirebaseUser?> getFirebaseUser(User user) async {
    final DatabaseReference userReference =
        _database.ref(_userCollection + user.firebaseId);
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

    final String chaId = '${firebaseUserA.id},${firebaseUserB.id}';

    final DatabaseReference chatReference =
        _database.ref(_chatsCollection + chaId);
    final DatabaseEvent event = await chatReference.once();

    if (event.snapshot.exists) {
      final FirebaseChat chat =
          FirebaseChat.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
      return chat;
    } else {
      Map<String, String>? participantProfileImages;
      if (firebaseUserA.pic != null && firebaseUserB.pic != null) {
        participantProfileImages = <String, String>{};
        participantProfileImages[firebaseUserA.id] = firebaseUserA.pic!;
        participantProfileImages[firebaseUserB.id] = firebaseUserB.pic!;
      } else if (firebaseUserA.pic != null) {
        participantProfileImages = <String, String>{};
        participantProfileImages[firebaseUserA.id] = firebaseUserA.pic!;
      } else if (firebaseUserB.pic != null) {
        participantProfileImages = <String, String>{};
        participantProfileImages[firebaseUserB.id] = firebaseUserB.pic!;
      }

      final FirebaseChat chat = FirebaseChat(
        id: chaId,
        participantIds: <String>{firebaseUserA.id, firebaseUserB.id},
        participantNames: <String, String>{
          firebaseUserA.id: firebaseUserA.name ?? 'anonymous',
          firebaseUserB.id: firebaseUserB.name ?? 'anonymous',
        },
        participantProfileImages: participantProfileImages,
      );

      await chatReference.set(
        chat.toFirebaseMap(),
      );

      return chat;
    }
  }
}
