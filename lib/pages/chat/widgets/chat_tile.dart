import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:components/widgets/image_container.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    required this.chat,
    required this.currentUserFirebaseId,
    required this.imageBaseUrl,
    required this.onTileTap,
    required this.onTileLongPress,
    Key? key,
  }) : super(key: key);

  final FirebaseChat chat;
  final String imageBaseUrl;
  final String currentUserFirebaseId;
  final VoidCallback onTileTap;
  final VoidCallback onTileLongPress;

  @override
  Widget build(BuildContext context) {
    late final String otherUserId = chat.participantIds
        .firstWhere((String id) => id != currentUserFirebaseId);
    late final String? otherUserName = chat.participantNames[otherUserId];
    late final String? otherUserProfilePic =
        chat.participantProfileImages?[otherUserId];

    return GestureDetector(
      onTap: onTileTap,
      onLongPress: onTileLongPress,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(otherUserName ?? otherUserId),
        leading: ImageContainer(
          imageUrl: (otherUserProfilePic is String)
              ? (imageBaseUrl + otherUserProfilePic)
              : null,
        ),
        trailing: Text(chat.lastMessage ?? ''),
      ),
    );
  }
}
