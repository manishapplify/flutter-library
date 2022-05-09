part of blocs;

class OtpState extends BaseState {
  const OtpState({
    required this.screenType,
    this.otp,
    WorkStatus blocStatus = const Idle(),
  }) : super(blocStatus);
  final String? otp;
  final Screen screenType;

  bool get isOtpValid => otp is String && otp!.length == 4;
  bool get isOtpEmpty => !validators.notEmptyValidator(otp);

  OtpState copyWith({
    String? otp,
    WorkStatus? blocStatus,
  }) {
    return OtpState(
      otp: otp ?? this.otp,
      blocStatus: blocStatus ?? this.blocStatus,
      screenType: this.screenType,
    );
  }

  @override
  BaseState resetState() => OtpState(screenType: screenType);

  @override
  BaseState updateStatus(WorkStatus blocStatus) =>
      this.copyWith(blocStatus: blocStatus);
}
