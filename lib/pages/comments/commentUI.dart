import 'package:components/pages/comments/commentModel.dart';
import 'package:components/pages/comments/commentTile.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<CommentTileDetail> commentTileDetails = <CommentTileDetail>[
    CommentTileDetail(
        comment: "Good",
        userName: "Ritesh",
        userAvatar: "assets/images/user2.jpg"),
    CommentTileDetail(
        comment: "Fantastic",
        userName: "Raman",
        userAvatar: "assets/images/user3.jpg"),
    CommentTileDetail(
        comment: "Nice",
        userName: "Ritesh",
        userAvatar: "assets/images/user4.jpg"),
    CommentTileDetail(
        comment: "Good",
        userName: "Manoj",
        userAvatar: "assets/images/user5.jpg"),
    CommentTileDetail(
        comment: "Nice one",
        userName: "Ritika",
        userAvatar: "assets/images/user6.jpg"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text("Comments"),
      ),
      body: Stack(
        children: <Widget>[
          ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 8.0,
                color: Colors.transparent,
              );
            },
            itemCount: commentTileDetails.length,
            shrinkWrap: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return CommentTile(
                comment: commentTileDetails[index].comment,
                userName: commentTileDetails[index].userName,
                userAvatar: commentTileDetails[index].userAvatar,
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.all(10),
              // height: 70,
              width: double.infinity,
              color: Colors.white,
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: "Write a comment...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
