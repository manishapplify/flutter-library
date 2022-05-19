import 'dart:io';

import 'package:components/common/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// TODO: Disable multiselection of image in iOS.
// TODO(image manipulation): Register callbacks `onGallerySelected`, `onCameraSelected` instead calling `_pickImage`.
dynamic showImagePickerPopup({
  required BuildContext context,
  required Function(File) onImagePicked,
  VoidCallback? onGallerySelected,
  VoidCallback? onCameraSelected,
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
            onPressed: onGallerySelected!,
          ),
        if (cameraAllowed)
          CupertinoActionSheetAction(
            child: const Text(
              "Camera",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: onCameraSelected!,
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
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}

dynamic showChatAttachmentPicker({
  required BuildContext context,
  required VoidCallback onImageOptionPressed,
  required VoidCallback onPdfOptionPressed,
}) {
  showCupertinoModalPopup(
    barrierColor: Colors.black45,
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text(
            "Image",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onPressed: onImageOptionPressed,
        ),
        CupertinoActionSheetAction(
          child: const Text(
            "Document",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onPressed: onPdfOptionPressed,
        )
      ],
      cancelButton: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: CupertinoActionSheetAction(
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}

Future<File> _pickImage(ImageSource source) async {
  final XFile? pickedFile = await ImagePicker().pickImage(
    source: source,
    imageQuality: 20,
  );
  final File croppedImage = await cropImage(
    imagePath: pickedFile!.path,
  );
  return croppedImage;
}
