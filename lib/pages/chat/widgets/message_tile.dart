import 'package:components/cubits/models/user.dart';
import 'package:components/pages/chat/bloc/bloc.dart';
import 'package:components/pages/chat/widgets/pdf_tile.dart';
import 'package:components/services/firebase_realtime_database/models/message/document_message.dart';
import 'package:components/services/firebase_realtime_database/models/message/image_message.dart';
import 'package:components/services/firebase_realtime_database/models/message/message.dart';
import 'package:components/services/firebase_realtime_database/models/message/text_message.dart';
import 'package:components/widgets/image_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    Key? key,
    required this.message,
    this.currentUser,
  }) : super(key: key);

  final FirebaseMessage message;
  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8.0),
      alignment: message.isSentByCurrentUser(currentUser!.firebaseId)
          ? Alignment.topRight
          : Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: message is TextMessage
              ? message.isSentByCurrentUser(currentUser!.firebaseId)
                  ? const Color.fromARGB(255, 77, 192, 129)
                  : Colors.grey
              : null,
        ),
        padding: const EdgeInsets.all(12.0),
        child: _MessageContent(message),
      ),
    );
  }
}

class _MessageContent extends StatelessWidget {
  const _MessageContent(
    this.message, {
    Key? key,
  }) : super(key: key);

  final FirebaseMessage message;

  @override
  Widget build(BuildContext context) {
    if (message is TextMessage) {
      return Text(message.message);
    } else if (message is ImageMessage) {
      return ImageContainer(
        height: 200.0,
        width: 150.0,
        circularDecoration: false,
        imageUrl: (message as ImageMessage).attachmentUrl,
      );
    } else if (message is DocumentMessage) {
      return InkWell(
        onTap: () {
          BlocProvider.of<ChatBloc>(context).add(
            OpenDocEvent(
              docFilename: message.message,
              docUrl: (message as DocumentMessage).attachmentUrl,
            ),
          );
        },
        child: PdfTile(
          fileName: message.message,
          closeButton: false,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
