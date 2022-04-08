part of 'bloc.dart';

@immutable
abstract class UsersEvent {}

class GetUsersEvent extends UsersEvent {}

class MessageIconTapEvent extends UsersEvent {
  MessageIconTapEvent({required this.chatID});
  final String chatID;
}
