import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:components/Authentication/form_submission.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/enums/gender.dart';
import 'package:components/enums/screen.dart';
import 'package:components/enums/signup.dart';
import 'package:components/pages/profile/repo.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:components/validators/validators.dart' as validators;

part 'event.dart';
part 'state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required Screen screenType,
    required ProfileRepository profileRepository,
  })  : _profileRepository = profileRepository,
        super(ProfileState(screenType: screenType)) {
    on<ProfileRefferalCodeChanged>(_profileRefferalCodeChangedHandler);
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
    on<ResetFormStatus>(_resetFormStatusHandler);
  }

  final ProfileRepository _profileRepository;

  void _profileRefferalCodeChangedHandler(
      ProfileRefferalCodeChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(
        referralCode: event.refferalCode,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _profileFirstnameChangedHandler(
      ProfileFirstnameChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(
        firstname: event.firstname,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _profileLastnameChangedHandler(
      ProfileLastnameChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(
        lastname: event.lastname,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _profileCountryCodeChangedHandler(
      ProfileCountryCodeChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(
        countryCode: event.countryCode,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _profilePhoneNumberChangedHandler(
      ProfilePhoneNumberChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _profileEmailChangedHandler(
      ProfileEmailChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _profileGenderChangedHandler(
      ProfileGenderChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(
        gender: event.gender,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _profileProfileImageChangedHandler(
      ProfileImageChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(
        profilePicFile: event.profilePic,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _profileAgeChangedHandler(
      ProfileAgeChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(
        age: event.age,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _profileAddressChangedHandler(
      ProfileAddressChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(
        address: event.address,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _profileCityChangedHandler(
      ProfileCityChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(
        city: event.city,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _profileNotificationStatusChangedHandler(
      ProfileNotificationStatusChanged event, Emitter<ProfileState> emit) {
    emit(
      state.copyWith(
        isNotificationEnabled: event.enableNotifications,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _existingUserProfileFetchedHandler(
      ExistingUserProfileFetched event, Emitter<ProfileState> emit) {
    // Init state.

    final User user = event.user;
    emit(
      state.copyWith(
        profilePicUrlPath: event.user.profilePic,
        firstname: user.firstName,
        lastname: user.lastName,
        address: user.address,
        age: user.age,
        city: user.city,
        countryCode: user.countryCode,
        email: user.email,
        gender: user.gender is String ? genderFromString(user.gender!) : null,
        isNotificationEnabled: user.notificationEnabled == 1,
        phoneNumber: user.phoneNumber,
        formStatus: const InitialFormStatus(),
      ),
    );
  }

  void _profileSubmittedHandler(
      ProfileSubmitted event, Emitter<ProfileState> emit) async {
    if (state.screenType == Screen.registerUser) {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
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
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } on DioError catch (e) {
        emit(
          state.copyWith(
            formStatus: SubmissionFailed(
              exception: e,
              message: (e.error is String?) ? e.error : 'Failure',
            ),
          ),
        );
      } on Exception catch (_) {
        emit(
          state.copyWith(
            formStatus: SubmissionFailed(exception: Exception('Failure')),
          ),
        );
      }
    } else if (state.screenType == Screen.updateProfile) {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
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
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } on DioError catch (e) {
        emit(
          state.copyWith(
            formStatus: SubmissionFailed(
              exception: e,
              message: (e.error is String?) ? e.error : 'Failure',
            ),
          ),
        );
      } on Exception catch (_) {
        emit(
          state.copyWith(
            formStatus: SubmissionFailed(exception: Exception('Failure')),
          ),
        );
      }
    } else {
      throw ('Unsupported request');
    }
  }

  void _resetFormStatusHandler(
          ResetFormStatus event, Emitter<ProfileState> emit) =>
      emit(
        state.copyWith(
          formStatus: const InitialFormStatus(),
        ),
      );
}
