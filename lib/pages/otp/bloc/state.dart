part of 'bloc.dart';

@immutable
class OtpState {
  const OtpState({
    required this.screenType,
    this.otp,
    this.formStatus = const Idle(),
  });
  final String? otp;
  final WorkStatus formStatus;
  final Screen screenType;

  bool get isOtpValid => otp is String && otp!.length == 4;
  bool get isOtpEmpty => !validators.notEmptyValidator(otp);

  OtpState copyWith({
    String? otp,
    WorkStatus? formStatus,
  }) {
    return OtpState(
      otp: otp ?? this.otp,
      formStatus: formStatus ?? this.formStatus,
      screenType: this.screenType,
    );
  }
}
