// ignore_for_file: constant_identifier_names

enum Gender {
  Male,
  Female,
  Other,
  NA,
}

Gender genderFromString(String gender) {
  switch (gender) {
    case 'Male':
      return Gender.Male;
    case 'Female':
      return Gender.Female;
    case 'Other':
      return Gender.Other;
    case 'NA':
      return Gender.NA;
  }

  return Gender.NA;
}
