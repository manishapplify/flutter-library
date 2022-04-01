import 'dart:io';
import 'package:components/Authentication/form_submission.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/enums/gender.dart';
import 'package:components/enums/screen.dart';
import 'package:components/pages/profile/bloc/bloc.dart';
import 'package:components/routes/navigation.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:components/base/base_page.dart';
import 'package:components/dialogs/dialogs.dart';
import 'package:components/widgets/image_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends BasePage {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState extends BasePageState<ProfilePage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late final FocusNode firstNameFocusNode;
  late final FocusNode lastNameFocusNode;
  late final FocusNode emailFocusNode;
  late final FocusNode phoneFocusNode;
  late final FocusNode ageFocusNode;
  late final FocusNode addressFocusNode;
  late final FocusNode cityFocusNode;
  late final TextEditingController firstNameTextEditingController;
  late final TextEditingController lastNameTextEditingController;
  late final TextEditingController emailTextEditingController;
  late final TextEditingController phoneTextEditingController;
  late final TextEditingController ageTextEditingController;
  late final TextEditingController addressTextEditingController;
  late final TextEditingController cityTextEditingController;
  late final ProfileBloc profileBloc;
  final List<DropdownMenuItem<Gender>> genderOptions =
      List<DropdownMenuItem<Gender>>.generate(
    Gender.values.length,
    (int index) => DropdownMenuItem<Gender>(
      child: SizedBox(
        width: 120,
        child: Text(Gender.values[index].name),
      ),
      value: Gender.values[index],
    ),
  );
  late final String initialCountrySelection;
  late final User user;

  @override
  void initState() {
    firstNameFocusNode = FocusNode();
    lastNameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    ageFocusNode = FocusNode();
    addressFocusNode = FocusNode();
    cityFocusNode = FocusNode();
    firstNameTextEditingController = TextEditingController();
    lastNameTextEditingController = TextEditingController();
    emailTextEditingController = TextEditingController();
    phoneTextEditingController = TextEditingController();
    ageTextEditingController = TextEditingController();
    addressTextEditingController = TextEditingController();
    cityTextEditingController = TextEditingController();

    profileBloc = BlocProvider.of(context);
    final AuthCubit authCubit = BlocProvider.of(context);

    if (!authCubit.state.isAuthorized) {
      throw Exception('not signed in');
    }
    user = authCubit.state.user!;

    profileBloc.add(ExistingUserProfileFetched(user: user));

    if (user.firstName is String) {
      firstNameTextEditingController.value =
          TextEditingValue(text: user.firstName!);
    }
    if (user.lastName is String) {
      lastNameTextEditingController.value =
          TextEditingValue(text: user.lastName!);
    }
    if (user.email is String) {
      emailTextEditingController.value = TextEditingValue(text: user.email!);
    }
    if (user.countryCode is String) {
      initialCountrySelection = user.countryCode!;
    } else {
      initialCountrySelection = '+91';
    }
    if (user.phoneNumber is String) {
      phoneTextEditingController.value =
          TextEditingValue(text: user.phoneNumber!);
    }
    if (user.gender is String) {
      profileBloc.add(
        ProfileGenderChanged(
          gender: genderFromString(user.gender!),
        ),
      );
    }
    if (user.age is int) {
      ageTextEditingController.value =
          TextEditingValue(text: user.age!.toString());
    }
    if (user.address is String) {
      addressTextEditingController.value =
          TextEditingValue(text: user.address!);
    }
    if (user.city is String) {
      cityTextEditingController.value = TextEditingValue(text: user.city!);
    }

    super.initState();
  }

  @override
  void dispose() {
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    ageFocusNode.dispose();
    addressFocusNode.dispose();
    cityFocusNode.dispose();
    firstNameTextEditingController.dispose();
    lastNameTextEditingController.dispose();
    emailTextEditingController.dispose();
    phoneTextEditingController.dispose();
    ageTextEditingController.dispose();
    addressTextEditingController.dispose();
    cityTextEditingController.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    final Screen screen = routeSettings.arguments as Screen;
    return AppBar(title: Text(screen.screenName()));
  }

  void onFormSubmitted() async {
    final ProfileState profileState = profileBloc.state;
    if (_formkey.currentState!.validate() &&
        profileState.isValidCountryCode &&
        profileState.isValidGender &&
        profileState.isValidProfilePicFilePath) {
      FocusScope.of(context).unfocus();
      profileBloc.add(ProfileSubmitted());
    }
  }

  @override
  Widget body(BuildContext context) {
    final Screen screen = routeSettings.arguments as Screen;
    return Form(
      key: _formkey,
      child: Center(
        child: SingleChildScrollView(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (BuildContext context, ProfileState state) {
              if (state.formStatus is SubmissionSuccess) {
                profileBloc.add(ResetFormStatus());
                if (screen == Screen.registerUser) {
                  Future<void>.microtask(
                    () => navigator
                      ..popUntil(
                        (_) => false,
                      )
                      ..pushNamed(
                        Routes.home,
                      ),
                  );
                } else {
                  Future<void>.microtask(() => navigator.pop());
                }
              } else if (state.formStatus is SubmissionFailed) {
                profileBloc.add(ResetFormStatus());
                final SubmissionFailed failure =
                    state.formStatus as SubmissionFailed;
                Future<void>.microtask(
                  () => showSnackBar(
                    SnackBar(
                      content: Text(failure.message ?? 'Failure'),
                    ),
                  ),
                );
              }

              return Column(
                children: <Widget>[
                  const SizedBox(
                    height: 5,
                  ),
                  ImageContainer(
                    imagePath: state.profilePicFile?.path,
                    imageUrl: state.profilePicUrlPath,
                    onContainerTap: () {
                      showImagePickerPopup(
                        context: context,
                        onImagePicked: (File file) {
                          if (!profileBloc.isClosed) {
                            profileBloc.add(
                              ProfileImageChanged(
                                profilePic: file,
                              ),
                            );
                          }
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  if (screen == Screen.registerUser)
                    TextFormField(
                      autofocus: screen == Screen.registerUser,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.qr_code_rounded,
                        ),
                        hintText: 'Enter a referral code',
                      ),
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (_) =>
                          firstNameFocusNode.requestFocus(),
                      textInputAction: TextInputAction.next,
                      onChanged: (String value) => profileBloc.add(
                        ProfileRefferalCodeChanged(
                          refferalCode: value,
                        ),
                      ),
                    ),
                  if (screen == Screen.registerUser)
                    const SizedBox(
                      height: 15,
                    ),
                  TextFormField(
                    controller: firstNameTextEditingController,
                    focusNode: firstNameFocusNode,
                    autofocus: screen != Screen.registerUser,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle_outlined,
                      ),
                      hintText: 'Enter your first name',
                    ),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) => lastNameFocusNode.requestFocus(),
                    validator: (_) =>
                        state.isValidFirstname ? null : "First name too short",
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) => profileBloc.add(
                      ProfileFirstnameChanged(
                        firstname: value,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: lastNameTextEditingController,
                    focusNode: lastNameFocusNode,
                    autofocus: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle_outlined,
                      ),
                      hintText: 'Enter your last name',
                    ),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
                    validator: (_) =>
                        state.isValidLastname ? null : "Last name too short",
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) => profileBloc.add(
                      ProfileLastnameChanged(
                        lastname: value,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: emailTextEditingController,
                    focusNode: emailFocusNode,
                    autofocus: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                      hintText: 'Enter your email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (_) => phoneFocusNode.requestFocus(),
                    validator: (_) =>
                        state.isValidEmail ? null : "Username is too short",
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) => profileBloc.add(
                      ProfileEmailChanged(
                        email: value,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      CountryCodePicker(
                        initialSelection: state.countryCode,
                        flagDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        onChanged: (CountryCode countryCode) {
                          profileBloc.add(
                            ProfileCountryCodeChanged(
                              countryCode: countryCode.dialCode ?? '+91',
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: phoneTextEditingController,
                          focusNode: phoneFocusNode,
                          autofocus: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                            ),
                            hintText: 'Enter your phone number',
                          ),
                          keyboardType: TextInputType.phone,
                          onFieldSubmitted: (_) => ageFocusNode.requestFocus(),
                          validator: (_) => state.isValidPhoneNumber
                              ? null
                              : 'Enter a valid phone number',
                          textInputAction: TextInputAction.next,
                          onChanged: (String value) => profileBloc.add(
                            ProfilePhoneNumberChanged(
                              phoneNumber: value,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<Gender>(
                    items: genderOptions,
                    onChanged: (Gender? gender) {
                      if (gender is Gender) {
                        profileBloc.add(ProfileGenderChanged(gender: gender));
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Select your gender',
                      prefixIcon: Icon(Icons.account_circle_outlined),
                    ),
                    value: state.gender,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: ageTextEditingController,
                    focusNode: ageFocusNode,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.home_work_outlined),
                      hintText: 'Enter your age',
                    ),
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (_) => addressFocusNode.requestFocus(),
                    validator: (_) => state.isValidAge
                        ? null
                        : 'Must be above 18 to use the app',
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) => profileBloc.add(
                      ProfileAgeChanged(
                        age: int.tryParse(value) ?? 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: addressTextEditingController,
                    focusNode: addressFocusNode,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.home),
                      hintText: 'Enter your address',
                    ),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) => cityFocusNode.requestFocus(),
                    validator: (_) => state.isValidAddress
                        ? null
                        : 'Address must not be empty',
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) => profileBloc.add(
                      ProfileAddressChanged(
                        address: value,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: cityTextEditingController,
                    focusNode: cityFocusNode,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.home,
                      ),
                      hintText: 'Enter your city',
                    ),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) => onFormSubmitted(),
                    validator: (_) =>
                        state.isValidCity ? null : 'City must not be empty',
                    onChanged: (String value) => profileBloc.add(
                      ProfileCityChanged(
                        city: value,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Enable Push Notifications',
                          style: textTheme.headline2,
                        ),
                      ),
                      Switch(
                        value: state.isNotificationEnabled,
                        onChanged: (bool enableNotifications) {
                          profileBloc.add(
                            ProfileNotificationStatusChanged(
                              enableNotifications: enableNotifications,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  state.formStatus is FormSubmitting
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: onFormSubmitted,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              'Submit',
                              style: textTheme.headline2,
                            ),
                          ),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
