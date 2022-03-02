import 'dart:io';

import 'package:flutter/material.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({
    Key? key,
    required this.image,
    required this.edit,
  }) : super(key: key);

  final String image;
  final Function() edit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      alignment: Alignment.bottomRight,
      child: InkWell(
        onTap: this.edit,
        child: const Icon(Icons.camera_enhance_rounded),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
        image: DecorationImage(
          image: image.isEmpty
              ? const AssetImage("assets/images/avtar.png")
              : FileImage(File(image)) as ImageProvider,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
