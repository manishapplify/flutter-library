class VerifyForgetPasswordOtpRequest {
  VerifyForgetPasswordOtpRequest({
    required this.token,
    required this.forgotPasswordOtp,
  });

  final String token;
  final String forgotPasswordOtp;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'token': token,
        'forgotPasswordOtp': forgotPasswordOtp,
      };
}
