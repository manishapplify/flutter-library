part of blocs;

class VideoBloc extends BaseBloc<VideoEvent, VideoState> {
  VideoBloc() : super(const VideoState()) {
    on<VideoEvent>((VideoEvent event, Emitter<VideoState> emit) {
      // TODO: implement event handler
    });
  }
}
