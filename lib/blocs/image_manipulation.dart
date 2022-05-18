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
      onStatusUpdate: state.updateCropImageStatus,
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
      onStatusUpdate: state.updatePickImageStatus,
    );
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

  BaseImageManipulationState setCroppedImage(File image);

  BaseImageManipulationState setPickedImage(File image);
}

// TODO(image manipulation): Remove this sample bloc.
class ConcBloc extends BaseImageManipulationBloc<ConcEvents, ConcState> {
  ConcBloc(
    ImagePickingService imagePickingService,
    ImageCroppingService imageCroppingService,
  ) : super(
          const ConcState(),
          imageCroppingService,
          imagePickingService,
        ) {
    on<ConcImagePickEvent>(_baseImagePickEventHandler);
  }
}

class ConcEvents extends BaseEvent implements BaseImageManipulationEvent {}

class ConcImagePickEvent extends ConcEvents implements BaseImagePickEvent {
  ConcImagePickEvent(this.imagePickerConfiguration);

  @override
  final ImagePickerConfiguration imagePickerConfiguration;
}

class ConcState extends BaseState implements BaseImageManipulationState {
  const ConcState({
    WorkStatus blocSatus = const Idle(),
    this.cropImageStatus = const Idle(),
    this.pickImageStatus = const Idle(),
    this.pickedImage,
    this.croppedImage,
  }) : super(blocSatus);

  final File? pickedImage;
  final File? croppedImage;

  @override
  final WorkStatus cropImageStatus;

  @override
  final WorkStatus pickImageStatus;

  ConcState copyWith({
    WorkStatus? blocSatus,
    WorkStatus? cropImageStatus,
    WorkStatus? pickImageStatus,
    File? pickedImage,
    File? croppedImage,
  }) {
    return ConcState(
      blocSatus: blocSatus ?? this.blocStatus,
      cropImageStatus: cropImageStatus ?? this.cropImageStatus,
      pickImageStatus: pickImageStatus ?? this.pickImageStatus,
      pickedImage: pickedImage ?? this.pickedImage,
      croppedImage: croppedImage ?? this.croppedImage,
    );
  }

  @override
  ConcState resetState() => const ConcState();

  @override
  ConcState setCroppedImage(File image) => copyWith(croppedImage: image);
  @override
  ConcState setPickedImage(File image) => copyWith(pickedImage: image);

  @override
  ConcState updateCropImageStatus(WorkStatus pickImageStatus) =>
      copyWith(pickImageStatus: pickImageStatus);

  @override
  ConcState updatePickImageStatus(WorkStatus cropImageStatus) =>
      copyWith(cropImageStatus: cropImageStatus);

  @override
  ConcState updateStatus(WorkStatus blocStatus) =>
      copyWith(blocSatus: blocStatus);
}
