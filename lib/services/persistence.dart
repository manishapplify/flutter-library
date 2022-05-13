import 'dart:convert';

import 'package:components/cubits/models/forgot_password.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/services/firebase_realtime_database/models/message/message.dart';
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

  Future<void> saveNotifications(Set<FirebaseMessage> notifications) async {
    final List<String> encodedNotificaions = <String>[];
    for (FirebaseMessage notification in notifications) {
      encodedNotificaions.add(jsonEncode(notification.toMap()));
    }
    _preferences.setStringList(_notification, encodedNotificaions);
  }

  Set<FirebaseMessage>? fetchNotifications() {
    final List<String>? jsonList = _preferences.getStringList(_notification);

    final Set<FirebaseMessage> decodedNotificaions = <FirebaseMessage>{};
    for (String element in jsonList!) {
      decodedNotificaions.add(FirebaseMessage.fromMap(jsonDecode(element)));
    }
    return decodedNotificaions;
  }

  Future<void> deleteUser() => _preferences.remove(_user);

  Future<bool> saveCountryCode(String countryCode) =>
      _preferences.setString(_countryCode, countryCode);

  String? fetchCountryCode() => _preferences.getString(_countryCode);

  Future<void> deleteCountryCode() => _preferences.remove(_countryCode);

  Future<bool> saveForgotPasswordToken(
          ForgotPasswordToken forgotPasswordToken) =>
      _preferences.setString(
          _forgotPasswordToken, jsonEncode(forgotPasswordToken.toJson()));

  ForgotPasswordToken? fetchForgotPasswordToken() {
    final String? json = _preferences.getString(_forgotPasswordToken);

    if (json is String) {
      return ForgotPasswordToken.fromJson(jsonDecode(json));
    }
    return null;
  }

  Future<void> deleteForgotPasswordToken() =>
      _preferences.remove(_forgotPasswordToken);
}

const String _user = 'user';
const String _countryCode = 'countryCode';
const String _forgotPasswordToken = 'forgotPasswordToken';
const String _notification = 'notification';
