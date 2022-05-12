part of blocs;

class ReportBugBloc extends BaseBloc<ReportBugEvent, ReportBugState> {
  ReportBugBloc({
    required Api api,
    required S3ImageUpload s3imageUpload,
    required AuthCubit authCubit,
  })  : _api = api,
        _s3imageUpload = s3imageUpload,
        _authCubit = authCubit,
        super(const ReportBugState()) {
    on<ReportBugTitleChanged>(_reportBugTitleChangedHandler);
    on<ReportBugDescriptionChanged>(_reportBugDescriptionChangedHandler);
    on<ReportBugScreenShotChanged>(_reportBugScreenShotChangedHandler);
    on<ReportBugScreenShotRemoved>(_reportBugScreenShotRemovedHandler);
    on<ReportBugSubmitted>(_reportBugSubmittedHandler);
    on<ResetReportBugFormStatus>(_resetFormStatusHandler);
    on<ResetReportBugFormState>(_resetFormStateHandler);
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
      blocStatus: state.blocStatus,
    ));
  }

  void _reportBugSubmittedHandler(
      ReportBugSubmitted event, Emitter<ReportBugState> emit) async {
    if (!_authCubit.state.isAuthorized) {
      throw AppException.authenticationException();
    }
    await _commonHandler(
      handlerJob: () async {
        final String? screenShotUrl = await _s3imageUpload.uploadImage(
          s3Directory: _authCubit.state.user!.s3Folders.users,
          image: state.screenShot,
        );

        if (screenShotUrl == null) {
          throw AppException.s3ImageUploadException();
        }

        final ReportBugRequest request = ReportBugRequest(
          description: state.description!,
          image: screenShotUrl,
          title: state.title!,
        );

        await _api.reportBug(request);
        emit(state.copyWith(blocStatus: Success()));
      },
      emit: emit,
    );
  }

  void _resetFormStatusHandler(
      ResetReportBugFormStatus event, Emitter<ReportBugState> emit) {
    emit(state.copyWith(blocStatus: const Idle()));
  }

  void _resetFormStateHandler(
          ResetReportBugFormState event, Emitter<ReportBugState> emit) =>
      emit(const ReportBugState());
}
