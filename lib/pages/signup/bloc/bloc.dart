// ignore_for_file: always_specify_types

import 'package:components/Authentication/form_submission.dart';
import 'package:components/Authentication/repo.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/pages/signup/bloc/event.dart';
import 'package:components/pages/signup/bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    required AuthRepository authRepo,
    required AuthCubit authCubit,
    required ImagePicker picker,
  })  : _authRepo = authRepo,
        _picker = picker,
        super(SignUpState()) {
    on<OpenImagePicker>((event, emit) async {
      final XFile? pickedImage =
          await _picker.pickImage(source: event.imageSource);
      if (pickedImage == null) {
        return;
      }
      emit(state.copyWith(profilePic: pickedImage.path));
    });

    on<SignUpProfileImageChanged>((event, emit) {
      emit(state.copyWith(profilePic: event.profilePic));
    });
    on<SignUpFirstnameChanged>((event, emit) {
      emit(state.copyWith(firstname: event.firstname));
    });
    on<SignUpCountryCodeChanged>((event, emit) {
      emit(state.copyWith(code: event.code));
    });
    on<SignUpPhoneNumberChanged>((event, emit) {
      emit(state.copyWith(phoneNumber: event.phoneNumber));
    });
    on<SignUpLastnameChanged>((event, emit) {
      emit(state.copyWith(lastname: event.lastname));
    });
    on<SignUpReferralCodeChanged>((event, emit) {
      emit(state.copyWith(referralCode: event.referralCode));
    });
    on<SignUpEmailChanged>((event, emit) {
      emit(state.copyWith(password: event.email));
    });
    on<SignUpPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
      print(event.password.toString());
    });
    on<SignUpSubmitted>((event, emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        await _authRepo.signUp(
          profilePic: state.profilePic,
          firstName: state.firstname,
          lastName: state.lastname,
          countryCode: state.code,
          phoneNumber: state.phoneNumber,
          referralCode: state.referralCode,
          email: state.email,
          password: state.password,
        );
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      } on Exception catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(exception: e)));
      }
    });
  }

  final AuthRepository _authRepo;
  final ImagePicker _picker;
}
