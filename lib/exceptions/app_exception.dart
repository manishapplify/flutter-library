class AppException implements Exception {
  AppException({
    this.message = 'Something went wrong',
  });

  factory AppException.authenticationException() {
    return AppException(message: 'User not authorized');
  }
  factory AppException.s3UrlParseException() {
    return AppException(message: 'Could not parse S3 uploadURL');
  }
  factory AppException.s3ImageUploadException() {
    return AppException(message: 'Could not upload image to S3');
  }
  factory AppException.googleSignInException() {
    return AppException(message: 'GoogleSigin failed');
  }
  factory AppException.passwordResetTokenAbsentException() {
    return AppException(message: 'No password reset token present');
  }
  factory AppException.unsupportedActionException() {
    return AppException(message: 'This action is not supported');
  }
  factory AppException.api400Exception({String? message}) {
    return AppException(message: message ?? 'Api request failed');
  }

  final String message;
}