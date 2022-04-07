import 'package:components/cubits/models/user.dart';
import 'package:components/services/firebase_realtime_database/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseRealtimeDatabase {
  FirebaseRealtimeDatabase() {
    _database = FirebaseDatabase.instance;
  }

  final String _userCollection = 'Users';
  late final FirebaseDatabase _database;

  Future<void> addUser(User user) async {
    final DatabaseReference userReference =
        _database.ref(_userCollection + '/ID_${user.id}');

    await userReference.set(
      user.toFirebaseMap(),
    );
  }

  Future<void> removeUser(User user) async {
    final DatabaseReference userReference =
        _database.ref(_userCollection + '/ID_${user.id}');

    await userReference.remove();
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
}
