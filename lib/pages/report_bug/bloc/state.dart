part of blocs;

class ReportBugState extends BaseState implements BaseImageManipulationState {
  const ReportBugState({
    this.title,
    this.description,
    this.cropImageStatus = const Idle(),
    this.pickImageStatus = const Idle(),
    this.pickedImage,
    this.croppedImage,
    WorkStatus blocStatus = const Idle(),
  }) : super(blocStatus);

  final String? title;
  String? get titleValidator =>
      !validators.notEmptyValidator(description) ? 'Title is required' : null;

  final String? description;
  String? get descriptionValidator => !validators.notEmptyValidator(description)
      ? 'Description is required'
      : null;

  bool get isValidScreenShot => croppedImage is File;
  final File? pickedImage;
  final File? croppedImage;

  @override
  final WorkStatus cropImageStatus;

  @override
  final WorkStatus pickImageStatus;

  ReportBugState copyWith({
    String? title,
    String? description,
    WorkStatus? cropImageStatus,
    WorkStatus? pickImageStatus,
    File? pickedImage,
    File? croppedImage,
    WorkStatus? blocStatus,
  }) {
    return ReportBugState(
      title: title ?? this.title,
      description: description ?? this.description,
      blocStatus: blocStatus ?? this.blocStatus,
      cropImageStatus: cropImageStatus ?? this.cropImageStatus,
      pickImageStatus: pickImageStatus ?? this.pickImageStatus,
      pickedImage: pickedImage ?? this.pickedImage,
      croppedImage: croppedImage ?? this.croppedImage,
    );
  }

  @override
  ReportBugState resetState() => const ReportBugState();

  @override
  ReportBugState setCroppedImage(File? image) {
    if (image == null) {
      return ReportBugState(
        blocStatus: this.blocStatus,
        cropImageStatus: this.cropImageStatus,
        description: this.description,
        pickImageStatus: this.pickImageStatus,
        pickedImage: this.pickedImage,
        title: this.title,
      );
    }
    return copyWith(croppedImage: image);
  }

  @override
  ReportBugState setPickedImage(File? image) {
    if (image == null) {
      return ReportBugState(
        blocStatus: this.blocStatus,
        cropImageStatus: this.cropImageStatus,
        description: this.description,
        pickImageStatus: this.pickImageStatus,
        croppedImage: this.croppedImage,
        title: this.title,
      );
    }
    return copyWith(pickedImage: image);
  }

  @override
  ReportBugState updatePickImageStatus(WorkStatus pickImageStatus) =>
      copyWith(pickImageStatus: pickImageStatus);

  @override
  ReportBugState updateCropImageStatus(WorkStatus cropImageStatus) =>
      copyWith(cropImageStatus: cropImageStatus);

  @override
  ReportBugState updateStatus(WorkStatus blocStatus) =>
      copyWith(blocStatus: blocStatus);
}
