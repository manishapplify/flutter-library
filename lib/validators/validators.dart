final RegExp _emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

final RegExp _phoneNumberRegExp = RegExp(r'^\d{3,}$');

bool isValidEmail(String? email) =>
    notEmptyValidator(email) && _emailRegExp.hasMatch(email!);

bool isValidPassword(String? password) =>
    notEmptyValidator(password) && password!.length > 6;

bool isValidPhoneNumber(String? phoneNumber) =>
    notEmptyValidator(phoneNumber) && _phoneNumberRegExp.hasMatch(phoneNumber!);

bool notEmptyValidator(String? s) =>
    s != null && s.isNotEmpty && s.trimRight().isNotEmpty;
