import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageServices {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> uploadImageFile(File? filePath, String messageId) async {
    String? url;
    try {
      final Reference reference = storage.ref("chat_uploads/$messageId");

      await reference.putFile(File(filePath!.path));

      url = await reference.getDownloadURL();
    } on FirebaseException catch (e) {
      print(e);
    }
    return url;
  }
}
