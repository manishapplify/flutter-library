part of blocs;

class HomeState extends BaseState {
  const HomeState({
    this.imageUploadStatus = const Idle(),
    this.uploadedImageUrls = const <String>[],
    required WorkStatus blocStatus,
  }) : super(blocStatus);

  final WorkStatus imageUploadStatus;
  final List<String> uploadedImageUrls;

  @override
  BaseState resetState() => const HomeState(blocStatus: Idle());

  @override
  BaseState updateStatus(WorkStatus blocStatus) => copyWith(
        blocStatus: blocStatus,
      );

  HomeState copyWith({
    WorkStatus? imageUploadStatus,
    WorkStatus? blocStatus,
    List<String>? uploadedImageUrls,
  }) {
    return HomeState(
      imageUploadStatus: imageUploadStatus ?? this.imageUploadStatus,
      blocStatus: blocStatus ?? this.blocStatus,
      uploadedImageUrls: uploadedImageUrls ?? this.uploadedImageUrls,
    );
  }
}
