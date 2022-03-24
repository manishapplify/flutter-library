class UpdateProfileRequest {
  UpdateProfileRequest({
    required this.authToken,
    required this.firstName,
    required this.lastName,
    required this.countryCode,
    required this.phoneNumber,
    required this.email,
    required this.gender,
    required this.profilePic,
    required this.age,
    required this.address,
    required this.city,
    required this.notificationEnabled,
  });

  final String authToken;
  final String firstName;
  final String lastName;
  final String countryCode;
  final String phoneNumber;
  final String email;
  final String gender;
  final String profilePic;
  final int age;
  final String address;
  final String city;
  final String notificationEnabled;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'authToken': authToken,
        'firstName': firstName,
        'lastName': lastName,
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
        'email': email,
        'gender': gender,
        'profilePic': profilePic,
        'age': age,
        'address': address,
        'city': city,
        'notificationEnabled': notificationEnabled,
      };
}
