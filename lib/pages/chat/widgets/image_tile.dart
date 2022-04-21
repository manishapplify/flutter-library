import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {
  const ImageTile({
    Key? key,
    required this.imageUrl,
    required this.alignment,
  }) : super(key: key);
  final String imageUrl;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Image.network(imageUrl),
    );
  }
}
