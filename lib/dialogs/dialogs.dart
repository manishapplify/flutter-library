import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

dynamic showImagePickerPopup(
    BuildContext context, Function(File) onImagePicked) {
  showCupertinoModalPopup(
    barrierColor: Colors.black45,
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text("Gallery"),
          onPressed: () async {
            final XFile? pickedFile = await ImagePicker()
                .pickImage(source: ImageSource.gallery, imageQuality: 20);
            imageCropper(context, pickedFile!.path, (File croppedImage) {
              onImagePicked(croppedImage);
            });
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          child: const Text("Camera"),
          onPressed: () async {
            final XFile? pickedFile = await ImagePicker()
                .pickImage(source: ImageSource.camera, imageQuality: 20);
            imageCropper(context, pickedFile!.path, (File croppedImage) {
              onImagePicked(croppedImage);
            });
            Navigator.pop(context);
          },
        ),
      ],
      cancelButton: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: CupertinoActionSheetAction(
          child: const Text("Cancel"),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}

dynamic imageCropper(
    BuildContext context, String imagePath, Function(File) onCropped) async {
  final File? croppedFile = await ImageCropper().cropImage(
    sourcePath: imagePath,
    compressQuality: 20,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    androidUiSettings: const AndroidUiSettings(
        toolbarTitle: "Edit Image",
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false),
    iosUiSettings: const IOSUiSettings(
      minimumAspectRatio: 1.0,
      aspectRatioLockDimensionSwapEnabled: true,
      aspectRatioLockEnabled: true,
    ),
  );
  if (croppedFile != null) {
    onCropped(croppedFile);
  }
}
