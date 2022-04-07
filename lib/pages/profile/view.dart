import 'dart:io';

import 'package:components/Authentication/form_submission.dart';
import 'package:components/base/base_page.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/dialogs/dialogs.dart';
import 'package:components/enums/gender.dart';
import 'package:components/enums/screen.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/pages/profile/bloc/bloc.dart';
import 'package:components/routes/navigation.dart';
import 'package:components/widgets/image_container.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends BasePage {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState extends BasePageState<ProfilePage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late final FocusNode referralFocusNode;
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
        width: 80,
        child: Text(Gender.values[index].name),
      ),
      value: Gender.values[index],
    ),
  );
  late final User user;

  @override
  void initState() {
    referralFocusNode = FocusNode();
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
      throw AppException.authenticationException;
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
      profileBloc
          .add(ProfileCountryCodeChanged(countryCode: user.countryCode!));
    } else {
      profileBloc.add(ProfileCountryCodeChanged(countryCode: '+91'));
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
    referralFocusNode.dispose();
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
    } else if (!profileState.isValidCountryCode) {
      showSnackBar(
        const SnackBar(
          content: Text('Select a valid country code'),
        ),
      );
    } else if (!profileState.isValidGender) {
      showSnackBar(
        const SnackBar(
          content: Text('Select a valid gender'),
        ),
      );
    } else if (!profileState.isValidProfilePicFilePath) {
      showSnackBar(
        const SnackBar(
          content: Text('Select a profile picture'),
        ),
      );
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
                  Future<void>.microtask(
                    () => showSnackBar(
                      const SnackBar(
                        content: Text('Profile successfully updated'),
                      ),
                    ),
                  );
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
                    const SizedBox(
                      height: 15,
                    ),
                  TextFormField(
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    controller: firstNameTextEditingController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle_outlined,
                      ),
                      hintText: 'Enter your first name',
                      labelText: 'First name',
                    ),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) => lastNameFocusNode.requestFocus(),
                    validator: (_) => state.firstnameValidator,
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) => profileBloc.add(
                      ProfileFirstnameChanged(
                        firstname: value,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: lastNameTextEditingController,
                    focusNode: lastNameFocusNode,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle_outlined,
                      ),
                      hintText: 'Enter your last name',
                      labelText: 'Last name',
                    ),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
                    validator: (_) => state.lastnameValidator,
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
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                      hintText: 'Enter your email',
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (_) => phoneFocusNode.requestFocus(),
                    validator: (_) => state.emailValidator,
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
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                            ),
                            hintText: 'Enter your phone number',
                            labelText: 'Phone number',
                          ),
                          keyboardType: TextInputType.phone,
                          onFieldSubmitted: (_) => ageFocusNode.requestFocus(),
                          validator: (_) => state.phoneNumberValidator,
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
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.account_circle_outlined),
                    ),
                    value: state.gender,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: ageTextEditingController,
                    focusNode: ageFocusNode,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      hintText: 'Enter your age',
                      labelText: 'Age',
                    ),
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (_) => addressFocusNode.requestFocus(),
                    validator: (_) => state.ageValidator,
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) => profileBloc.add(
                      ProfileAgeChanged(
                        age: int.tryParse(value) ?? 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: addressTextEditingController,
                    focusNode: addressFocusNode,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.home),
                      hintText: 'Enter your address',
                      labelText: 'Address',
                    ),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) => cityFocusNode.requestFocus(),
                    validator: (_) =>
                        state.isValidAddress ? null : 'Address is required',
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) => profileBloc.add(
                      ProfileAddressChanged(
                        address: value,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: cityTextEditingController,
                    focusNode: cityFocusNode,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.home,
                      ),
                      hintText: 'Enter your city',
                      labelText: 'City',
                    ),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) => screen == Screen.registerUser
                        ? referralFocusNode.requestFocus()
                        : onFormSubmitted(),
                    validator: (_) =>
                        state.isValidCity ? null : 'City is required',
                    textInputAction: screen == Screen.registerUser
                        ? TextInputAction.next
                        : TextInputAction.done,
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
                  const SizedBox(height: 15),
                  if (screen == Screen.registerUser)
                    TextFormField(
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.qr_code_rounded,
                        ),
                        hintText: 'Enter a referral code(optional)',
                        labelText: 'Referral code',
                      ),
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (_) => screen == Screen.registerUser
                          ? onFormSubmitted()
                          : null,
                      onChanged: (String value) => profileBloc.add(
                        ProfileReferralCodeChanged(
                          referralCode: value,
                        ),
                      ),
                      focusNode: referralFocusNode,
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
