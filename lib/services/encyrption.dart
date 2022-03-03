import 'package:encrypt/encrypt.dart' as encrypt;

class MyEncryptionDecryption {
  //For AES Encryption/Decryption
  static final encrypt.Key key = encrypt.Key.fromLength(32);
  final encrypt.IV iv = encrypt.IV.fromLength(16);
  final encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(key));

  encrypt.Encrypted encryptAES(dynamic text) {
    final encrypt.Encrypted encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted;
  }
}
