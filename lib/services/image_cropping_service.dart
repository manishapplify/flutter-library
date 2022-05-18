import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:components/common/app_exception.dart';

class ImageCroppingService {
  final ImageCropper _imageCropper = ImageCropper();

  /// Launches the platform specific image cropper.
  Future<File> cropImage(
    ImageCropperConfiguration imageCropperConfiguration,
  ) async {
    final CroppedFile? croppedFile = await _imageCropper.cropImage(
      sourcePath: imageCropperConfiguration.imagePath,
      compressQuality: 20,
      aspectRatio:
          imageCropperConfiguration.cropAspectRatioPreset.toCropAspectRatio(),
      maxHeight: imageCropperConfiguration.maxImageHeight,
      maxWidth: imageCropperConfiguration.maxImageWidth,
      cropStyle: imageCropperConfiguration.cropStyle,
      aspectRatioPresets: <CropAspectRatioPreset>[
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: <PlatformUiSettings>[
        AndroidUiSettings(
          toolbarTitle: 'Edit Image',
          toolbarColor: const Color(0xfff3dfa2),
          toolbarWidgetColor: Colors.black,
          activeControlsWidgetColor: const Color(0xffb71f3a),
          initAspectRatio: CropAspectRatioPreset.original,

          // If crop ratio is defined, don't let the user resize cropper.
          lockAspectRatio: imageCropperConfiguration.cropAspectRatioPreset !=
              CropAspectRatioPreset.original,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          title: 'Edit Image',
          aspectRatioLockDimensionSwapEnabled:
              imageCropperConfiguration.cropAspectRatioPreset !=
                  CropAspectRatioPreset.original,
          aspectRatioLockEnabled:
              imageCropperConfiguration.cropAspectRatioPreset !=
                  CropAspectRatioPreset.original,
        ),
      ],
    );

    if (croppedFile == null) {
      throw AppException.imageCouldNotBeCropped();
    }

    return File(croppedFile.path);
  }
}

class ImageCropperConfiguration {
  ImageCropperConfiguration({
    required this.imagePath,
    this.maxImageWidth,
    this.maxImageHeight,
    this.cropAspectRatioPreset = CropAspectRatios.original,
    this.cropStyle = CropStyle.rectangle,
  });

  /// Path of the image.
  final String imagePath;

  /// Sets the ratio in which the image should be cropped. Resizing of the crop
  ///   bounds will be disabled for values other than [CropAspectRatios.original].
  final CropAspectRatios cropAspectRatioPreset;

  /// Maximum cropped image width.
  final int? maxImageWidth;

  /// Maximum cropped image height.
  final int? maxImageHeight;

  /// Controls the style of crop bounds, it can be rectangle or circle style.
  final CropStyle cropStyle;
}

enum CropAspectRatios {
  original,
  square,
  ratio3x2,
  ratio5x3,
  ratio4x3,
  ratio5x4,
  ratio7x5,
  ratio16x9
}

extension _CropAspectRatiosEx on CropAspectRatios {
  CropAspectRatio toCropAspectRatio() {
    switch (this) {
      case CropAspectRatios.original:
      case CropAspectRatios.square:
        return const CropAspectRatio(ratioX: 1, ratioY: 1);
      case CropAspectRatios.ratio3x2:
        return const CropAspectRatio(ratioX: 3, ratioY: 2);
      case CropAspectRatios.ratio5x3:
        return const CropAspectRatio(ratioX: 5, ratioY: 3);
      case CropAspectRatios.ratio4x3:
        return const CropAspectRatio(ratioX: 4, ratioY: 3);
      case CropAspectRatios.ratio5x4:
        return const CropAspectRatio(ratioX: 5, ratioY: 4);
      case CropAspectRatios.ratio7x5:
        return const CropAspectRatio(ratioX: 7, ratioY: 5);
      case CropAspectRatios.ratio16x9:
        return const CropAspectRatio(ratioX: 16, ratioY: 9);
    }
  }
}
