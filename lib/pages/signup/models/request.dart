class SignupRequest {
  SignupRequest({
    required this.profilePic,
    required this.firstName,
    required this.lastName,
    required this.countryCode,
    required this.phoneNumber,
    required this.email,
    required this.password,
    this.referralCode,
  });

  final String profilePic;
  final String firstName;
  final String lastName;
  final String countryCode;
  final String phoneNumber;
  final String email;
  final String password;
  String? referralCode;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'profilePic': profilePic,
        'firstName': firstName,
        'lastName': lastName,
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
        'referralCode': referralCode,
      };
}
