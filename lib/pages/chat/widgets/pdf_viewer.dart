import 'package:flutter/material.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerPage extends StatelessWidget {
  const PdfViewerPage({
    Key? key,
    required this.filePath,
  }) : super(key: key);
  final String? filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PDF'),
        ),
        body: PDFView(
          filePath: filePath,
        ));
  }
}
