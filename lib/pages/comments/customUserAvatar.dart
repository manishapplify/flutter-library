import 'package:flutter/material.dart';

class CustomUserAvatar extends StatelessWidget {
  const CustomUserAvatar(
      {Key? key,
      @required this.width,
      @required this.height,
      @required this.image})
      : super(key: key);
  final double? width;
  final double? height;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image!),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}
