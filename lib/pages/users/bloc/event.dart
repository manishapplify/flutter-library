part of 'bloc.dart';

@immutable
abstract class UsersEvent {}

class GetUsersEvent extends UsersEvent {}

class MessageIconTapEvent extends UsersEvent {
  MessageIconTapEvent({
    required this.firebaseUserA,
    required this.firebaseUserB,
  });

  final FirebaseUser firebaseUserA;
  final FirebaseUser firebaseUserB;
}

class ResetChatState extends UsersEvent {}
