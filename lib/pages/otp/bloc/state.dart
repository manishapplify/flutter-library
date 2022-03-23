part of 'bloc.dart';

@immutable
class OtpState {
  const OtpState({
    this.otp,
    this.formStatus = const InitialFormStatus(),
  });
  final String? otp;
  final FormSubmissionStatus formStatus;

  bool get isOtpValid => otp is String && otp!.length == 4;

  OtpState copyWith({
    String? otp,
    FormSubmissionStatus? formStatus,
  }) {
    return OtpState(
      otp: otp ?? this.otp,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
