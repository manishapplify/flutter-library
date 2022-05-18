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
    return AppException(message: 'Google sigin failed');
  }
  factory AppException.facebookSignInException(String? message) {
    return AppException(message: message ?? 'Facebook sigin failed');
  }
  factory AppException.appleSignInException() {
    return AppException(message: 'Apple sigin failed');
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
  factory AppException.firebaseCouldNotGenerateKey() {
    return AppException(message: 'Firebase could not generate unique key');
  }
  factory AppException.couldNotLoadChats() {
    return AppException(message: 'Could not load your chats');
  }
  factory AppException.noChatsPresent() {
    return AppException(message: 'You have no chats');
  }
  factory AppException.unknownMessageType() {
    return AppException(message: 'Unkown message type');
  }
  factory AppException.messageCannotBeEmpty() {
    return AppException(message: 'Message cannot be empty');
  }
  factory AppException.currentChatRemoved() {
    return AppException(message: 'This chat has been removed, going back');
  }
  factory AppException.imageCannotBeEmpty() {
    return AppException(message: 'Image cannot be empty');
  }
  factory AppException.imageCouldNotBeUploaded() {
    return AppException(message: 'Image could not be uploaded');
  }
  factory AppException.docCannotBeEmpty() {
    return AppException(message: 'Document cannot be empty');
  }
  factory AppException.documentCouldNotBeUploaded() {
    return AppException(message: 'Document could not be uploaded');
  }
  factory AppException.documentCouldNotBeDownloaded() {
    return AppException(message: 'Document could not be downloaded');
  }
  factory AppException.otpCannotBeEmpty() {
    return AppException(message: 'Please Enter OTP');
  }
  factory AppException.otpvalid() {
    return AppException(message: 'Please enter valid otp');
  }
  factory AppException.imageCouldNotBeCropped() {
    return AppException(message: 'Image could not be cropped');
  }
  factory AppException.imageCouldNotBePicked() {
    return AppException(message: 'Image could not be picked');
  }

  final String message;
}
