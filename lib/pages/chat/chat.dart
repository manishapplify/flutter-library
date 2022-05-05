import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:components/common/work_status.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/dialogs/dialogs.dart';
import 'package:components/common/app_exception.dart';
import 'package:components/pages/base_page.dart';
import 'package:components/pages/chat/bloc/bloc.dart';
import 'package:components/pages/chat/widgets/message_tile.dart';
import 'package:components/pages/chat/widgets/pdf_tile.dart';
import 'package:components/routes/navigation.dart';
import 'package:components/services/api/api.dart';
import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:components/services/firebase_realtime_database/models/message/message.dart';
import 'package:components/widgets/image_container.dart';

class ChatPage extends BasePage {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatState();
}

class _ChatState extends BasePageState<ChatPage> {
  late final ChatBloc chatBloc;
  late final User currentUser;
  late final TextEditingController textEditingController;
  late final ScrollController controller;
  bool firstBuild = true;
  late final String routedFrom;
  late final Api api;

  @override
  void initState() {
    final AuthCubit authCubit = BlocProvider.of(context);
    api = Api();
    if (!authCubit.state.isAuthorized) {
      throw AppException.authenticationException();
    }

    currentUser = authCubit.state.user!;
    chatBloc = BlocProvider.of(context)..add(GetCurrentChatMessagesEvent());

    Future<void>.microtask(() {
      routedFrom = routeSettings.arguments as String;
      if (routedFrom == Routes.users) {
        chatBloc
          ..add(GetChatsSubscriptionEvent())
          ..add(GetMessageSubscriptionsEvent());
      }
    });

    textEditingController = TextEditingController();
    controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    if (routedFrom == Routes.users) {
      chatBloc.add(ViewDisposeEvent());
    }

    textEditingController.dispose();
    super.dispose();
  }

  @override
  EdgeInsets get padding => EdgeInsets.zero;

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (BuildContext context, ChatState state) {
                if (state.currentChat is FirebaseChat) {
                  final FirebaseChat chat = state.currentChat!;
                  final String otherUserId = chat.participantIds.firstWhere(
                    (String id) => id != currentUser.firebaseId,
                  );

                  return Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 60,
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
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      );

  @override
  Widget body(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (chatBloc.state.pdfViewerStatus is InProgress) {
          return Future<bool>.value(false);
        }

        chatBloc.add(ChatPagePopEvent());
        return Future<bool>.value(true);
      },
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (BuildContext context, ChatState state) {
                  onStateChange(state);

                  final List<FirebaseMessage> messages =
                      state.messages.toList();
                  return Stack(
                    children: <Widget>[
                      ListView.builder(
                        controller: controller,
                        itemCount: messages.length,
                        padding: const EdgeInsets.all(16),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) =>
                            MessageTile(
                          message: messages[index],
                          currentUser: currentUser,
                        ),
                      ),
                      Visibility(
                        child: const Material(
                          color: Colors.transparent,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        visible: state.pdfViewerStatus is InProgress,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 8,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (BuildContext context, ChatState state) {
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    _ChatActions(
                      chatBloc: chatBloc,
                      state: state,
                      textEditingController: textEditingController,
                    ),
                    Visibility(
                      child: const Material(
                        color: Colors.transparent,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      visible: state.blocStatus is InProgress,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void onStateChange(ChatState state) {
    if (state.pdfViewerStatus is Success) {
      Future<void>.microtask(
        () => navigator.pushNamed(
          Routes.pdfViewerPage,
        ),
      );
    }

    if (state.blocStatus is Failure) {
      chatBloc.add(ResetBlocStatus());

      final Failure failure = state.blocStatus as Failure;

      // Navigate back in case current chat is deleted.
      if (failure.message == AppException.currentChatRemoved().message) {
        Future<void>.microtask(
          () => Navigator.of(context).pop(),
        );
      }

      Future<void>.microtask(
        () => showSnackBar(
          SnackBar(
            content: Text(failure.message ?? 'Failure'),
          ),
        ),
      );
    }

    if (state.currentChatMessagesFetched) {
      chatBloc.add(ResetCurrentChatMessagesFetched());

      Future<void>.microtask(
        () => controller.jumpTo(
          controller.position.maxScrollExtent,
        ),
      ).then(
        (_) => Future<void>.delayed(const Duration(milliseconds: 50)).then(
          (_) => controller.jumpTo(
            controller.position.maxScrollExtent,
          ),
        ),
      );
    }
    if (state.currentChatNewMessageReceived) {
      chatBloc.add(ResetCurrentChatNewMessageReceived());

      Future<void>.microtask(
        () => controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 700),
          curve: Curves.fastOutSlowIn,
        ),
      );
    }
  }
}

class _ChatActions extends StatelessWidget {
  const _ChatActions({
    Key? key,
    required this.textEditingController,
    required this.chatBloc,
    required this.state,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final ChatBloc chatBloc;
  final ChatState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () => onAddIconPressed(context),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.black,
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
        Expanded(
          child: state.pdfFile != null
              ? PdfTile(
                  fileName: state.pdfFile!.name,
                  closeButton: true,
                  onPressed: () {
                    chatBloc.add(
                      ClearDocMessageEvent(),
                    );
                  },
                )
              : state.imageFile != null
                  ? ImageContainer(
                      height: 150,
                      circularDecoration: false,
                      imagePath: state.imageFile?.path,
                      iconAlignment: Alignment.topRight,
                      overlayIcon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      onContainerTap: () {
                        chatBloc.add(
                          ClearImageMessageEvent(),
                        );
                      },
                    )
                  : TextField(
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        hintText: "Write message...",
                      ),
                      onChanged: (String message) =>
                          chatBloc.add(TextMessageChanged(message)),
                      onSubmitted: (_) => onMessageSend(),
                    ),
        ),
        const SizedBox(width: 15),
        IconButton(
          onPressed: () {
            state.imageFile != null
                ? onImageSend()
                : state.pdfFile != null
                    ? onDocSend()
                    : onMessageSend();
          },
          icon: const Icon(
            Icons.send,
            color: Colors.black,
            size: 20,
          ),
        ),
      ],
    );
  }

  void onAddIconPressed(BuildContext context) {
    showChatAttachmentPicker(
      context: context,
      onImageOptionPressed: () {
        Navigator.pop(context);
        showImagePickerPopup(
          context: context,
          onImagePicked: (File file) {
            if (!chatBloc.isClosed) {
              chatBloc.add(ImageUpdateEvent(imageFile: file));
            }
            Navigator.pop(context);
          },
        );
      },
      onPdfOptionPressed: () async {
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: <String>['pdf'],
        );

        if (result == null) {
          return;
        }

        chatBloc.add(PdfUpdateEvent(pdfFile: result.files.single));
        Navigator.pop(context);
      },
    );
  }

  void onMessageSend() {
    chatBloc.add(SendTextEvent());
    textEditingController.value = TextEditingValue.empty;
  }

  void onImageSend() {
    chatBloc.add(SendImageEvent());
  }

  void onDocSend() {
    chatBloc.add(SendDocEvent());
  }
}
