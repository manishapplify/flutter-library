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
  FailedAction({this.exception, this.message});
  final Exception? exception;
  final String? message;
}

class FailedLoggingOut extends FailedAction {
  FailedLoggingOut({Exception? exception, String? message})
      : super(
          exception: exception,
          message: message,
        );
}

class FailedDeletingAccount extends FailedAction {
  FailedDeletingAccount({Exception? exception, String? message})
      : super(
          exception: exception,
          message: message,
        );
}
