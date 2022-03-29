enum Screen {
  registerUser,
  updateProfile,
  signup,
  forgotPassword,
  verifyEmail,
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
      case Screen.forgotPassword:
        return 'Forgot Password';
      case Screen.verifyEmail:
        return 'Verify Email';
    }
  }
}
