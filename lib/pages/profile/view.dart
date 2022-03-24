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
import 'package:components/widgets/image_avtar.dart';
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
        width: 70,
        child: ListTile(
          title: Text(Gender.values[index].name),
        ),
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
      profileBloc
          .add(ProfileGenderChanged(gender: genderFromString(user.gender!)));
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
    if (_formkey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
    }
    navigator
      ..popUntil((_) => true)
      ..pushNamed(Routes.home);
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
                Future<void>.microtask(() => navigator.pushNamed(Routes.home));
              } else if (state.formStatus is SubmissionFailed) {
                Future<void>.microtask(
                  () => showSnackBar(
                    const SnackBar(
                      content: Text('Failure'),
                    ),
                  ),
                );
              }

              return Column(
                children: <Widget>[
                  const SizedBox(
                    height: 5,
                  ),
                  UserProfileImage(
                    imagePath: state.profilePicFilePath,
                    imageUrl: state.profilePicUrlPath,
                    edit: () {
                      showImagePickerPopup(
                        context: context,
                        onImagePicked: (File file) {
                          if (!profileBloc.isClosed) {
                            profileBloc.add(
                              ProfileProfileImageChanged(
                                  profilePicPath: file.path),
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
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        hintText: 'Enter a referral code',
                        labelText: 'Referral code',
                      ),
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (_) =>
                          firstNameFocusNode.requestFocus(),
                    ),
                  if (screen == Screen.registerUser)
                    const SizedBox(
                      height: 15,
                    ),
                  TextFormField(
                    controller: firstNameTextEditingController,
                    focusNode: firstNameFocusNode,
                    autofocus: screen == Screen.editProfile,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: 'Enter your first name',
                      labelText: 'First name',
                    ),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) => lastNameFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: lastNameTextEditingController,
                    focusNode: lastNameFocusNode,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: 'Enter your last name',
                      labelText: 'Last name',
                    ),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: emailTextEditingController,
                    focusNode: emailFocusNode,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (_) => phoneFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      CountryCodePicker(
                        initialSelection: 'IN',
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
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(
                            hintText: 'Enter your phone number',
                            labelText: 'Phone number',
                          ),
                          keyboardType: TextInputType.phone,
                          onFieldSubmitted: (_) => ageFocusNode.requestFocus(),
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
                    hint: const Text('Select your gender'),
                    value: state.gender,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: ageTextEditingController,
                    focusNode: ageFocusNode,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: 'Enter your age',
                      labelText: 'Age',
                    ),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) => addressFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: addressTextEditingController,
                    focusNode: addressFocusNode,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: 'Enter your address',
                      labelText: 'Address',
                    ),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) => cityFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: cityTextEditingController,
                    focusNode: cityFocusNode,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: 'Enter your city',
                      labelText: 'City',
                    ),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Enable Notifications',
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
                  ElevatedButton(
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
