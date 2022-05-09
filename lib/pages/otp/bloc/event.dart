part of blocs;


abstract class OtpEvent extends BaseEvent {}

class OtpChanged extends OtpEvent {
  OtpChanged(this.otp);

  final String otp;
}

class OtpSubmitted extends OtpEvent {}

class ResetOtpFormStatus extends OtpEvent {}
