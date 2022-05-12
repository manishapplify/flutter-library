import 'dart:io';

import 'package:flutter/material.dart';

// TODO: Use imageFile parameter where applicable.
class ImageContainer extends StatelessWidget {
  const ImageContainer({
    Key? key,
    this.height = 100,
    this.width = 100,
    this.imagePath,
    this.imageFile,
    this.imageUrl,
    this.onContainerTap,
    this.iconAlignment = Alignment.bottomRight,
    this.circularDecoration = true,
    this.overlayIcon = const Icon(
      Icons.camera_enhance_rounded,
    ),
    this.border,
    this.borderRadius,
  }) : super(key: key);

  final String? imagePath;
  final File? imageFile;
  final String? imageUrl;
  final VoidCallback? onContainerTap;
  final bool circularDecoration;
  final Icon overlayIcon;
  final double? width;
  final double? height;
  final Alignment? iconAlignment;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onContainerTap,
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      child: Container(
        height: height,
        width: width,
        alignment: iconAlignment,
        child: onContainerTap is VoidCallback ? overlayIcon : null,
        decoration: BoxDecoration(
          shape: circularDecoration ? BoxShape.circle : BoxShape.rectangle,
          color: Colors.grey[300],
          image: DecorationImage(
            image:
                // Prefer to show selected image.
                imageFile != null ||
                        imagePath is String && imagePath!.isNotEmpty
                    ? FileImage(imageFile ?? File(imagePath!))
                    : imageUrl is String && imageUrl!.isNotEmpty
                        ? NetworkImage(imageUrl!) as ImageProvider
                        : const AssetImage("assets/images/avtar.png"),
            fit: BoxFit.fill,
          ),
          border: !circularDecoration
              ? border ??
                  Border.all(
                    color: Colors.grey[500]!,
                  )
              : null,
          borderRadius: !circularDecoration
              ? borderRadius ?? BorderRadius.circular(3)
              : null,
        ),
      ),
    );
  }
}
