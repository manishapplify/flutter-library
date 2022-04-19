import 'package:components/authentication/form_submission.dart';
import 'package:components/base/base_page.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/pages/chat/bloc/bloc.dart';
import 'package:components/pages/chat/widgets/chat_tile.dart';
import 'package:components/routes/navigation.dart';
import 'package:components/services/firebase_realtime_database/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsPage extends BasePage {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatsState();
}

class _ChatsState extends BasePageState<ChatsPage> {
  late final ChatBloc chatBloc;
  late final User currentUser;

  @override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
        title: const Text('Chats'),
      );

  @override
  void initState() {
    final AuthCubit authCubit = BlocProvider.of(context);
    if (!authCubit.state.isAuthorized) {
      throw AppException.authenticationException;
    }

    currentUser = authCubit.state.user!;
    chatBloc = BlocProvider.of(context)
      ..add(GetChatsEvent())
      ..add(GetMessageSubscriptionsEvent());
    super.initState();
  }

  @override
  void dispose() {
    chatBloc.add(ViewDisposeEvent());
    super.dispose();
  }

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (BuildContext context, ChatState state) {
        if (state.blocStatus is SubmissionFailed) {
          final SubmissionFailed failure = state.blocStatus as SubmissionFailed;
          Future<void>.microtask(
            () => showSnackBar(
              SnackBar(
                content: Text(failure.message ?? 'Failure'),
              ),
            ),
          );
          chatBloc.add(ResetBlocStatus());
        }

        final List<FirebaseChat> chats = state.chats.toList();
        return WillPopScope(
          onWillPop: () {
            chatBloc.add(ResetBlocState());
            return Future<bool>.value(true);
          },
          child: Stack(
            children: <Widget>[
              ListView.separated(
                separatorBuilder: (_, __) => const SizedBox(
                  height: 8,
                ),
                itemBuilder: (BuildContext context, int i) {
                  final FirebaseChat chat = chats[i];

                  return ChatTile(
                    chat: chat,
                    imageBaseUrl: chatBloc.imageBaseUrl,
                    currentUserFirebaseId: currentUser.firebaseId,
                    onTileTap: () {
                      chatBloc.add(ChatOpenedEvent(chat));
                      Future<void>.microtask(
                        () => navigator.pushNamed(
                          Routes.chat,
                        ),
                      );
                    },
                    onTileLongPress: () => onChatTileLongPress(
                      context: context,
                      chat: chat,
                    ),
                  );
                },
                itemCount: chats.length,
              ),
              Visibility(
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
                visible: state.blocStatus is FormSubmitting,
              ),
            ],
          ),
        );
      },
    );
  }

  void onChatTileLongPress({
    required BuildContext context,
    required FirebaseChat chat,
  }) =>
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Delete chat'),
            content: const Text(
                'Are you sure? The chat will be deleted for both the users.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  chatBloc.add(RemoveChatEvent(chat));
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Okay',
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          );
        },
      );
}
