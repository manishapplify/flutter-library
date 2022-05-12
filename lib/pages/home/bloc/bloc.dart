part of blocs;

class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  HomeBloc({
    required S3ImageUpload s3imageUpload,
    required AuthCubit authCubit,
    required this.imageBaseUrl,
  })  : _s3imageUpload = s3imageUpload,
        _authCubit = authCubit,
        super(const HomeState(blocStatus: Idle())) {
    on<UploadImagesEvent>(_uploadImagesEventHandler);
    on<ResetImageUploadStatus>(_resetImageUploadStatusHandler);
  }

  final S3ImageUpload _s3imageUpload;
  final AuthCubit _authCubit;
  final String imageBaseUrl;

  void _uploadImagesEventHandler(
      UploadImagesEvent event, Emitter<HomeState> emit) async {
    await _commonHandler(
      handlerJob: () async {
        for (final File image in event.images) {
          await _s3imageUpload.uploadImage(
            s3Directory: _authCubit.state.user!.s3Folders.users,
            image: image,
          );
        }
      },
      emit: emit,
      onStatusUpdate: (WorkStatus status) => emit(
        state.copyWith(
          imageUploadStatus: status,
        ),
      ),
    );
  }

  void _resetImageUploadStatusHandler(
          ResetImageUploadStatus event, Emitter<HomeState> emit) =>
      emit(
        state.copyWith(
          imageUploadStatus: const Idle(),
        ),
      );
}
