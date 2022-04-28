import 'package:components/common/functions.dart';
import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:components/widgets/image_container.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    required this.chat,
    required this.currentUserFirebaseId,
    required this.imageBaseUrl,
    required this.onTileTap,
    required this.onTileDismissed,
    Key? key,
  }) : super(key: key);

  final FirebaseChat chat;
  final String imageBaseUrl;
  final String currentUserFirebaseId;
  final VoidCallback onTileTap;
  final Future<bool?> Function() onTileDismissed;

  @override
  Widget build(BuildContext context) {
    final String otherUserId = chat.participantIds
        .firstWhere((String id) => id != currentUserFirebaseId);
    final String? otherUserName = chat.participantNames[otherUserId];
    final String? otherUserProfilePic =
        chat.participantProfileImages?[otherUserId];
    final TextStyle messagePreviewTheme = Theme.of(context)
        .textTheme
        .headline3!
        .copyWith(fontWeight: FontWeight.w300);

    return GestureDetector(
      onTap: onTileTap,
      child: Dismissible(
        key: ValueKey<String>(chat.id),
        direction: DismissDirection.startToEnd,
        dismissThresholds: const <DismissDirection, double>{
          DismissDirection.startToEnd: 0.3,
        },
        confirmDismiss: (_) => onTileDismissed(),
        background: Container(
          color: Colors.red,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: SizedBox(
            height: kBottomNavigationBarHeight,
            child: Row(
              children: <Widget>[
                ImageContainer(
                  height: 80.0,
                  width: 80.0,
                  imageUrl: (otherUserProfilePic is String)
                      ? (imageBaseUrl + otherUserProfilePic)
                      : null,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              otherUserName ?? otherUserId,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              displayMessageTime(chat.lastMessageTime),
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: chat.lastMessageType == null
                              ? const SizedBox()
                              : chat.lastMessageType! == 2
                                  ? Row(
                                      children: <Widget>[
                                        ImageContainer(
                                          height: 25,
                                          width: 25,
                                          circularDecoration: false,
                                          imageUrl:
                                              chat.lastMessageAttachmentUrl,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Image',
                                          style: messagePreviewTheme,
                                        )
                                      ],
                                    )
                                  : Text(
                                      chat.lastMessage ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: messagePreviewTheme,
                                    ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
