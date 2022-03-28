class UpdateProfileRequest {
  UpdateProfileRequest({
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

  final String? firstName;
  final String? lastName;
  final String? countryCode;
  final String? phoneNumber;
  final String? email;
  final String? gender;
  final String? profilePic;
  final int? age;
  final String? address;
  final String? city;
  final String notificationEnabled;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{
      'notificationEnabled': notificationEnabled,
    };

    if (firstName is String) {
      map['firstName'] = firstName;
    }
    if (lastName is String) {
      map['lastName'] = lastName;
    }
    if (countryCode is String) {
      map['countryCode'] = countryCode;
    }
    if (phoneNumber is String) {
      map['phoneNumber'] = phoneNumber;
    }
    if (email is String) {
      map['email'] = email;
    }
    if (gender is String) {
      map['gender'] = gender;
    }
    if (profilePic is String) {
      map['profilePic'] = profilePic;
    }
    if (age is int) {
      map['age'] = age;
    }
    if (address is String) {
      map['address'] = address;
    }
    if (city is String) {
      map['city'] = city;
    }

    return map;
  }
}
