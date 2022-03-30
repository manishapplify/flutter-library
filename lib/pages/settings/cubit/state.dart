part of 'cubit.dart';

@immutable
abstract class SettingsState {}

class InitialState extends SettingsState {}

abstract class PerformingAction extends SettingsState {}

class LoggingOut extends PerformingAction {}

class DeletingAccount extends PerformingAction {}

abstract class CompletedAction extends SettingsState {}

class LogdedOut extends CompletedAction {}

class DeletedAccount extends CompletedAction {}

abstract class FailedAction extends SettingsState {
  FailedAction({this.exception});
  final Exception? exception;
}

class FailedLoggingOut extends FailedAction {
  FailedLoggingOut({Exception? exception}) : super(exception: exception);
}

class FailedDeletingAccount extends FailedAction {
  FailedDeletingAccount({Exception? exception}) : super(exception: exception);
}
