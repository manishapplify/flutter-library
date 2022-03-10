import 'dart:convert';

import 'package:components/cubits/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Persistence {
  Persistence({required SharedPreferences sharedPreferences})
      : _preferences = sharedPreferences;

  final SharedPreferences _preferences;

  Future<bool> saveUser(User user) =>
      _preferences.setString(_user, jsonEncode(user.toJson()));
  User? fetchUser() {
    final String? json = _preferences.getString(_user);

    if (json is String) {
      return User.fromJson(jsonDecode(json));
    }
    return null;
  }

  Future<void> deleteUser() => _preferences.remove(_user);
}

const String _user = 'user';
