import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

dynamic showImagePickerPopup({
  required BuildContext context,
  required Function(File) onImagePicked,
  bool galleryAllowed = true,
  bool cameraAllowed = true,
}) {
  showCupertinoModalPopup(
    barrierColor: Colors.black45,
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      actions: <Widget>[
        if (galleryAllowed)
          CupertinoActionSheetAction(
            child: const Text(
              "Gallery",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () async {
              final XFile? pickedFile = await ImagePicker()
                  .pickImage(source: ImageSource.gallery, imageQuality: 20);
              imageCropper(
                  imagePath: pickedFile!.path,
                  onCropped: (File croppedImage) {
                    onImagePicked(croppedImage);
                  });
            },
          ),
        if (cameraAllowed)
          CupertinoActionSheetAction(
            child: const Text(
              "Camera",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () async {
              final XFile? pickedFile = await ImagePicker()
                  .pickImage(source: ImageSource.camera, imageQuality: 20);
              imageCropper(
                  imagePath: pickedFile!.path,
                  onCropped: (File croppedImage) {
                    onImagePicked(croppedImage);
                  });
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

dynamic imageCropper({
  required String imagePath,
  required Function(File) onCropped,
}) async {
  final File? croppedFile = await ImageCropper().cropImage(
    sourcePath: imagePath,
    compressQuality: 20,
    aspectRatioPresets: <CropAspectRatioPreset>[
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
