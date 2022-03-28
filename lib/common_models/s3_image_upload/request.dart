class S3ImageUploadRequest {
  S3ImageUploadRequest({
    required this.directory,
    required this.fileName,
    this.contentType,
  });

  factory S3ImageUploadRequest.fromMap(Map<String, dynamic> map) {
    return S3ImageUploadRequest(
      directory: map['directory'] ?? '',
      fileName: map['fileName'] ?? '',
      contentType: map['contentType'],
    );
  }

  String directory;
  String fileName;

  /// contentType of file, if file is not an image
  String? contentType;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{
      'directory': directory,
      'fileName': fileName,
    };

    if (contentType is String) {
      map['contentType'] = contentType;
    }

    return map;
  }
}
