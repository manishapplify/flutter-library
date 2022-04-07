import 'package:components/pages/comments/custom_user_avatar.dart';
import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    Key? key,
    @required this.comment,
    @required this.userName,
    @required this.userAvatar,
  }) : super(key: key);
  final String? comment;
  final String? userName;
  final String? userAvatar;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 12.0),
          child: CustomUserAvatar(
            height: 34.0,
            width: 34.0,
            image: userAvatar ?? "",
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey.shade200,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(userName!),
                        const Spacer(),
                        PopupMenuButton<dynamic>(
                          elevation: 0.0,
                          padding: const EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuItem<dynamic>>[
                            PopupMenuItem<dynamic>(
                              child: Column(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text("Report Comment"),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text("Delete Comment"),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Text(comment!),
                    const SizedBox(height: 6.0)
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: const <Widget>[
                  Text("Like"),
                  SizedBox(width: 10.0),
                  Text("Reply")
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
