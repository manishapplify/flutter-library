import 'dart:io';

import 'package:components/common/dialogs.dart';
import 'package:components/common/widgets/image_container.dart';
import 'package:components/routes/navigation.dart';
import 'package:flutter/material.dart';

Future<List<File>> multiImageSelectionBottomSheet({
  required BuildContext context,
  required void Function(List<File>) onImageSelectionDone,
  int maxImageSelection = 10,
  bool isSelectionRemovable = true,
}) async {
  final List<File> selectedImages = <File>[];

  await showModalBottomSheet<void>(
    context: context,
    routeSettings: const RouteSettings(
      name: Routes.multiImageSelectionBottomSheet,
    ),
    enableDrag: false,
    isDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (
          BuildContext context,
          void Function(void Function()) setState,
        ) {
          final double bottomSheetHeight =
              MediaQuery.of(context).size.height * 0.37;
          final double mainImageSelectionSize = bottomSheetHeight * 0.6;
          final double secondaryImagesSelectionSize = bottomSheetHeight * 0.30;

          return SizedBox(
            height: bottomSheetHeight,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 5,
                          child: Center(
                            child: selectedImages.isEmpty
                                ? const Text('Select an image')
                                : ImageContainer(
                                    height: mainImageSelectionSize,
                                    width: mainImageSelectionSize,
                                    iconAlignment: Alignment.topRight,
                                    circularDecoration: false,
                                    imageFile: selectedImages.first,
                                    onContainerTap: isSelectionRemovable
                                        ? () => setState(
                                              () => selectedImages.removeAt(0),
                                            )
                                        : null,
                                    overlayIcon: const Icon(
                                      Icons.cancel,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: mainImageSelectionSize,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _ActionIcon(
                                icon: Icons.cancel,
                                onTap: () => Navigator.of(context).pop(),
                              ),
                              const Spacer(),
                              if (selectedImages.length < maxImageSelection)
                                _ActionIcon(
                                  icon: Icons.add,
                                  onTap: () => showImagePickerPopup(
                                    context: context,
                                    onImagePicked: (File imageFile) {
                                      setState(
                                        () => selectedImages.add(imageFile),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (selectedImages.isNotEmpty)
                                _ActionIcon(
                                  icon: Icons.done,
                                  onTap: () async {
                                    final bool startUploading =
                                        (await startUploadingDialog(context)) ??
                                            false;

                                    if (startUploading) {
                                      onImageSelectionDone(selectedImages);
                                    }
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (selectedImages.length > 1)
                      SizedBox(
                        height: secondaryImagesSelectionSize,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, int index) => ImageContainer(
                            width: secondaryImagesSelectionSize,
                            imageFile: selectedImages[index + 1],
                            iconAlignment: Alignment.topRight,
                            circularDecoration: false,
                            onContainerTap: isSelectionRemovable
                                ? () => setState(
                                      () => selectedImages.removeAt(index + 1),
                                    )
                                : null,
                            overlayIcon: const Icon(
                              Icons.cancel,
                            ),
                          ),
                          itemCount: selectedImages.length - 1,
                          separatorBuilder: (_, __) => const SizedBox(
                            width: 5,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );

  return selectedImages;
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final void Function()? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

Future<bool?> startUploadingDialog(BuildContext context) => showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Upload Images'),
          content: const Text(
            'This may take a few moments.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'Okay',
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
