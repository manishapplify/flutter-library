part of blocs;

@immutable
class VideoState extends BaseState {
  const VideoState({
    this.videoUrls = const <String>[],
    this.currentVideoIndex,
    this.loadCurrentVideo = const Idle(),
    WorkStatus blocStatus = const Idle(),
  }) : super(blocStatus);

  final List<String> videoUrls;
  final int? currentVideoIndex;
  final WorkStatus loadCurrentVideo;

  VideoState copyWith({
    List<String>? videoUrls,
    int? currentVideoIndex,
    WorkStatus? loadCurrentVideo,
    WorkStatus? blocStatus,
  }) {
    return VideoState(
      videoUrls: videoUrls ?? this.videoUrls,
      currentVideoIndex: currentVideoIndex ?? this.currentVideoIndex,
      loadCurrentVideo: loadCurrentVideo ?? this.loadCurrentVideo,
      blocStatus: blocStatus ?? this.blocStatus,
    );
  }

  @override
  VideoState resetState() => const VideoState();

  @override
  BaseState updateStatus(WorkStatus blocStatus) => copyWith(
        blocStatus: blocStatus,
      );
}
