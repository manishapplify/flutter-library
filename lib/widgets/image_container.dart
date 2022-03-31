import 'dart:io';

import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    Key? key,
    this.imagePath,
    this.imageUrl,
    this.onContainerTap,
    this.circularDecoration = true,
    this.overlayIcon = const Icon(
      Icons.camera_enhance_rounded,
    ),
  }) : super(key: key);

  final String? imagePath;
  final String? imageUrl;
  final VoidCallback? onContainerTap;
  final bool circularDecoration;
  final Icon overlayIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onContainerTap,
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      child: Container(
        height: 100,
        width: 100,
        alignment: Alignment.bottomRight,
        child: onContainerTap is VoidCallback ? overlayIcon : null,
        decoration: BoxDecoration(
          shape: circularDecoration ? BoxShape.circle : BoxShape.rectangle,
          color: Colors.grey[300],
          image: DecorationImage(
            image:
                // Prefer to show selected image.
                imagePath is String && imagePath!.isNotEmpty
                    ? FileImage(File(imagePath!))
                    : imageUrl is String && imageUrl!.isNotEmpty
                        ? NetworkImage(imageUrl!) as ImageProvider
                        : const AssetImage("assets/images/avtar.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}