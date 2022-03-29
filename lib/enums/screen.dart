enum Screen {
  registerUser,
  updateProfile,
  signup,
}

extension Ex on Screen {
  String screenName() {
    switch (this) {
      case Screen.registerUser:
       return 'Setup Profile';
      case Screen.updateProfile:
       return 'Edit Profile';
      case Screen.signup:
       return 'Signup';
    }
  }
}
