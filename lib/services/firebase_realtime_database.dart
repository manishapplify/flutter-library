import 'package:components/cubits/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseRealtimeDatabase {
  FirebaseRealtimeDatabase() {
    _database = FirebaseDatabase.instance;
  }

  final String _userCollection = 'Users';
  late final FirebaseDatabase _database;

  Future<void> addUser(User user) async {
    final DatabaseReference usersReference =
        _database.ref(_userCollection + '/ID_${user.id}');

    await usersReference.set(
      user.toFirebaseMap(),
    );
  }

  Future<void> removeUser(User user) async {
    final DatabaseReference usersReference =
        _database.ref(_userCollection + '/ID_${user.id}');

    await usersReference.remove();
  }
}
