part of blocs;

abstract class UsersEvent extends BaseEvent {}

class GetUsersEvent extends UsersEvent {}

class MessageIconTapEvent extends UsersEvent {
  MessageIconTapEvent({
    required this.firebaseUserA,
    required this.firebaseUserB,
  });

  final FirebaseUser firebaseUserA;
  final FirebaseUser firebaseUserB;
}

class QueryChangedEvent extends UsersEvent {
  QueryChangedEvent({required this.query});

  final String query;
}

class ResetChatState extends UsersEvent {}
