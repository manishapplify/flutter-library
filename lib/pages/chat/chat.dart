import 'package:components/Authentication/form_submission.dart';
import 'package:components/base/base_page.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/pages/chat/bloc/bloc.dart';
import 'package:components/pages/chat/message_model.dart';
import 'package:components/pages/chat/message_tile.dart';
import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:components/widgets/image_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends BasePage {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatState();
}

class _ChatState extends BasePageState<ChatPage> {
  late final ChatBloc chatBloc;
  late final User currentUser;

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
  void initState() {
    final AuthCubit authCubit = BlocProvider.of(context);
    if (!authCubit.state.isAuthorized) {
      throw AppException.authenticationException;
    }

    currentUser = authCubit.state.user!;
    chatBloc = BlocProvider.of(context)..add(GetChatsEvent());
    super.initState();
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (BuildContext context, ChatState state) {
                final FirebaseChat chat = state.currentChat!;
                final String otherUserId = chat.participantIds.firstWhere(
                  (String id) => id != currentUser.firebaseId,
                );

                return Row(
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
                    ImageContainer(
                      height: 50,
                      width: 50,
                      imageUrl: chatBloc.imageBaseUrl +
                          (chat.participantProfileImages?[otherUserId] ?? ''),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(chat.participantNames[otherUserId] ?? ''),
                          const SizedBox(height: 6),
                          const Text("Online"),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.settings,
                      color: Colors.black54,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (BuildContext context, ChatState state) {
        return Stack(
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
            Visibility(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
              visible: state.blocStatus is FormSubmitting,
            )
          ],
        );
      },
    );
  }
}
