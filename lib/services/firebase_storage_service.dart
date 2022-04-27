import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final String _imagePath = 'chat_uploads/';
  final String _documentPath = 'chat_uploads/files/';

  Future<String?> uploadImage({
    required File file,
    required String messageId,
  }) =>
      _uploadFile(file: file, messageId: messageId, path: _imagePath);

  Future<String?> uploadPdf({
    required File file,
    required String messageId,
  }) =>
      _uploadFile(file: file, messageId: messageId, path: _documentPath);

  Future<String?> uploadDocFile(File? filePath, String messageId) async {
    String? url;
    try {
      final Reference reference =
          _storage.ref("chat_uploads/files/$messageId.pdf");
      await reference.putData(filePath!.readAsBytesSync());
      url = await reference.getDownloadURL();
    } on FirebaseException catch (e) {
      print(e);
    }
    return url;
  }

  Future<String?> _uploadFile({
    required File file,
    required String messageId,
    required String path,
  }) async {
    final Reference reference = _storage.ref(path + messageId);
    await reference.putFile(file);

    final String? url = await reference.getDownloadURL();
    return url;
  }
}
