import 'package:encrypt/encrypt.dart' as encrypt;

// ignore: avoid_classes_with_only_static_members
class MyEncryptionDecryption {
  //For AES Encryption/Decryption
  static final encrypt.Key key = encrypt.Key.fromLength(32);
  static final encrypt.IV iv = encrypt.IV.fromLength(16);
  static final encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(key));

  static encrypt.Encrypted encryptAES(dynamic text) {
    final encrypt.Encrypted encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted;
  }

}