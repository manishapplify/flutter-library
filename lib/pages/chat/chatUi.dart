import 'package:components/pages/chat/messageModel.dart';
import 'package:components/pages/chat/messageTile.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> messages = <ChatMessage>[
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(messageContent: "Hey Mayank...", messageType: "sender"),
    ChatMessage(messageContent: "How have you been?", messageType: "sender"),
    ChatMessage(
        messageContent: "I am fine dude. wbu?", messageType: "receiver"),
    ChatMessage(messageContent: "ehhhh, doing OK", messageType: "sender"),
    ChatMessage(
        messageContent: "Is there any thing wrong?", messageType: "sender"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png"),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text("Mayank"),
                      SizedBox(height: 6),
                      Text("Online"),
                    ],
                  ),
                ),
                const Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return MessageTile(
                message: messages[index].messageContent!,
                color: messages[index].messageType == "receiver"
                    ? Colors.grey
                    : Colors.blue,
                alignment: messages[index].messageType == "receiver"
                    ? Alignment.topLeft
                    : Alignment.topRight,
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Write message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
