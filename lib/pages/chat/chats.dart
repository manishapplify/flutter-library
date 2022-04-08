import 'package:components/Authentication/form_submission.dart';
import 'package:components/base/base_page.dart';
import 'package:components/cubits/auth_cubit.dart';
import 'package:components/cubits/models/user.dart';
import 'package:components/exceptions/app_exception.dart';
import 'package:components/pages/chat/bloc/bloc.dart';
import 'package:components/pages/chat/widgets/chat_tile.dart';
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
    chatBloc = BlocProvider.of(context)..add(GetChatsEvent());
    super.initState();
  }

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (BuildContext context, ChatState state) {
        final List<FirebaseChat> chats = state.chats;
        return Stack(
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
                    // TODO: Redirect to chat page.
                  },
                  onTileLongPress: () {
                    // TODO: Option to delete the chat.
                  },
                );
              },
              itemCount: chats.length,
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
