class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.profilePic,
    required this.age,
    required this.email,
    required this.countryCode,
    required this.phoneNumber,
    required this.registrationStep,
    required this.notificationEnabled,
    required this.address,
    required this.city,
    required this.isPhoneVerified,
    required this.isEmailVerified,
    required this.referralCode,
    required this.createdAt,
    required this.accessToken,
    required this.s3Folders,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final S3Folders s3Folders = S3Folders.fromJson(json['s3Folders']);

    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      profilePic: json['profilePic'],
      age: json['age'],
      email: json['email'],
      countryCode: json['countryCode'],
      phoneNumber: json['phoneNumber'],
      registrationStep: json['registrationStep'],
      notificationEnabled: json['notificationEnabled'],
      address: json['address'],
      city: json['city'],
      isPhoneVerified: json['isPhoneVerified'],
      isEmailVerified: json['isEmailVerified'],
      referralCode: json['referralCode'],
      createdAt: json['createdAt'],
      accessToken: json['accessToken'],
      s3Folders: s3Folders,
    );
  }

  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final String? profilePic;
  final int age;
  final String email;
  final String countryCode;
  final String phoneNumber;
  final int registrationStep;
  final int notificationEnabled;
  final String address;
  final String city;
  final int isPhoneVerified;
  final int isEmailVerified;
  final String referralCode;
  final String createdAt;
  final String accessToken;
  final S3Folders s3Folders;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['gender'] = this.gender;
    data['profilePic'] = this.profilePic;
    data['age'] = this.age;
    data['email'] = this.email;
    data['countryCode'] = this.countryCode;
    data['phoneNumber'] = this.phoneNumber;
    data['registrationStep'] = this.registrationStep;
    data['notificationEnabled'] = this.notificationEnabled;
    data['address'] = this.address;
    data['city'] = this.city;
    data['isPhoneVerified'] = this.isPhoneVerified;
    data['isEmailVerified'] = this.isEmailVerified;
    data['referralCode'] = this.referralCode;
    data['createdAt'] = this.createdAt;
    data['accessToken'] = this.accessToken;
    data['s3Folders'] = this.s3Folders.toJson();
    return data;
  }
}

class S3Folders {
  S3Folders({required this.users, required this.admin});

  factory S3Folders.fromJson(Map<String, dynamic> json) {
    return S3Folders(
      users: json['users'],
      admin: json['admin'],
    );
  }

  String users;
  String admin;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['users'] = this.users;
    data['admin'] = this.admin;
    return data;
  }
}
