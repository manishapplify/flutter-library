import 'dart:io';

import 'package:flutter/material.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({
    Key? key,
    this.imagePath,
    this.imageUrl,
    this.edit,
  }) : super(key: key);

  final String? imagePath;
  final String? imageUrl;
  final VoidCallback? edit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.edit,
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      child: Container(
        height: 100,
        width: 100,
        alignment: Alignment.bottomRight,
        child: edit is VoidCallback
            ? const Icon(
                Icons.camera_enhance_rounded,
              )
            : null,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
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
