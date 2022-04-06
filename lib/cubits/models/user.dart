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

  User copyWithJson(Map<String, dynamic> json) {
    final S3Folders? s3Folders = json['s3Folders'] == null
        ? null
        : S3Folders.fromJson(json['s3Folders']);

    return User(
      id: json['id'] ?? this.id,
      firstName: json['firstName'] ?? this.firstName,
      lastName: json['lastName'] ?? this.lastName,
      gender: json['gender'] ?? this.gender,
      profilePic: json['profilePic'] ?? this.profilePic,
      age: json['age'] ?? this.age,
      email: json['email'] ?? this.email,
      countryCode: json['countryCode'] ?? this.countryCode,
      phoneNumber: json['phoneNumber'] ?? this.phoneNumber,
      registrationStep: json['registrationStep'] ?? this.registrationStep,
      notificationEnabled:
          json['notificationEnabled'] ?? this.notificationEnabled,
      address: json['address'] ?? this.address,
      city: json['city'] ?? this.city,
      isPhoneVerified: json['isPhoneVerified'] ?? this.isPhoneVerified,
      isEmailVerified: json['isEmailVerified'] ?? this.isEmailVerified,
      referralCode: json['referralCode'] ?? this.referralCode,
      createdAt: json['createdAt'] ?? this.createdAt,
      accessToken: json['accessToken'] ?? this.accessToken,
      s3Folders: s3Folders ?? this.s3Folders,
    );
  }

  final String id;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? profilePic;
  final int? age;
  final String? email;
  final String? countryCode;
  final String? phoneNumber;
  final int registrationStep;
  final int notificationEnabled;
  final String? address;
  final String? city;
  final int isPhoneVerified;
  final int isEmailVerified;
  final String? referralCode;
  final String createdAt;
  final String accessToken;
  final S3Folders s3Folders;

  String? get fullName {
    if (firstName is String && lastName is String) {
      return firstName! + ' ' + lastName!;
    } else if (firstName is String) {
      return firstName!;
    } else if (lastName is String) {
      return lastName!;
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': this.id,
      'registrationStep': this.registrationStep,
      'notificationEnabled': this.notificationEnabled,
      'isPhoneVerified': this.isPhoneVerified,
      'isEmailVerified': this.isEmailVerified,
      'createdAt': this.createdAt,
      'accessToken': this.accessToken,
      's3Folders': this.s3Folders.toJson(),
    };

    if (firstName is String) {
      data['firstName'] = this.firstName;
    }
    if (lastName is String) {
      data['lastName'] = this.lastName;
    }
    if (gender is String) {
      data['gender'] = this.gender;
    }
    if (profilePic is String) {
      data['profilePic'] = this.profilePic;
    }
    if (age is int) {
      data['age'] = this.age;
    }
    if (email is String) {
      data['email'] = this.email;
    }
    if (countryCode is String) {
      data['countryCode'] = this.countryCode;
    }
    if (phoneNumber is String) {
      data['phoneNumber'] = this.phoneNumber;
    }
    if (address is String) {
      data['address'] = this.address;
    }
    if (city is String) {
      data['city'] = this.city;
    }
    if (referralCode is String) {
      data['referralCode'] = this.referralCode;
    }
    return data;
  }

  Map<String, dynamic> toFirebaseMap() {
    final Map<String, dynamic> data = <String, dynamic>{
      'user_id': 'ID_' + this.id,
    };

    if (fullName is String) {
      data['user_name'] = fullName;
    }
    if (profilePic is String) {
      final String fileName = profilePic!.split('/').last;
      data['user_pic'] = fileName;
    }
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
