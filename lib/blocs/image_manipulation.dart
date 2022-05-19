part of blocs;

abstract class BaseImageManipulationBloc<E extends BaseImageManipulationEvent,
    S extends BaseImageManipulationState> extends BaseBloc<E, S> {
  BaseImageManipulationBloc(
    S initialState,
    this._imageCroppingService,
    this._imagePickingService,
  ) : super(initialState);

  final ImagePickingService _imagePickingService;
  final ImageCroppingService _imageCroppingService;

  void _baseImageCropEventHandler(
    BaseImageCropEvent event,
    Emitter<BaseImageManipulationState> emit,
  ) async {
    await _commonHandler(
      handlerJob: () async {
        final File image = await _imageCroppingService
            .cropImage(event.imageCropperConfiguration);

        emit(state.setCroppedImage(image));
      },
      emit: emit,
      onStatusUpdate: (WorkStatus status) {
        emit(state.updateCropImageStatus(status));
      },
    );
  }

  void _baseImagePickEventHandler(
    BaseImagePickEvent event,
    Emitter<BaseImageManipulationState> emit,
  ) async {
    await _commonHandler(
      handlerJob: () async {
        final File image = await _imagePickingService
            .pickImage(event.imagePickerConfiguration);

        emit(state.setPickedImage(image));
      },
      emit: emit,
      onStatusUpdate: (WorkStatus status) {
        emit(state.updatePickImageStatus(status));
      },
    );
  }

  void _resetPickImageStateEventHandler(
    ResetPickImageState event,
    Emitter<BaseImageManipulationState> emit,
  ) {
    emit(state.setPickedImage(null));
    emit(state.updatePickImageStatus(const Idle()));
  }

  void _resetCropImageStateEventHandler(
    ResetCropImageState event,
    Emitter<BaseImageManipulationState> emit,
  ) {
    emit(state.setCroppedImage(null));
    emit(state.updateCropImageStatus(const Idle()));
  }
}

abstract class BaseImageManipulationEvent extends BaseEvent {}

abstract class BaseImagePickEvent extends BaseImageManipulationEvent {
  BaseImagePickEvent(this.imagePickerConfiguration);

  final ImagePickerConfiguration imagePickerConfiguration;
}

abstract class BaseImageCropEvent extends BaseImageManipulationEvent {
  BaseImageCropEvent(this.imageCropperConfiguration);

  final ImageCropperConfiguration imageCropperConfiguration;
}

abstract class ResetPickImageState extends BaseImageManipulationEvent {}

abstract class ResetCropImageState extends BaseImageManipulationEvent {}

@immutable
abstract class BaseImageManipulationState extends BaseState {
  const BaseImageManipulationState(
    WorkStatus blocStatus, {
    this.cropImageStatus = const Idle(),
    this.pickImageStatus = const Idle(),
  }) : super(blocStatus);

  final WorkStatus cropImageStatus;

  final WorkStatus pickImageStatus;

  BaseImageManipulationState updateCropImageStatus(WorkStatus cropImageStatus);

  BaseImageManipulationState updatePickImageStatus(WorkStatus pickImageStatus);

  BaseImageManipulationState setCroppedImage(File? image);

  BaseImageManipulationState setPickedImage(File? image);
}
