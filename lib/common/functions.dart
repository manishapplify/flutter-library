import 'dart:io';

import 'package:components/common/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:week_of_year/week_of_year.dart';

String displayMessageTime(DateTime? time) {
  if (time == null) {
    return '';
  }

  final DateTime now = DateTime.now();
  if (now.difference(time).compareTo(const Duration(days: 1)) < 0 &&
      now.day == time.day) {
    return '${time.hour <= 12 ? time.hour : time.hour % 12}:${time.minute < 10 ? '0${time.minute}' : time.minute} ${time.hour > 11 ? 'PM' : 'AM'}';
  } else if (time.weekOfYear == now.weekOfYear && time.year == now.year) {
    return _mapDay[time.weekday]!;
  } else if (time.year == now.year) {
    return '${time.day} ${_mapMonth[time.month]}';
  } else {
    return time.year.toString();
  }
}

Future<File> cropImage({
  required String imagePath,
  CropAspectRatioPreset cropAspectRatioPreset = CropAspectRatioPreset.original,
  int? maxImageWidth,
  int? maxImageHeight,
  CropStyle cropStyle = CropStyle.rectangle,
}) async {
  final CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: imagePath,
    compressQuality: 20,
    aspectRatio: cropAspectRatioPreset.toCropAspectRatio(),
    maxHeight: maxImageHeight,
    maxWidth: maxImageWidth,
    cropStyle: cropStyle,
    aspectRatioPresets: <CropAspectRatioPreset>[
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    uiSettings: <PlatformUiSettings>[
      AndroidUiSettings(
        toolbarTitle: 'Edit Image',
        toolbarColor: const Color(0xfff3dfa2),
        toolbarWidgetColor: Colors.black,
        activeControlsWidgetColor: const Color(0xffb71f3a),
        initAspectRatio: CropAspectRatioPreset.original,

        // If crop ratio is defined, don't let the user resize cropper.
        lockAspectRatio:
            cropAspectRatioPreset != CropAspectRatioPreset.original,
      ),
      IOSUiSettings(
        minimumAspectRatio: 1.0,
        title: 'Edit Image',
        aspectRatioLockDimensionSwapEnabled:
            cropAspectRatioPreset != CropAspectRatioPreset.original,
        aspectRatioLockEnabled:
            cropAspectRatioPreset != CropAspectRatioPreset.original,
            
      ),
    ],
  );

  if (croppedFile == null) {
    throw AppException.imageCouldNotBeCropped();
  }

  return File(croppedFile.path);
}

const Map<int, String> _mapDay = <int, String>{
  1: 'Mon',
  2: 'Tue',
  3: 'Wed',
  4: 'Thu',
  5: 'Fri',
  6: 'Sat',
  7: 'Sun',
};

const Map<int, String> _mapMonth = <int, String>{
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'Jun',
  7: 'Jul',
  8: 'Aug',
  9: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec',
};

extension _CropAspectRatioPresetEx on CropAspectRatioPreset {
  CropAspectRatio toCropAspectRatio() {
    switch (this) {
      case CropAspectRatioPreset.original:
      case CropAspectRatioPreset.square:
        return const CropAspectRatio(ratioX: 1, ratioY: 1);
      case CropAspectRatioPreset.ratio3x2:
        return const CropAspectRatio(ratioX: 3, ratioY: 2);
      case CropAspectRatioPreset.ratio5x3:
        return const CropAspectRatio(ratioX: 5, ratioY: 3);
      case CropAspectRatioPreset.ratio4x3:
        return const CropAspectRatio(ratioX: 4, ratioY: 3);
      case CropAspectRatioPreset.ratio5x4:
        return const CropAspectRatio(ratioX: 5, ratioY: 4);
      case CropAspectRatioPreset.ratio7x5:
        return const CropAspectRatio(ratioX: 7, ratioY: 5);
      case CropAspectRatioPreset.ratio16x9:
        return const CropAspectRatio(ratioX: 16, ratioY: 9);
    }
  }
}
