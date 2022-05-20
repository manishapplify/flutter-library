part of blocs;

@immutable
abstract class VideoEvent extends BaseEvent {}

class GetVideosEvent extends VideoEvent {}

class VideoOpenedEvent extends VideoEvent {
  VideoOpenedEvent(this.index);

  final int index;
}

class VideoClosedEvent extends VideoEvent {}

class NextVideoOpenedEvent extends VideoEvent {}

class PlayPauseVideoEvent extends VideoEvent {}

class VolumeChangedEvent extends VideoEvent {}

class FullScreenVideoEvent extends VideoEvent {}

class SeekVideoEvent extends VideoEvent {
  SeekVideoEvent(
    this.seekTo,
  );

  factory SeekVideoEvent.forward5Seconds(Duration currentPosition) =>
      SeekVideoEvent(currentPosition + const Duration(seconds: 5));

  factory SeekVideoEvent.backward5Seconds(Duration currentPosition) =>
      SeekVideoEvent(currentPosition - const Duration(seconds: 5));

  final Duration seekTo;
}

class VideoQualityChangedEvent extends VideoEvent {}

class AudioTrackChangedEvent extends VideoEvent {}

class ClosedCaptionsChangedEvent extends VideoEvent {}

class SubtitlesChangedEvent extends VideoEvent {}

class ScreenCastEvent extends VideoEvent {}
