part of 'bloc.dart';

@immutable
abstract class OtpEvent {}

class OtpChanged extends OtpEvent {
  OtpChanged(this.otp);

  final String otp;
}

class OtpSubmitted extends OtpEvent {}

class ResetFormStatus extends OtpEvent {}
