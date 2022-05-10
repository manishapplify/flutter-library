import 'package:components/common/functions.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/blocs/blocs.dart';
import 'package:components/pages/chat/widgets/pdf_tile.dart';
import 'package:components/services/firebase_realtime_database/models/message/document_message.dart';
import 'package:components/services/firebase_realtime_database/models/message/image_message.dart';
import 'package:components/services/firebase_realtime_database/models/message/message.dart';
import 'package:components/services/firebase_realtime_database/models/message/text_message.dart';

import 'package:components/common/widgets/image_container.dart';
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
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.70,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: message.isSentByCurrentUser(currentUser!.firebaseId)
              ? Colors.green[100]
              : Colors.grey[200],
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment:
              message.isSentByCurrentUser(currentUser!.firebaseId)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: <Widget>[
            _MessageContent(message),
            const SizedBox(
              height: 5,
            ),
            Text(
              displayMessageTime(
                message.messageTime,
              ),
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
            )
          ],
        ),
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
    if (message is AttachmentFirebaseMessage) {
      final AttachmentFirebaseMessage _message =
          message as AttachmentFirebaseMessage;

      if (_message is ImageMessage) {
        return ImageContainer(
          height: 200.0,
          width: 150.0,
          circularDecoration: false,
          imageUrl: _message.attachmentUrl,
        );
      } else if (_message is DocumentMessage) {
        return InkWell(
          onTap: () {
            BlocProvider.of<ChatBloc>(context).add(
              OpenDocEvent(
                docFilename: _message.message,
                docUrl: _message.attachmentUrl,
              ),
            );
          },
          child: PdfTile(
            fileName: _message.message,
            closeButton: false,
          ),
        );
      } else {
        return const SizedBox();
      }
    } else if (message is TextMessage) {
      return Text(message.message);
    } else {
      return const SizedBox();
    }
  }
}
