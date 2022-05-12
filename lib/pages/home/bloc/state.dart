part of blocs;

class HomeState extends BaseState {
  const HomeState({
    this.imageUploadStatus = const Idle(),
    required WorkStatus blocStatus,
  }) : super(blocStatus);

  final WorkStatus imageUploadStatus;

  @override
  BaseState resetState() => const HomeState(blocStatus: Idle());

  @override
  BaseState updateStatus(WorkStatus blocStatus) => copyWith(
        blocStatus: blocStatus,
      );

  HomeState copyWith({
    WorkStatus? imageUploadStatus,
    WorkStatus? blocStatus,
  }) {
    return HomeState(
      imageUploadStatus: imageUploadStatus ?? this.imageUploadStatus,
      blocStatus: blocStatus ?? this.blocStatus,
    );
  }
}
