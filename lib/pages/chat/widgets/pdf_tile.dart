import 'package:flutter/material.dart';

class PdfTile extends StatelessWidget {
  const PdfTile({
    Key? key,
    required this.fileName,
    this.onPressed,
    required this.closeButton,
  }) : super(key: key);

  final String fileName;
  final Function()? onPressed;
  final bool closeButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (closeButton)
          IconButton(
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
              onPressed: closeButton ? onPressed : null),
        const Icon(
          Icons.picture_as_pdf,
          size: 40,
          color: Colors.red,
        ),
        const SizedBox(
          width: 6.0,
        ),
        Flexible(
          child: Text(
            fileName,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
