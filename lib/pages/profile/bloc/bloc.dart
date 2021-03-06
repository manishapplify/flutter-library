part of blocs;

class ProfileBloc extends BaseBloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required Screen screenType,
    required ProfileRepository profileRepository,
    required this.imageBaseUrl,
  })  : _profileRepository = profileRepository,
        super(ProfileState(screenType: screenType)) {
    on<ProfileReferralCodeChanged>(_profileReferralCodeChangedHandler);
    on<ProfileFirstnameChanged>(_profileFirstnameChangedHandler);
    on<ProfileLastnameChanged>(_profileLastnameChangedHandler);
    on<ProfileCountryCodeChanged>(_profileCountryCodeChangedHandler);
    on<ProfilePhoneNumberChanged>(_profilePhoneNumberChangedHandler);
    on<ProfileEmailChanged>(_profileEmailChangedHandler);
    on<ProfileGenderChanged>(_profileGenderChangedHandler);
    on<ProfileImageChanged>(_profileProfileImageChangedHandler);
    on<ProfileAgeChanged>(_profileAgeChangedHandler);
    on<ProfileAddressChanged>(_profileAddressChangedHandler);
    on<ProfileCityChanged>(_profileCityChangedHandler);
    on<ProfileNotificationStatusChanged>(
        _profileNotificationStatusChangedHandler);
    on<ExistingUserProfileFetched>(_existingUserProfileFetchedHandler);
    on<ProfileSubmitted>(_profileSubmittedHandler);
    on<ResetProfileFormStatus>(_resetFormStatusHandler);
  }

  final ProfileRepository _profileRepository;
  final String imageBaseUrl;

  void _profileReferralCodeChangedHandler(
      ProfileReferralCodeChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(referralCode: event.referralCode),
    );
  }

  void _profileFirstnameChangedHandler(
      ProfileFirstnameChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(firstname: event.firstname),
    );
  }

  void _profileLastnameChangedHandler(
      ProfileLastnameChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(lastname: event.lastname),
    );
  }

  void _profileCountryCodeChangedHandler(
      ProfileCountryCodeChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(countryCode: event.countryCode),
    );
  }

  void _profilePhoneNumberChangedHandler(
      ProfilePhoneNumberChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(phoneNumber: event.phoneNumber),
    );
  }

  void _profileEmailChangedHandler(
      ProfileEmailChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(email: event.email),
    );
  }

  void _profileGenderChangedHandler(
      ProfileGenderChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(gender: event.gender),
    );
  }

  void _profileProfileImageChangedHandler(
      ProfileImageChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(profilePicFile: event.profilePic),
    );
  }

  void _profileAgeChangedHandler(
      ProfileAgeChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(age: event.age),
    );
  }

  void _profileAddressChangedHandler(
      ProfileAddressChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(address: event.address),
    );
  }

  void _profileCityChangedHandler(
      ProfileCityChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(city: event.city),
    );
  }

  void _profileNotificationStatusChangedHandler(
      ProfileNotificationStatusChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(isNotificationEnabled: event.enableNotifications),
    );
  }

  void _existingUserProfileFetchedHandler(
      ExistingUserProfileFetched event, Emitter<ProfileState> emit) {
    // Init state.

    final User user = event.user;
    emit(
      state.copyWith(
          profilePicUrlPath: (event.user.profilePic is String)
              ? (imageBaseUrl + event.user.profilePic!)
              : null,
          firstname: user.firstName,
          lastname: user.lastName,
          address: user.address,
          age: user.age,
          city: user.city,
          countryCode: user.countryCode,
          email: user.email,
          gender: user.gender is String ? genderFromString(user.gender!) : null,
          isNotificationEnabled: user.notificationEnabled == 1,
          phoneNumber: user.phoneNumber),
    );
  }

  void _profileSubmittedHandler(
      ProfileSubmitted event, Emitter<ProfileState> emit) async {
    if (state.screenType == Screen.registerUser) {
      await _commonHandler(
        handlerJob: () async {
          await _profileRepository.registerUser(
            firstName: state.firstname,
            lastName: state.lastname,
            countryCode: state.countryCode,
            phoneNumber: state.phoneNumber,
            email: state.email,
            gender: state.gender?.name,
            profilePicFile: state.profilePicFile,
            age: state.age,
            address: state.address,
            city: state.city,
            notificationEnabled:
                state.isNotificationEnabled ? 1.toString() : 0.toString(),
            referralCode: state.referralCode,
            signupType: Signup.EMAIL_OR_PHONE,
          );
        },
        emit: emit,
      );
    } else if (state.screenType == Screen.updateProfile) {
      await _commonHandler(
        handlerJob: () async {
          await _profileRepository.updateProfile(
            firstName: state.firstname,
            lastName: state.lastname,
            countryCode: state.countryCode,
            phoneNumber: state.phoneNumber,
            email: state.email,
            gender: state.gender?.name,
            profilePicFile: state.profilePicFile,
            age: state.age,
            address: state.address,
            city: state.city,
            notificationEnabled:
                state.isNotificationEnabled ? 1.toString() : 0.toString(),
          );
        },
        emit: emit,
      );
    } else {
      throw AppException.unsupportedActionException();
    }
  }

  void _resetFormStatusHandler(
          ResetProfileFormStatus event, Emitter<ProfileState> emit) =>
      emit(
        state.copyWith(
          blocStatus: const Idle(),
        ),
      );
}
