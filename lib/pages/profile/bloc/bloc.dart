import 'package:bloc/bloc.dart';
import 'package:components/Authentication/form_submission.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/enums/gender.dart';
import 'package:components/enums/screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:components/validators/validators.dart' as validators;

part 'event.dart';
part 'state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required Screen screenType,
  }) : super(ProfileState(screenType: screenType)) {
    on<ExistingUserProfileFetched>(_existingUserProfileFetchedHandler);
    on<ProfileGenderChanged>(_profileGenderChangedHandler);
    on<ProfileProfileImageChanged>(_profileProfileImageChangedHandler);
  }

  void _existingUserProfileFetchedHandler(
      ExistingUserProfileFetched event, Emitter<ProfileState> emit) {
    // Init profile pic.

    if (event.user.profilePic is String) {
      emit(state.copyWith(
          profilePicUrlPath: event.user.profilePic,
          formStatus: const InitialFormStatus()));
    }
  }

  void _profileGenderChangedHandler(
      ProfileGenderChanged event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
        gender: event.gender, formStatus: const InitialFormStatus()));
  }

  void _profileProfileImageChangedHandler(
      ProfileProfileImageChanged event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
        profilePicFilePath: event.profilePicPath,
        formStatus: const InitialFormStatus()));
  }
}
