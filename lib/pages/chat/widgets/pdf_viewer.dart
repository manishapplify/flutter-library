import 'package:components/pages/base_page.dart';
import 'package:components/pages/chat/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerPage extends BasePage {
  const PdfViewerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PdfViewerState();
}

class _PdfViewerState extends BasePageState<PdfViewerPage> {
  late final ChatBloc chatBloc;
  @override
  void initState() {
    chatBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  EdgeInsets get padding => EdgeInsets.zero;

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
    title: const Text('PDF'),
  );

  @override
  Widget body(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        chatBloc.add(OnPdfViewCloseEvent());
        return Future<bool>.value(true);
      },
      child: BlocBuilder<ChatBloc, ChatState>(
          builder: (BuildContext context, ChatState state) {
        return PDFView(
          filePath: state.downloadedPdfFilePath,
        );
      }),
    );
  }
}
