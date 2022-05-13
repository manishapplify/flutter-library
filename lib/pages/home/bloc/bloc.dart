part of blocs;

class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  HomeBloc({
    required S3ImageUpload s3imageUpload,
    required AuthCubit authCubit,
    required Persistence persistence,
    required this.imageBaseUrl,
  })  : _persistence = persistence,
        _s3imageUpload = s3imageUpload,
        _authCubit = authCubit,
        super(const HomeState(blocStatus: Idle())) {
    on<UploadImagesEvent>(_uploadImagesEventHandler);
    on<ResetImageUploadStatus>(_resetImageUploadStatusHandler);
    on<_OnUploadedImageUrlsLoadEvent>(_onUploadedImageUrlsLoadEventHandler);

    final List<String>? uploadedImageUrls = _persistence.fetchUploadedImages();
    if (uploadedImageUrls != null) {
      add(_OnUploadedImageUrlsLoadEvent(uploadedImageUrls));
    }
  }

  final S3ImageUpload _s3imageUpload;
  final AuthCubit _authCubit;
  final Persistence _persistence;
  final String imageBaseUrl;

  void _uploadImagesEventHandler(
      UploadImagesEvent event, Emitter<HomeState> emit) async {
    final List<String> uploadedImageUrls =
        state.uploadedImageUrls.isEmpty ? <String>[] : state.uploadedImageUrls;

    await _commonHandler(
      handlerJob: () async {
        for (final File image in event.images) {
          final String? uploadedFileName = await _s3imageUpload.uploadImage(
            s3Directory: _authCubit.state.user!.s3Folders.users,
            image: image,
          );

          if (uploadedFileName == null) {
            throw AppException.s3ImageUploadException();
          }

          uploadedImageUrls.add(imageBaseUrl + uploadedFileName);
        }
      },
      emit: emit,
      onStatusUpdate: (WorkStatus status) {
        if (status is Success && uploadedImageUrls != state.uploadedImageUrls) {
          _persistence.saveUploadedImages(uploadedImageUrls);
        }
        emit(
          state.copyWith(
            imageUploadStatus: status,
            uploadedImageUrls: status is Success ? uploadedImageUrls : null,
          ),
        );
      },
    );
  }

  void _resetImageUploadStatusHandler(
          ResetImageUploadStatus event, Emitter<HomeState> emit) =>
      emit(
        state.copyWith(
          imageUploadStatus: const Idle(),
        ),
      );

  void _onUploadedImageUrlsLoadEventHandler(
      _OnUploadedImageUrlsLoadEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(uploadedImageUrls: event.uploadedImageUrls));
  }
}
