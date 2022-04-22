import 'package:components/services/firebase_realtime_database/models/user.dart';
import 'package:components/widgets/image_container.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    required this.user,
    required this.imageBaseUrl,
    required this.onMessageIconTap,
    Key? key,
  }) : super(key: key);

  final FirebaseUser user;
  final String imageBaseUrl;
  final VoidCallback onMessageIconTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey[200],
      contentPadding: EdgeInsets.zero,
      title: Text(user.name ?? user.id),
      leading: ImageContainer(
        imageUrl: (user.pic is String) ? (imageBaseUrl + user.pic!) : null,
      ),
      trailing: GestureDetector(
        onTap: onMessageIconTap,
        child: Material(
          color: Colors.grey[100],
          shape: const CircleBorder(),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.message,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
