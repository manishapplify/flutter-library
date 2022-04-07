import 'package:components/services/firebase_realtime_database/models/user.dart';
import 'package:components/widgets/image_container.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({required this.user, Key? key}) : super(key: key);

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name ?? user.id),
      leading: ImageContainer(
        imageUrl: (user.pic is String)
            ? 'https://applify-library.s3.ap-southeast-1.amazonaws.com/users/' +
                user.pic!
            : null,
      ),
    );
  }
}
