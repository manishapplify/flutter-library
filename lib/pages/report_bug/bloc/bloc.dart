import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:components/Authentication/form_submission.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/pages/report_bug/models/request.dart';
import 'package:components/services/api.dart';
import 'package:components/services/s3_image_upload/s3_image_upload.dart';
import 'package:meta/meta.dart';
import 'package:components/validators/validators.dart' as validators;

part 'event.dart';
part 'state.dart';

class ReportBugBloc extends Bloc<ReportBugEvent, ReportBugState> {
  ReportBugBloc({
    required Api api,
    required S3ImageUpload s3imageUpload,
    required AuthCubit authCubit,
  })  : _api = api,
        _s3imageUpload = s3imageUpload,
        _authCubit = authCubit,
        super(ReportBugState()) {
    on<ReportBugTitleChanged>(_reportBugTitleChangedHandler);
    on<ReportBugDescriptionChanged>(_reportBugDescriptionChangedHandler);
    on<ReportBugScreenShotChanged>(_reportBugScreenShotChangedHandler);
    on<ReportBugScreenShotRemoved>(_reportBugScreenShotRemovedHandler);
    on<ReportBugSubmitted>(_reportBugSubmittedHandler);
    on<ResetFormStatus>(_resetFormStatusHandler);
  }

  final Api _api;
  final S3ImageUpload _s3imageUpload;
  final AuthCubit _authCubit;

  void _reportBugTitleChangedHandler(
      ReportBugTitleChanged event, Emitter<ReportBugState> emit) {
    emit(state.copyWith(title: event.title));
  }

  void _reportBugDescriptionChangedHandler(
      ReportBugDescriptionChanged event, Emitter<ReportBugState> emit) {
    emit(state.copyWith(description: event.description));
  }

  void _reportBugScreenShotChangedHandler(
      ReportBugScreenShotChanged event, Emitter<ReportBugState> emit) {
    emit(state.copyWith(screenShot: event.screenShot));
  }

  void _reportBugScreenShotRemovedHandler(
      ReportBugScreenShotRemoved event, Emitter<ReportBugState> emit) {
    emit(ReportBugState(
      title: state.title,
      description: state.description,
      formStatus: state.formStatus,
    ));
  }

  void _reportBugSubmittedHandler(
      ReportBugSubmitted event, Emitter<ReportBugState> emit) async {
    if (!_authCubit.state.isAuthorized) {
      throw Exception('not signed in');
    }
    emit(state.copyWith(formStatus: FormSubmitting()));

    try {
      final String? screenShotUrl = await _s3imageUpload.getS3ImageUrl(
        s3Directory: _authCubit.state.user!.s3Folders.users,
        profilePicFile: state.screenShot,
      );

      if (screenShotUrl == null) {
        throw Exception('could not upload image to s3');
      }

      final ReportBugRequest request = ReportBugRequest(
        description: state.description!,
        image: screenShotUrl,
        title: state.title!,
      );

      await _api.reportBug(request);
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } on Exception catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(exception: e)));
    }
  }

  void _resetFormStatusHandler(
      ResetFormStatus event, Emitter<ReportBugState> emit) {
    emit(state.copyWith(formStatus: const InitialFormStatus()));
  }
}
