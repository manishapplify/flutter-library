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
    late final String otherUserId = chat.participantIds
        .firstWhere((String id) => id != currentUserFirebaseId);
    late final String? otherUserName = chat.participantNames[otherUserId];
    late final String? otherUserProfilePic =
        chat.participantProfileImages?[otherUserId];

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
                              _displayMessageTime(chat.lastMessageTime),
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
                          child: Text(
                            chat.lastMessage ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(fontWeight: FontWeight.w300),
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

  String _displayMessageTime(DateTime? time) {
    if (time == null) {
      return '';
    }

    final DateTime now = DateTime.now();
    if (now.difference(time).compareTo(const Duration(days: 1)) < 0 &&
        now.day == time.day) {
      return '${time.hour % 12}:${time.minute < 10 ? '0${time.minute}' : time.minute} ${time.hour > 11 ? 'PM' : 'AM'}';
    }

    // TODO: Also check if both the timestamps are in the same week.
    else if (now.difference(time).compareTo(const Duration(days: 7)) < 0) {
      return _mapDay[time.weekday]!;
    } else if (now.difference(time).compareTo(const Duration(days: 365)) < 0) {
      return '${time.day} ${_mapMonth[_mapMonth]}';
    } else {
      return time.year.toString();
    }
  }
}

const Map<int, String> _mapDay = <int, String>{
  1: 'Mon',
  2: 'Tue',
  3: 'Wed',
  4: 'Thu',
  5: 'Fri',
  6: 'Sat',
  7: 'Sun',
};

const Map<int, String> _mapMonth = <int, String>{
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'Jun',
  7: 'Jul',
  8: 'Aug',
  9: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec',
};
