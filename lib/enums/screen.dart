enum Screen {
  registerUser,
  editProfile,
  signup,
}

extension Ex on Screen {
  String screenName() {
    switch (this) {
      case Screen.registerUser:
       return 'Setup Profile';
      case Screen.editProfile:
       return 'Edit Profile';
      case Screen.signup:
       return 'Signup';
    }
  }
}
