import 'dart:io';

import 'package:components/authentication/form_submission.dart';
import 'package:components/base/base_page.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/dialogs/dialogs.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/pages/chat/bloc/bloc.dart';

import 'package:components/pages/chat/widgets/message_tile.dart';
import 'package:components/routes/navigation.dart';
import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:components/services/firebase_realtime_database/models/message.dart';
import 'package:components/widgets/image_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

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

  @override
  void initState() {
    final AuthCubit authCubit = BlocProvider.of(context);
    if (!authCubit.state.isAuthorized) {
      throw AppException.authenticationException;
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
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (BuildContext context, ChatState state) {
        final List<FirebaseMessage> messages = state.messages.toList();

        if (state.blocStatus is SubmissionFailed) {
          chatBloc.add(ResetBlocStatus());

          final SubmissionFailed failure = state.blocStatus as SubmissionFailed;

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

        return WillPopScope(
          onWillPop: () async {
            chatBloc.add(ChatPagePopEvent());
            return Future<bool>.value(true);
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: messages.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    if (messages[index].messageType == 2) {
                      return Container(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        alignment: messages[index]
                                .isSentByCurrentUser(currentUser.firebaseId)
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: ImageContainer(
                          height: 200.0,
                          width: 150.0,
                          circularDecoration: false,
                          imageUrl: messages[index].attachmentUrl,
                        ),
                      );
                    } else if (messages[index].messageType == 3) {
                      return Align(
                        alignment: messages[index]
                                .isSentByCurrentUser(currentUser.firebaseId)
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: const Icon(
                          Icons.picture_as_pdf,
                          size: 80.0,
                        ),
                      );
                    } else {
                      return MessageTile(
                        message: messages[index].message,
                        color: messages[index]
                                .isSentByCurrentUser(currentUser.firebaseId)
                            ? const Color.fromARGB(255, 77, 192, 129)
                            : Colors.grey,
                        alignment: messages[index]
                                .isSentByCurrentUser(currentUser.firebaseId)
                            ? Alignment.topRight
                            : Alignment.topLeft,
                      );
                    }
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(alignment: Alignment.center, children: <Widget>[
                    Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            showChatAttachmentPicker(
                                context: context,
                                onImagePicked: () {
                                  Navigator.pop(context);
                                  showImagePickerPopup(
                                    context: context,
                                    onImagePicked: (File file) {
                                      if (!chatBloc.isClosed) {
                                        chatBloc
                                            .add(ImageEvent(imageFile: file));
                                      }
                                      if (mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                                  );
                                },
                                onPdfPicked: () async {
                                  final FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: <String>['pdf'],
                                  );

                                  if (result == null) {
                                    return;
                                  }

                                  chatBloc.add(
                                      PdfEvent(pdfFile: result.files.single));
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                });
                          },
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
                              ? Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        chatBloc.add(
                                          ClearDocMessageEvent(),
                                        );
                                      },
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Colors.red),
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        '.${state.pdfFile!.extension!}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6.0,
                                    ),
                                    Flexible(
                                      child: Text(
                                        state.pdfFile!.name,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
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
                                      onChanged: (String message) => chatBloc
                                          .add(TextMessageChanged(message)),
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
                    ),
                    Visibility(
                      child: const Material(
                        color: Colors.transparent,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      visible: state.blocStatus is FormSubmitting,
                    )
                  ]),
                ),
              ),
            ],
          ),
        );
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
