part of blocs;

abstract class HomeEvent extends BaseEvent {}

class UploadImagesEvent extends HomeEvent {
  UploadImagesEvent(this.images);

  final List<File> images;
}

class ResetImageUploadStatus extends HomeEvent {}

class _OnUploadedImageUrlsLoadEvent extends HomeEvent {
  _OnUploadedImageUrlsLoadEvent(this.uploadedImageUrls);

  final List<String> uploadedImageUrls;
}
