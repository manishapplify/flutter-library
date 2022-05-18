import 'dart:io';

import 'package:components/common/app_exception.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickingService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File> pickImage(
    ImagePickerConfiguration imagePickerConfiguration,
  ) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: imagePickerConfiguration.source.mapToImageSouce(),
      imageQuality: imagePickerConfiguration.imageQuality ?? 20,
      maxHeight: imagePickerConfiguration.maxHeight,
      maxWidth: imagePickerConfiguration.maxWidth,
      preferredCameraDevice: imagePickerConfiguration.preferredCameraDevice,
    );

    if (pickedFile == null) {
      throw AppException.imageCouldNotBePicked();
    }

    return File(pickedFile.path);
  }
}

class ImagePickerConfiguration {
  ImagePickerConfiguration({
    required this.source,
    this.imageQuality,
    this.maxWidth,
    this.maxHeight,
    this.preferredCameraDevice = CameraDevice.rear,
  });

  /// Specifies the source where the picked image should come from.
  final ImageSources source;

  /// The [imageQuality] argument modifies the quality of the image, ranging from 0-100
  /// where 100 is the original/max quality. If [imageQuality] is null, the image with
  /// the original quality will be returned. Compression is only supported for certain
  /// image types such as JPEG and on Android PNG and WebP, too. If compression is not supported for the image that is picked,
  /// a warning message will be logged.
  final int? imageQuality;

  /// If specified, the image will be at most [maxWidth] wide. Otherwise the
  /// image will be returned at it's original width.
  final double? maxWidth;

  /// If specified, the image will be at most [maxHeight] tall. Otherwise the
  /// image will be returned at it's original height.
  final double? maxHeight;

  /// Use [preferredCameraDevice] to specify the camera to use when the [source] is [ImageSource.camera].
  /// The [preferredCameraDevice] is ignored when [source] is [ImageSource.gallery]. It is also ignored if the chosen camera is not supported on the device.
  /// Defaults to [CameraDevice.rear]. Note that Android has no documented parameter for an intent to specify if
  /// the front or rear camera should be opened, this function is not guaranteed
  /// to work on an Android device.
  final CameraDevice preferredCameraDevice;
}

enum ImageSources {
  camera,
  gallery,
}

extension _ImageSourcesEx on ImageSources {
  ImageSource mapToImageSouce() {
    switch (this) {
      case ImageSources.camera:
        return ImageSource.camera;
      case ImageSources.gallery:
        return ImageSource.gallery;
    }
  }
}
