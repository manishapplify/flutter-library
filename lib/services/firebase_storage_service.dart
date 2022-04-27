import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

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

  Future<String?> _uploadFile({
    required File file,
    required String messageId,
    required String path,
  }) async {
    final Reference reference = storage.ref(path + messageId);
    await reference.putFile(file);

    final String? url = await reference.getDownloadURL();
    return url;
  }
}
